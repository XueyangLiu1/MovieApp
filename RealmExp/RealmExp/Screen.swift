//
//  Screen.swift
//  RealmExp
//
//  Created by LXY on 4/21/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import Foundation
import RealmSwift

class Screen: Object{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var screenId = 0
    @objc dynamic var moviename = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    let seats = List<Seat>()
    
    convenience init(screenId: Int,moviename:String,date:String,time:String,seats: [Seat]){
        self.init()
        self.screenId = screenId
        self.moviename=moviename
        self.date=date
        self.time = time
        for i in 1...seats.count{
            self.seats.append(seats[i-1])
        }
    }
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}


class Seat: Object{

    @objc dynamic var moviename = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var row = 1
    @objc dynamic var column = 1
    @objc dynamic var exist = true
    @objc dynamic var taken = false
    @objc dynamic var Hpre = ""
    @objc dynamic var Vpre = ""

    convenience init(moviename:String,date:String,time:String,row:Int,column:Int,exist:Bool){
        self.init()
        self.moviename = moviename
        self.date=date
        self.time = time
        self.row = row
        self.column = column
        self.exist = exist
        switch row{
        case 1,2:
            self.Vpre = "front"
        case 3,4:
            self.Vpre = "middle"
        case 5,6:
            self.Vpre = "back"
        default:
            self.Vpre = ""
        }
        switch column{
        case 1,2,7,8:
            self.Hpre = "side"
        case 3,4,5,6:
            self.Hpre = "center"
        default:
            self.Hpre = ""
        }
    }
    
    override static func primaryKey() -> String? {
      return "id"
    }
}

class Tickets:Object{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var Screenid = 0
    @objc dynamic var moviename = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var username = ""
    let seats = List<Seat>()
    
    convenience init(Screenid: Int,moviename:String,date:String,time:String,seats: [Seat],username:String){
        self.init()
        self.Screenid = Screenid
        self.moviename = moviename
        self.date=date
        self.time = time
        self.username = username
        for i in 1...seats.count{
            self.seats.append(seats[i-1])
        }
    }
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}
