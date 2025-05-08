import SwiftUI

struct AddAccountView: View {
    @State private var service = ""
    @State private var username = ""
    @State private var password = ""

    var onSave: (Account) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Service", text: $service)
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            }
            .navigationTitle("Add Account")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newAccount = Account(service: service, username: username, password: password)
                        onSave(newAccount)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onSave(Account(service: "", username: "", password: ""))
                    }
                }
            }
        }
    }
}
