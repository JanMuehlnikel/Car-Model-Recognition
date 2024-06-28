import SwiftUI

struct ResultView: View {
    let prediction: String
    let image: UIImage

    var body: some View {
        VStack {

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal)

            Text("Predicted Class: \(prediction)")
                .font(.title2)
                .padding(.top, 10)
            
            HStack {
                Button(action: {
                    // Handle thumbs up action
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                }
                .padding(.trailing, 40)

                Button(action: {
                    // Handle thumbs down action
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
                .padding(.leading, 40)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationTitle("Result")
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(prediction: "VW Golf", image: UIImage(named: "car_placeholder")!)
    }
}
