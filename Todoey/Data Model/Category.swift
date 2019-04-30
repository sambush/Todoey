//
//  Category.swift
//  Todoey
//
//  Created by Sam Bush on 4/21/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    //connects categoy to items - established one to many relationship
    //establishes that each Category can have a number of items, a list of item objects
    let items = List<Item>()
}
