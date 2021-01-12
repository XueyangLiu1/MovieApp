//
//  Constants.swift
//  Movie
//
//  Created by LXY on 4/21/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import Foundation

struct Constants {

    static let MY_INSTANCE_ADDRESS = "mymovieapp1.de1a.cloud.realm.io"

    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let MOVIES_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/movies")!
    static let USERS_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/uers")!
    
    static let admin = "Xueyang Liu"
    static let password = "123456"
}


