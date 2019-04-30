//
//  Item.swift
//  Todoey
//
//  Created by Sam Bush on 4/21/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //establishes many to one relationship with items
    //inverse relationship, links each item back to a parent category, "items" comes from the category class
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
