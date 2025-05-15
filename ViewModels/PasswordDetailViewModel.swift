//
//  PasswordDetailViewModel.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque, Heber Josue Trujillo Cruz

import CoreData
import Foundation

class PasswordDetailViewModel: ObservableObject {
    @Published var title: String
    @Published var password: String
    @Published var icon: String
    @Published var notes: String
    @Published var showIconPicker: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var revealPassword: Bool = false
    @Published var createdAt: Date?
    @Published var updatedAt: Date?

    private let entry: Entry

    init(entry: Entry) {
        self.entry = entry
        title = entry.title ?? ""
        password =
            (try? CryptoService.decrypt(entry.encryptedPassword ?? Data()))
            ?? ""
        icon = entry.icon ?? "lock.shield"
        notes = entry.notes ?? ""
        createdAt = entry.createdAt
        updatedAt = entry.updatedAt
    }

    @MainActor
    func authenticateAndReveal() async {
        if await AuthenticationService.authenticateUser(
            reason: "Reveal Password")
        {
            revealPassword = true
        }
    }

    func save(context: NSManagedObjectContext) {
        entry.title = title
        entry.encryptedPassword = try? CryptoService.encrypt(password)
        entry.icon = icon
        entry.notes = notes
        entry.updatedAt = Date()
        try? context.save()
        updatedAt = entry.updatedAt
    }

    @MainActor
    func delete(context: NSManagedObjectContext) async {
        let confirmed = await AuthenticationService.authenticateUser(
            reason: "Confirm delete")
        if confirmed {
            context.delete(entry)
            try? context.save()
        }
    }
}
