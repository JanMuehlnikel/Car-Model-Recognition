import SwiftUI

struct HomeView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var imageName: String = ""
    @State private var predictedClass: String = ""
    @State private var showUploadButton: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "car.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    Text("Car Model Recognition")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 40)

                // Image Display
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .transition(.opacity)
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Text("No image selected")
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                    }
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
                    .cornerRadius(10)
                    .shadow(radius: 10)
                }
                .padding(.horizontal)

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
                                // Save the image locally
                                saveImageLocally(selectedImage)
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
                                .cornerRadius(10)
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
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }
                    }
                    .padding(.horizontal)
                }

                // Prediction Result
                if !predictedClass.isEmpty {
                    Text("Predicted Class: \(predictedClass)")
                        .font(.title2)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                        .transition(.opacity)
                }

                Spacer()
            }
            .navigationTitle("Home")
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(selectedImage: $selectedImage, imageName: $imageName, onImagePicked: { image in
                self.showUploadButton = true
                self.predictedClass = ""
            })
        })
    }

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://YOUR_FLASK_SERVER/upload") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = image.jpegData(compressionQuality: 0.7)
        var data = Data()

        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData!)
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let responseData = responseData else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response data"])))
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
               let predictedClass = json["predicted_class"] as? Int {
                completion(.success("Class \(predictedClass)"))
            } else {
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
