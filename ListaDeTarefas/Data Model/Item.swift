//
//  Item.swift
//  ListaDeTarefas
//
//  Created by Paola Alcantara Soares on 07/02/22.
//

import Foundation
import RealmSwift
import DeveloperToolsSupport

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
