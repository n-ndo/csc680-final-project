import Foundation

struct Account: Identifiable, Hashable {
    let id = UUID()
    let service: String
    let username: String
    let password: String
}
