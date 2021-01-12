//
//  Movie.swift
//  Movie
//
//  Created by LXY on 4/21/20.
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
    
    convenience init(id:Int,name:String,year:Int,length:Int,rating:Int,certificate:String,director:Star,description:String,genres:[Genre],stars:[Star]) {
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
    
    var showStars:String{
        Stars[0].name+"\n"+Stars[1].name
    }
    
    var showGenre:String{
        if self.Genres.count == 1{
            return self.Genres[0].genre
        }else if self.Genres.count == 2{
            return self.Genres[0].genre+"|"+self.Genres[1].genre
        }else {
            return self.Genres[0].genre+"|"+self.Genres[1].genre+"|"+self.Genres[2].genre
        }
    }
    
    var commaStars:String{
        var commastars = Stars[0].name
        for i in 2...Stars.count{
            commastars = commastars+", "+Stars[i-1].name
        }
        return commastars
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
