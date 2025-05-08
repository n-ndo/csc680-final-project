import SwiftUI

struct AccountDashboardView: View {
    @State private var showAddAccount = false
    @State private var accounts: [Account] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(accounts, id: \.self) { account in
                        NavigationLink(destination: AccountDetailView(account: account)) {
                            AccountCardView(account: account)
                        }
                    }

                    Button(action: { showAddAccount = true }) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                            Text("Add Account")
                        }
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("My Accounts")
            .sheet(isPresented: $showAddAccount) {
                AddAccountView { newAccount in
                    if !newAccount.service.isEmpty {
                        accounts.append(newAccount)
                    }
                    showAddAccount = false
                }
            }
        }
    }
}

