//
//  Task.swift
//  taskapp
//
//  Created by 加島亮成 on 2018/04/27.
//  Copyright © 2018年 加島亮成. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""

    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
    
    override static func primaryKey() -> String? {
        return "id"
        

    }
    
}
