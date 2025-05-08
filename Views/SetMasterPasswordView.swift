import SwiftUI

struct SetMasterPasswordView: View {
    @Binding var isMasterPasswordSet: Bool
    @State private var masterPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Set Master Password")
                .font(.title)
                .padding()

            SecureField("Enter Password", text: $masterPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Save") {
                if masterPassword.isEmpty || confirmPassword.isEmpty {
                    errorMessage = "Both fields are required."
                } else if masterPassword != confirmPassword {
                    errorMessage = "Passwords do not match."
                } else {
                    UserDefaults.standard.set(masterPassword, forKey: "masterPassword")
                    UserDefaults.standard.set(true, forKey: "isMasterPasswordSet")
                    isMasterPasswordSet = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
