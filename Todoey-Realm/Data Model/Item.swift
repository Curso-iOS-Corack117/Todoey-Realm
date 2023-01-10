//
//  Data.swift
//  Todoey-Realm
//
//  Created by Sergio Ordaz Romero on 09/01/23.
//

import Foundation
import RealmSwift

@objcMembers
class Item: Object {
    dynamic var name: String = ""
    dynamic var isChecked: Bool = false
    dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    convenience init(name: String, isChecked: Bool) {
        self.init()
        self.name = name
        self.isChecked = isChecked
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
