//
//  Constants.swift
//  RealmExp
//
//  Created by LXY on 4/16/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import Foundation

struct Constants {
    // **** Realm Cloud Users:
    // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
    // **** e.g., "mycoolapp.us1.cloud.realm.io"
    // ****
    // ****
    // **** ROS On-Premises Users
    // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
    // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"

    static let MY_INSTANCE_ADDRESS = "mymovieapp1.de1a.cloud.realm.io" // <- update this

    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let MOVIES_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/movies")!
    static let USERS_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/uers")!
}
