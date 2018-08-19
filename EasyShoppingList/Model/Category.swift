//
//  Category.swift
//  EasyShoppingList
//
//  Created by eren cetin on 15/08/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    var noteItems =  List<NoteItem>()
}
