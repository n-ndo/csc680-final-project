import SwiftUI

struct AccountDetailView: View {
    let account: Account
    @State private var enteredPassword = ""
    @State private var isAuthenticated = false
    @State private var showPassword = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text(account.service)
                .font(.largeTitle)
                .padding(.top)

            Text("Username: \(account.username)")
                .font(.title2)

            if isAuthenticated {
                if showPassword {
                    Text("Password: \(account.password)")
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Button("Reveal Password") {
                        showPassword = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                SecureField("Enter Master Password", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Authenticate") {
                    let storedPassword = UserDefaults.standard.string(forKey: "masterPassword") ?? ""
                    if enteredPassword == storedPassword {
                        isAuthenticated = true
                    } else {
                        errorMessage = "Incorrect master password."
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }

            Spacer()
        }
        .padding()
    }
}
