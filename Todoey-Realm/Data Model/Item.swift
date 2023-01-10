//
//  Data.swift
//  Todoey-Realm
//
//  Created by Sergio Ordaz Romero on 09/01/23.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isChecked: Bool = false
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
