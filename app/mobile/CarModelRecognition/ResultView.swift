import SwiftUI

struct ResultView: View {
    var prediction: String
    @State private var showFeedbackView: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Prediction Result")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text(prediction)
                .font(.title)
                .foregroundColor(.blue)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .shadow(radius: 10)
            
            Spacer()
            
            // Feedback Button
            Button(action: {
                showFeedbackView.toggle()
            }) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("Give Feedback")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showFeedbackView) {
                FeedbackView()
            }
            
            // Back to Home Button
            NavigationLink(destination: CarModelRecognitionView()) {
                Text("Back to Home")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(prediction: "Porsche 911")
    }
}
