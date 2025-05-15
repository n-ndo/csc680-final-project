//
//  AddPasswordViewModel.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import CoreData
import Foundation

class AddPasswordViewModel: ObservableObject {
    @Published var title = ""
    @Published var password = ""
    @Published var icon = "lock.shield"
    @Published var notes = ""
    @Published var showIconPicker = false

    func save(context: NSManagedObjectContext) {
        let entry = Entry(context: context)
        entry.id = UUID()
        entry.title = title
        entry.encryptedPassword = try? CryptoService.encrypt(password)
        entry.icon = icon
        entry.notes = notes
        entry.isFavorite = false
        entry.createdAt = Date()
        entry.updatedAt = nil
        try? context.save()
    }
}
