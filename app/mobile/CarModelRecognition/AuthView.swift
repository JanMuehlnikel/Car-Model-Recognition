import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $isLoginMode, label: Text("Mode")) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Button(action: handleAction) {
                    Text(isLoginMode ? "Log In" : "Sign Up")
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
            }
            .padding()
            .navigationTitle(isLoginMode ? "Log In" : "Sign Up")
        }
    }

    private func handleAction() {
        if isLoginMode {
            // Handle login
            loginUser()
        } else {
            // Handle sign up
            createUser()
        }
    }

    private func loginUser() {
        // Implement login functionality
        if email == "test@example.com" && password == "password" {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(email, forKey: "userEmail")
        } else {
            alertMessage = "Invalid email or password"
            showAlert = true
        }
    }

    private func createUser() {
        // Implement sign-up functionality
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(email, forKey: "userEmail")
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
