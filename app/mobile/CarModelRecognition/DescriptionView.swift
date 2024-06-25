import SwiftUI

struct DescriptionView: View {
    var body: some View {
        VStack {
            Text("About This App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("""
                This app uses a machine learning model to recognize the make and model of a car from an uploaded image. Simply choose an image from your gallery, and the app will analyze the image and provide the predicted car model.

                The app is designed to demonstrate the integration of machine learning models with iOS applications using a server-based approach.
                """)
                .padding()

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView()
    }
}
