import SwiftUI

struct FeedbackView: View {
    @State private var rating: Int = 0
    @State private var feedbackText: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Rate the Prediction")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                HStack {
                    ForEach(1..<6) { star in
                        Image(systemName: star <= self.rating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(star <= self.rating ? .yellow : .gray)
                            .onTapGesture {
                                self.rating = star
                            }
                    }
                }
                .padding()

                TextField("Enter your feedback", text: $feedbackText)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding()

                Button(action: submitFeedback) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                if showAlert {
                    Text(alertMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Feedback")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Thank You!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func submitFeedback() {
        guard rating > 0 else {
            alertMessage = "Please select a rating."
            showAlert = true
            return
        }

        // Save the feedback (this can be expanded to save to a backend or database)
        let feedback = Feedback(rating: rating, feedbackText: feedbackText)
        saveFeedback(feedback)

        // Reset the form
        rating = 0
        feedbackText = ""
        alertMessage = "Your feedback has been submitted."
        showAlert = true
    }

    private func saveFeedback(_ feedback: Feedback) {
        // Save the feedback locally (this can be expanded to save to a backend or database)
        let feedbackData = FeedbackData.loadFeedbacks()
        feedbackData.feedbacks.append(feedback)
        feedbackData.saveFeedbacks()
    }
}

struct Feedback: Codable {
    var rating: Int
    var feedbackText: String
}

class FeedbackData: ObservableObject {
    @Published var feedbacks: [Feedback]

    init(feedbacks: [Feedback] = []) {
        self.feedbacks = feedbacks
    }

    static func loadFeedbacks() -> FeedbackData {
        // Load feedbacks from UserDefaults (this can be expanded to load from a database)
        if let data = UserDefaults.standard.data(forKey: "feedbacks"),
           let feedbacks = try? JSONDecoder().decode([Feedback].self, from: data) {
            return FeedbackData(feedbacks: feedbacks)
        } else {
            return FeedbackData()
        }
    }

    func saveFeedbacks() {
        // Save feedbacks to UserDefaults (this can be expanded to save to a database)
        if let data = try? JSONEncoder().encode(feedbacks) {
            UserDefaults.standard.set(data, forKey: "feedbacks")
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
