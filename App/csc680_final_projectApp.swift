import SwiftUI

@main
struct csc680_final_projectApp: App {
    let persistence = PersistenceController.shared
    @State private var isUnlocked = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isUnlocked {
                    PasswordListView()
                        .environment(\.managedObjectContext, persistence.container.viewContext)
                        .environmentObject(SettingsService.shared)
                } else {
                    LockScreenView(isUnlocked: $isUnlocked)
                }
            }
        }
    }
}
