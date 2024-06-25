import SwiftUI

@main
struct CarModelRecognitionApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                AuthView()
            }
        }
    }
}
