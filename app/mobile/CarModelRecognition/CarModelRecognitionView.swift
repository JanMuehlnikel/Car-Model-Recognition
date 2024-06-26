import SwiftUI

struct CarModelRecognitionView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var imageName: String = ""
    @State private var predictedClass: String = ""
    @State private var showUploadButton: Bool = false
    @State private var isLoading: Bool = false
    @State private var showResultView: Bool = false
    @State private var savedImages: [UIImage] = []

    var body: some View {
        TabView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Text("Car Model Recognition")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)

                // Image Display
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .transition(.opacity)
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 120, height: 100)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Text("No image selected")
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
                    .transition(.opacity)
                }

                // Choose Image Button
                Button(action: {
                    self.showImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Choose an Image")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
                .padding(.horizontal)

                // Hinweistext
                Text("Only Porsche and Mercedes car models can be recognized.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                // Upload Image Button
                if showUploadButton {
                    Button(action: {
                        guard let selectedImage = selectedImage else { return }
                        isLoading = true
                        uploadImage(selectedImage) { result in
                            isLoading = false
                            switch result {
                            case .success(let prediction):
                                predictedClass = prediction
                                showResultView = true  // Zeige die Ergebnisseite
                                saveImageLocally(selectedImage)
                                loadSavedImages()
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                        } else {
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("Upload Image")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(
                NavigationLink(
                    destination: ResultView(prediction: predictedClass),
                    isActive: $showResultView,
                    label: { EmptyView() }
                )
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            InformationView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Information")
                }
            
            GalleryView(savedImages: $savedImages)
                .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Gallery")
                }
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(selectedImage: $selectedImage, imageName: $imageName, onImagePicked: { image in
                self.showUploadButton = true
                self.predictedClass = ""
            })
        })
        .onAppear {
            loadSavedImages()
        }
    }

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://134.155.233.49:5000") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = image.jpegData(compressionQuality: 0.7)
        var data = Data()

        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(UUID().uuidString).jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData!)
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                print("Upload Error: \(error)")
                completion(.failure(error))
                return
            }

            guard let responseData = responseData else {
                print("No response data")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response data"])))
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                print("Response JSON: \(json)")
                if let prediction = json["prediction"] as? String {
                    completion(.success(prediction))
                } else {
                    print("Invalid response format")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            } else {
                print("JSON deserialization failed")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            }
        }.resume()
    }

    func saveImageLocally(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".jpg")
        try? data.write(to: filename)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadSavedImages() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            savedImages = fileURLs.compactMap { UIImage(contentsOfFile: $0.path) }
        } catch {
            print("Error loading images: \(error)")
        }
    }
}

struct CarModelRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        CarModelRecognitionView()
    }
}
