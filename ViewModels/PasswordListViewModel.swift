//
//  PasswordListViewModel.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import CoreData
import Foundation

class PasswordListViewModel: ObservableObject {
    @Published var entries: [Entry] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetch()
    }

    func fetch() {
        let req: NSFetchRequest<Entry> = Entry.fetchRequest()
        req.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        entries = (try? context.fetch(req)) ?? []
    }
}
