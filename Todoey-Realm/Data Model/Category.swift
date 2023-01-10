//
//  Category.swift
//  Todoey-Realm
//
//  Created by Sergio Ordaz Romero on 09/01/23.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
