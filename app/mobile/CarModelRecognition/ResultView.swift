import SwiftUI

struct ResultView: View {
    let prediction: String
    let image: UIImage

    var body: some View {
        VStack {
            Text("Prediction Result")
                .font(.largeTitle)
                .padding()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding()

            Text("Predicted Class: \(prediction)")
                .font(.title)
                .padding()

            Spacer()
        }
        .padding()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(prediction: "Car Model", image: UIImage(named: "car_placeholder")!)
    }
}
