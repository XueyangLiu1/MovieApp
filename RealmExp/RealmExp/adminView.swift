//
//  adminView.swift
//  RealmExp
//
//  Created by LXY on 4/20/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct adminView: View {
    
    @State private var alert = false
    
    @State private var logoutsuccess = false
    
    @State var realm: Realm?
    @State var items: Results<Movie>?
    @State var item: Movie?
    
    var body: some View {
        VStack{
            List{
                
                Button(action:{
                    self.alert = true
                }){
                    Text("Log out")
                        .padding()
                        .fixedSize()
                        .frame(width:150,height: 35)
                        .foregroundColor(.yellow)
                        .background(Color.black)
                        .cornerRadius(8)
                }.alert(isPresented: $alert){
                    Alert(title: Text("Log out"), message: Text("Are you sure to log out?"), primaryButton: .cancel(), secondaryButton: .default(Text("Yes"), action: {
                        SyncUser.current?.logOut()
                        self.logoutsuccess = true
                    }))
                }
                
                Button(action:{
                    self.writeSampleMovies(realm: self.realm!)
                }){
                    Text("write movie")
                        .padding()
                        .fixedSize()
                        .frame(width:150,height: 35)
                        .foregroundColor(.yellow)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                
                Button(action:{
                    self.writeSampleScreenforMovies(realm: self.realm!)
                }){
                    Text("write screen")
                        .padding()
                        .fixedSize()
                        .frame(width:150,height: 35)
                        .foregroundColor(.yellow)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                
                
            }
        }
        .onAppear(perform: connect)
        .navigate(to: ContentView(), when: $logoutsuccess)
    }
    func connect(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
    }
    func writeSampleMovies(realm: Realm){
        
        let Qstars:[Star] = [Star(name: "Jay Baruchel"),Star(name:"America Ferrera"),Star(name:"F. Murray Abraham")]
        let Qgenres:[Genre] = [Genre(genre: "Animation"),Genre(genre: "Action"),Genre(genre: "Adventure"),Genre(genre: "Family"),Genre(genre: "Fantasy")]
        let Qmovie = Movie(id: 1, name: "How to Train Your Dragon: The Hidden World", year: 2019, length: 104, rating: 4, certificate: "PG", director: Star(name:"Dean DeBlois"), description: "When Hiccup discovers Toothless isn't the only Night Fury, he must seek 'The Hidden World', a secret Dragon Utopia before a hired tyrant named Grimmel finds it first.", genres: Qgenres, stars: Qstars,language: "English")
        
        let Wstars:[Star] = [Star(name: "Leonardo DiCaprio"),Star(name:"Jonah Hill"),Star(name:"Margot Robbie")]
        let Wgenres:[Genre] = [Genre(genre: "Biography"),Genre(genre: "Crime"),Genre(genre: "Drama")]
        let Wmovie = Movie(id: 2, name: "The Wolf of Wall Street", year: 2013, length: 180, rating: 4, certificate: "18", director: Star(name:"Martin Scorsese"), description: "Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker living the high life to his fall involving crime, corruption and the federal government.", genres: Wgenres, stars: Wstars,language: "English")
        
        let Estars:[Star] = [Star(name: "Joaquin Phoenix"),Star(name:"Robert De Niro"),Star(name:"Zazie Beetz")]
        let Egenres:[Genre] = [Genre(genre: "Crime"),Genre(genre: "Drama"),Genre(genre: "Thriller")]
        let Emovie = Movie(id:3, name: "Joker", year: 2019, length: 122, rating: 5, certificate: "15", director: Star(name:"Todd Phillips"), description: "In Gotham City, mentally troubled comedian Arthur Fleck is disregarded and mistreated by society. He then embarks on a downward spiral of revolution and bloody crime. This path brings him face-to-face with his alter-ego: the Joker.", genres: Egenres, stars: Estars,language: "English")
        
        let Rstars:[Star] = [Star(name: "Leonardo DiCaprio"),Star(name:"Joseph Gordon-Levitt"),Star(name:"Ellen Page")]
        let Rgenres:[Genre] = [Genre(genre: "Action"),Genre(genre: "Adventure"),Genre(genre: "Sci-Fi"),Genre(genre: "Thriller")]
        let Rmovie = Movie(id: 4, name: "Inception", year: 2010, length: 148, rating: 5, certificate: "12A", director: Star(name:"Christopher Nolan"), description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.", genres: Rgenres, stars: Rstars,language: "English")
        
        let Tstars:[Star] = [Star(name: "Tim Robbins"),Star(name:"Morgan Freeman"),Star(name:"Bob Gunton")]
        let Tgenres:[Genre] = [Genre(genre: "Drama")]
        let Tmovie = Movie(id: 5, name: "The Shawshank Redemption", year: 1994, length: 142, rating: 4, certificate: "15", director: Star(name:"Frank Darabont"), description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", genres: Tgenres, stars: Tstars,language: "English")
        
        let Ystars:[Star] = [Star(name: "Jean Reno"),Star(name:"Gary Oldman"),Star(name:"Natalie Portman")]
        let Ygenres:[Genre] = [Genre(genre: "Action"),Genre(genre: "Crime"),Genre(genre: "Drama"),Genre(genre: "Thriller")]
        let Ymovie = Movie(id: 6, name: "Leon", year: 1994, length: 110, rating: 5, certificate: "18", director: Star(name:"Luc Besson"), description: "Mathilda, a 12-year-old girl, is reluctantly taken in by Léon, a professional assassin, after her family is murdered. An unusual relationship forms as she becomes his protégée and learns the assassin's trade.", genres: Ygenres, stars: Ystars,language: "English")
        
        let Ustars:[Star] = [Star(name: "Ryan Gosling"),Star(name:"Emma Stone"),Star(name:"Rosemarie DeWitt")]
        let Ugenres:[Genre] = [Genre(genre: "Comedy"),Genre(genre: "Drama"),Genre(genre: "Music"),Genre(genre: "Musical"),Genre(genre: "Romance")]
        let Umovie = Movie(id: 7, name: "La La Land", year: 2016, length: 128, rating: 4, certificate: "12A", director: Star(name:"Damien Chazelle"), description: "While navigating their careers in Los Angeles, a pianist and an actress fall in love while attempting to reconcile their aspirations for the future.", genres: Ugenres, stars: Ustars,language: "English")
        
        print(self.realm?.objects(Movie.self).count ?? 0)
        try! realm.write{
            realm.add(Qmovie, update: .all)
            realm.add(Wmovie, update: .all)
            realm.add(Emovie, update: .all)
            realm.add(Rmovie, update: .all)
            realm.add(Tmovie, update: .all)
            realm.add(Ymovie, update: .all)
            realm.add(Umovie, update: .all)
        }
        print(self.realm?.objects(Movie.self).count ?? 0)
    }

    
    func generateSeats(screenId: Int,moviename:String,time:String)->[Seat]{
        var seatArray:[Seat] = []
        if screenId == 1{
            for i in 1...6{
                for j in 1...8{
                    seatArray+=[Seat(moviename: moviename, date: "25/04", time: time, row: i, column: j, exist: true)]
                }
            }
        }
        if screenId == 2{
            for i in 1...6{
                for j in 1...8{
                    let seat = Seat(moviename: moviename, date: "25/04", time: time, row: i, column: j, exist: true)
                    if (i<=2&&j<=2)||(i==6&&j==8){
                        seat.exist = false
                    }
                    seatArray+=[seat]
                }
            }
        }
        return seatArray
    }
    
    func writeSampleScreenforMovies(realm:Realm){
        let movienames = ["How to Train Your Dragon: The Hidden World","The Wolf of Wall Street","Inception"]
        let time = ["14:50","17:30","20:20"]
        for i in 1...2{
            for j in 1...3{
                let screen = Screen(screenId: i, moviename: movienames[j-1], date: "25/04", time: time[j-1], seats: generateSeats(screenId: i, moviename: movienames[j-1], time: time[j-1]))
                try! realm.write{
                    realm.add(screen,update: .all)
                }
            }
        }
    }
    
}


struct adminView_Previews: PreviewProvider {
    static var previews: some View {
        adminView()
    }
}
