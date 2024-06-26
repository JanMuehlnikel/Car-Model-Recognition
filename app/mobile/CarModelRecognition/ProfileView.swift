import SwiftUI

struct ProfileView: View {
    @State private var userName: String = UserDefaults.standard.string(forKey: "userEmail") ?? "John Doe"
    @State private var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "john.doe@example.com"
    @State private var profileImage = UIImage(systemName: "person.circle")
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding()
                    }

                    Text(userName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    Text(email)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)

                    Button(action: logout) {
                        Text("Log Out")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text("You are not logged in.")
                        .padding()
                    NavigationLink(destination: AuthView()) {
                        Text("Log In / Sign Up")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            userName = UserDefaults.standard.string(forKey: "userEmail") ?? "John Doe"
            email = UserDefaults.standard.string(forKey: "userEmail") ?? "john.doe@example.com"
        }
    }

    private func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
