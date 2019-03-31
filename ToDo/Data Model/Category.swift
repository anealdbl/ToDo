//
//  Category.swift
//  ToDo
//
//  Created by Anil Dhaubhadel on 24/3/19.
//  Copyright © 2019 Anil Dhaubhadel. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
