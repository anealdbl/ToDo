//
//  Item.swift
//  ToDo
//
//  Created by Anil Dhaubhadel on 24/3/19.
//  Copyright © 2019 Anil Dhaubhadel. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createdDate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
