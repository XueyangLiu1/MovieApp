//
//  user.swift
//  RealmExp
//
//  Created by LXY on 4/16/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import Foundation
import RealmSwift

class User:Object{
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    @objc dynamic var Hpre = ""
    @objc dynamic var Vpre = ""
    let favourites = List<Movie>()
    let orders = List<Tickets>()
    
    convenience init(_ u: String,_ p: String){
        self.init()
        self.username = u
        self.password = p
    }
    
    override static func primaryKey() -> String? {
      return "username"
    }
}

