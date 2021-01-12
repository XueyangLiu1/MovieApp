//
//  MovieDetailView.swift
//  Movie
//
//  Created by LXY on 4/22/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct MovieDetailView: View {
    
    init(onemovie:Movie){
        self.movie = onemovie
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().backgroundColor = .black
    }
    
    let movie:Movie
    @State private var realm:Realm?
    @State private var NoUser = false
    @State private var isFav = false
    @EnvironmentObject var regularuser: RegularUser
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .bottom){
                ScrollView{
                    VStack(alignment: .leading){
                        ZStack(alignment: .bottomLeading){
                            Image(self.movie.name)
                                .resizable()
                                .scaledToFit()
                            Text(self.movie.name)
                                .foregroundColor(.white)
                                .font(.system(size: 36))
                                .bold()
                                .padding()
                        }
                        Text(self.movie.showGenre)
                            .foregroundColor(.yellow)
                            .bold()
                            .font(.system(size: 18))
                            .padding(.leading)
                            .padding(.bottom, 10)
                        HStack{
                            RatingStarView(rating: .constant(self.movie.rating))
                                .padding(.leading)
                            
                            Image(self.movie.Certificate)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width:45,height:45)
                                .padding(10)
                        }
                        
                        HStack{
                            VStack{
                                Text("Year")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 15))
                                    .bold()
                                    .padding(.top)
                                    .frame(height:16)
                                MyDivider().body.padding([.leading,.trailing]).padding(.bottom, 4)
                                Text(String(self.movie.year))
                                    .foregroundColor(Color.white)
                                    .bold()
                                    .padding(.bottom)
                                    .frame(height:16)
                            }.background(Color.secondary)
                            VStack{
                                Text("Language")
                                    .foregroundColor(Color.gray)
                                    .bold()
                                    .padding(.top)
                                    .frame(height:16)
                                MyDivider().body.padding([.leading,.trailing]).padding(.bottom, 4)
                                Text(self.movie.language)
                                    .foregroundColor(Color.white)
                                    .bold()
                                    .padding(.bottom)
                                    .frame(height:16)
                            }.background(Color.secondary)
                            VStack{
                                Text("Length")
                                    .foregroundColor(Color.gray)
                                    .bold()
                                    .padding(.top)
                                    .frame(height:16)
                                MyDivider().body.padding([.leading,.trailing]).padding(.bottom, 4)
                                Text("\(self.movie.length)min")
                                    .foregroundColor(Color.white)
                                    .bold()
                                    .padding(.bottom)
                                    .frame(height:16)
                            }.background(Color.secondary)
                        }.padding([.leading,.trailing])
                            .padding(.bottom, 35)
                        HStack{
                            Text("Director:")
                                .foregroundColor(.yellow)
                                .bold()
                                .font(.system(size: 15))
                            ForEach(self.movie.director, id:\.self){ director in
                                Text(director.name)
                                .foregroundColor(Color.white)
                                .font(.system(size: 15))
                                .bold()
                            }
                        }.padding(.leading)
                            .padding(.bottom, 5)
                        HStack(alignment: .top){
                            VStack{
                                Text("Stars:")
                                    .foregroundColor(.yellow)
                                    .bold()
                                    .font(.system(size: 15))
                            }
                            VStack{
                                Text(self.movie.commaStars)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 15))
                                    .bold()
                            }
                        }.padding(.leading)
                            .padding(.bottom, 35)
                        Text(self.movie.Description)
                            .foregroundColor(Color.white)
                            .font(.system(size: 15))
                            .bold()
                            .padding(.leading)
                        Spacer()
                    }
                    Spacer(minLength: 80)
                }
                NavigationLink(destination: SelectDateandTimeView(moviename: self.movie.name)){
                    Text("Book Now!")
                        .foregroundColor(.black)
                        .italic()
                        .font(.system(size: 30))
                }
                .frame(width: geo.size.width,height:60)
                .background(Color.yellow)
            }.background(Color.black)
        }
        .onAppear(perform: load)
        .navigationBarTitle(Text(""),displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: { self.favouriteToggle()
            }){
                Image(systemName: self.isFav ? "heart.fill" : "heart")
                    .foregroundColor(Color.yellow)
                    .padding([.top,.leading,.bottom],3)
        })
            .alert(isPresented: self.$NoUser){
                Alert(title: Text("No User!") , message: Text("Please log in first!"), dismissButton: .default(Text("OK"),action: {self.presentationMode.wrappedValue.dismiss()}))
        }
    }
    
    func favouriteToggle(){
        if self.regularuser.username == ""{
            self.NoUser = true
        }else if self.isFav{
                let favlist = self.realm?.objects(User.self).filter("username = '\(self.regularuser.username)'").first?.favourites
                var newFavlist:[Movie] = []
                for movie in favlist!{
                    if movie.name != self.movie.name{
                        newFavlist.append(movie)
                    }
                }
                try! self.realm!.write{
                    while favlist!.count>0{
                        favlist?.remove(at: 0)
                    }
                    for movie in newFavlist{
                        favlist?.append(movie)
                    }
                }
                self.isFav = false
            }else{
                let favlist = self.realm?.objects(User.self).filter("username = '\(self.regularuser.username)'").first?.favourites
                let AddMovie = self.realm?.objects(Movie.self).filter("name = '\(self.movie.name)'").first
                try! self.realm!.write{
                    favlist?.append(AddMovie!)
                }
                self.isFav = true
            }
        }
        
    func load(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        if self.regularuser.username != ""{
            let favs = self.realm?.objects(User.self).filter("username = '\(self.regularuser.username)'").first?.favourites
            for movie in favs!{
                if movie.name == self.movie.name{
                    self.isFav = true
                }
            }
        }
    }
}

struct MyDivider: View {
    let color: Color = .gray
    let width: CGFloat = 1.2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
        
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    
    static let Qstars:[Star] = [Star(name: "Jay Baruchel"),Star(name:"America Ferrera"),Star(name:"F. Murray Abraham")]
    static let Qgenres:[Genre] = [Genre(genre: "Animation"),Genre(genre: "Action"),Genre(genre: "Adventure"),Genre(genre: "Family"),Genre(genre: "Fantasy")]
    static let Qmovie = Movie(id: 1, name: "How to Train Your Dragon: The Hidden World", year: 2019, length: 104, rating: 4, certificate: "PG", director: Star(name: "Dean DeBlois"), description: "When Hiccup discovers Toothless isn't the only Night Fury, he must seek 'The Hidden World', a secret Dragon Utopia before a hired tyrant named Grimmel finds it first.", genres: Qgenres, stars: Qstars)
    
    static var previews: some View {
        MovieDetailView(onemovie: Qmovie)
    }
}
