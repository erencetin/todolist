//
//  NoteItem.swift
//  EasyShoppingList
//
//  Created by eren cetin on 14/07/2018.
//  Copyright © 2018 eren cetin. All rights reserved.
//

import Foundation
class NoteItem: Encodable, Decodable{
    var noteText: String!
    var isComplete: Bool!
//    init(noteText: String, isComplete: Bool) {
//        self.noteText = noteText
//        self.isComplete = isComplete
//    }
//    required init(coder decoder: NSCoder) {
//        self.noteText = decoder.decodeObject(forKey: "noteText") as? String ?? ""
//        self.isComplete = decoder.decodeBool(forKey: "isComplete")
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(noteText, forKey: "noteText")
//        coder.encode(isComplete, forKey: "isComplete")
//    }
    
}
