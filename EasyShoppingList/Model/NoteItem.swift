//
//  NoteItem.swift
//  EasyShoppingList
//
//  Created by eren cetin on 15/08/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import Foundation
import RealmSwift
class NoteItem: Object {
    @objc dynamic var noteText : String = ""
    @objc dynamic var isCompleted : Bool = false
    @objc dynamic var dateCreated: Date? = nil
    var parentCategory = LinkingObjects(fromType: Category.self, property: "noteItems")
}
