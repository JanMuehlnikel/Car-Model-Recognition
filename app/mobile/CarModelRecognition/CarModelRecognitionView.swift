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

    let labelMapping: [Int: String] = [
        0: "BMW 1 Series", 1: "BMW 2 Series", 2: "BMW 2 Series Active Tourer", 3: "BMW 4 Series Gran Coupe", 4: "BMW 5 Series",
        5: "Porsche 911", 6: "Mercedes-Benz A Class", 7: "Mercedes-Benz C Class", 8: "Mercedes-Benz E Class", 9: "VW Golf",
        10: "BMW M4", 11: "Porsche Macan", 12: "VW Passat", 13: "VW Scirocco", 14: "VW Touareg",
        15: "BMW X3", 16: "BMW X5", 17: "BMW X6", 18: "VW up!"
    ]

    var body: some View {
        TabView {
            homeView
                .tabItem {
                    Image(systemName: "car.fill")
                    Text("Home")
                }

            resultView
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Results")
                }
            
            GalleryView(savedImages: $savedImages)
                .tabItem {
                    Image(systemName: "photo.stack")
                    Text("Gallery")
                }
            
            InformationView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Information")
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

    private var homeView: some View {
        NavigationView {
            VStack(spacing: 20) {
                

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
                            .frame(width: 180, height: 150)
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
                        Image(systemName: "photo.fill")
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
                Text("Please note that only car models from the brands Porsche, Mercedes, BMW, and Volkswagen can be recognized.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                // Upload Image Button
                if showUploadButton {
                    Button(action: {
                        guard let selectedImage = selectedImage else { return }
                        isLoading = true
                        uploadImage(image: selectedImage) { result in
                            isLoading = false
                            switch result {
                            case .success(let prediction):
                                if let label = labelMapping[prediction] {
                                    predictedClass = label
                                } else {
                                    predictedClass = "Unknown"
                                }
                            case .failure(let error):
                                print("Error: \(error)")
                                predictedClass = "Error"
                            }
                            showResultView = true
                            saveImageLocally(selectedImage)
                            loadSavedImages()
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
                    destination: ResultView(prediction: predictedClass, image: selectedImage ?? UIImage()),
                    isActive: $showResultView,
                    label: { EmptyView() }
                )
            )
            .navigationTitle("Car Recognition")
        }
    }

    private var resultView: some View {
        NavigationView {
            ResultView(prediction: predictedClass, image: selectedImage ?? UIImage())
                .navigationTitle("Results")
        }
    }

    func uploadImage(image: UIImage, completion: @escaping (Result<Int, Error>) -> Void) {
        let url = URL(string: "https://9de3-134-155-231-255.ngrok-free.app/predict")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }

        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let responseData = responseData else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response data"])
                completion(.failure(error))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let prediction = json["prediction"] as? Int {
                    completion(.success(prediction))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
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
