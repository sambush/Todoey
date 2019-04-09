//
//  Item.swift
//  Todoey
//
//  Created by Sam Bush on 4/4/19.
//  Copyright © 2019 Sam Bush. All rights reserved.
//

import Foundation
//add encodable to make the class encodable
class Item: Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
}


