//
//  Category.swift
//  ListaDeTarefas
//
//  Created by Paola Alcantara Soares on 07/02/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
