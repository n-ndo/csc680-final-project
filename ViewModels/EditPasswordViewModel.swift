//
//  EditPasswordViewModel.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque, Heber Josue Trujillo Cruz

import CoreData
import Foundation

class EditPasswordViewModel: ObservableObject {
    @Published var title: String
    @Published var password: String
    @Published var icon: String
    @Published var notes: String
    @Published var showIconPicker = false

    private let entry: Entry

    init(entry: Entry) {
        self.entry = entry
        title = entry.title ?? ""
        password = ""
        icon = entry.icon ?? "lock.shield"
        notes = entry.notes ?? ""
    }

    func save(context: NSManagedObjectContext) {
        entry.title = title
        if !password.isEmpty {
            entry.encryptedPassword = try? CryptoService.encrypt(password)
        }
        entry.icon = icon
        entry.notes = notes
        entry.updatedAt = Date()
        try? context.save()
    }
}
