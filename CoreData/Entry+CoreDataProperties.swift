//
//  Entry+CoreDataProperties.swift
//  csc680-final-project
//
//  By Fernando Abel Malca Luque

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var encryptedPassword: Data?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var notes: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?

}

extension Entry : Identifiable {

}
