//
//  Persistence.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        controller.initializeSampleData()
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "csc680_final_project")

        if inMemory, let description = container.persistentStoreDescriptions.first {
            description.url = URL(fileURLWithPath: "/dev/null")
            description.shouldAddStoreAsynchronously = true
        }
        container.persistentStoreDescriptions.forEach { $0.shouldAddStoreAsynchronously = true }

        let viewContext = container.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading store: \(error)")
            }
        }
    }

    private func initializeSampleData() {
        let ctx = container.viewContext

        for i in 0..<5 {
            let entry = Entry(context: ctx)
            entry.id                = UUID()
            entry.title             = "Example \(i + 1)"
            entry.notes             = "Sample note \(i + 1)"
            entry.icon              = "lock.shield"
            entry.encryptedPassword = try? CryptoService.encrypt("pass\(i + 1)")
            entry.isFavorite        = Bool.random()
            entry.createdAt         = Date()
            entry.updatedAt         = Date()
        }

        do {
            try ctx.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to save preview data: \(nsError), \(nsError.userInfo)")
        }
    }
}
