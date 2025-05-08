import SwiftUI

struct AccountCardView: View {
    let account: Account

    var body: some View {
        VStack(spacing: 10) {
            Text(account.service)
                .font(.headline)
            Text(account.username)
                .font(.subheadline)
        }
        .frame(width: 100, height: 100)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(12)
    }
}
