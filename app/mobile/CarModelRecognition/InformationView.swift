import SwiftUI

struct InformationView: View {
    var body: some View {
        VStack {
            Text("About This Project")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("""
                This app uses a machine learning model to recognize the make and model of a car from an uploaded image. Simply choose an image from your gallery, and the app will analyze the image and provide the predicted car model. The app was created as part of a project at the Cooperative State University Baden-Wuerttemberg by Jan Mühlnikel and Luca Mohr.
                
                Have Fun!
                """)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Information")
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
