//
//  Data.swift
//  Todoey
//
//  Created by Sam Bush on 4/21/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    //must use @objc dynamic so that Realm can change the variable in the database while the app is running
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
