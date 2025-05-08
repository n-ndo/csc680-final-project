import SwiftUI

@main
struct csc680_final_projectApp: App {
    @State private var isMasterPasswordSet = UserDefaults.standard.bool(forKey: "isMasterPasswordSet")

    var body: some Scene {
        WindowGroup {
            if isMasterPasswordSet {
                ContentView()
            } else {
                SetMasterPasswordView(isMasterPasswordSet: $isMasterPasswordSet)
            }
        }
    }
}
