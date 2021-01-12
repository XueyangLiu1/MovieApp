//
//  Movie.swift
//  RealmExp
//
//  Created by LXY on 4/16/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: Object{
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var year = 0
    @objc dynamic var length = 0
    @objc dynamic var rating = 0
    @objc dynamic var Certificate = ""
    let Genres = List<Genre>()
    let director = List<Star>()
    let Stars = List<Star>()
    @objc dynamic var Description = ""
    @objc dynamic var language = "English"
    @objc dynamic var timestamp: Date = Date()
    
    override static func primaryKey() -> String? {
      return "name"
    }
    
    convenience init(id:Int,name:String,year:Int,length:Int,rating:Int,certificate:String,director:Star,description:String,genres:[Genre],stars:[Star],language:String) {
        self.init()
        self.id=id
        self.name=name
        self.year=year
        self.length=length
        self.rating=rating
        self.Certificate=certificate
        self.language = language
        self.director.append(director)
        self.Description = description
        for i in 1...genres.count{
            self.Genres.append(genres[i-1])
        }
        for i in 1...stars.count{
            self.Stars.append(stars[i-1])
        }
    }
    
}

class Star: Object{
    @objc dynamic var name = ""
    
    convenience init(name: String){
        self.init()
        self.name = name
    }
    
    override static func primaryKey() -> String? {
      return "name"
    }
}

class Genre: Object{
    @objc dynamic var genre = ""
    
    convenience init(genre: String){
        self.init()
        self.genre = genre
    }
    
    override static func primaryKey() -> String? {
      return "genre"
    }
}
