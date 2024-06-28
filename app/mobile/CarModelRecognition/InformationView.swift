import SwiftUI

struct InformationView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("This app uses a machine learning model to recognize the make and model of a car from an uploaded image. Simply choose an image from your gallery, and the app will analyze the image and provide the predicted car model. The app was created as part of a project at the Cooperative State University Baden-Wuerttemberg by Jan Mühlnikel and Luca Mohr. Have Fun!")
                    .font(.body)
                    .padding()

                Spacer()

                // GitHub Button
                Button(action: {
                    openGitHubRepo()
                }) {
                    HStack {
                        Image(systemName: "brain.filled.head.profile")
                        Text("Visit our GitHub Repo!")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("Information")
        }
    }

    func openGitHubRepo() {
        if let url = URL(string: "https://github.com/JanMuehlnikel/Car-Model-Recognition") {
            UIApplication.shared.open(url)
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
