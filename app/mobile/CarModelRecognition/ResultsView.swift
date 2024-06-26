import SwiftUI

struct ResultsView: View {
    @Binding var predictions: [CarModelPrediction]

    var body: some View {
        NavigationView {
            List(predictions) { prediction in
                VStack(alignment: .leading) {
                    if let image = prediction.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                    }
                    Text("Predicted Class: \(prediction.predictedClass)")
                        .font(.headline)
                }
                .padding()
            }
            .navigationTitle("Results")
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(predictions: .constant([CarModelPrediction()]))
    }
}
