//
//  FavouritesView.swift
//  Movie
//
//  Created by LXY on 4/21/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct FavouritesView: View {
    
    init(){
        UITableView.appearance().backgroundColor = .black
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
    }
    
    @EnvironmentObject var regularuser:RegularUser
    @State private var smallView = false
    @State private var favs:[Movie] = []
    @State private var realm:Realm?
    @State private var NoUser = false
    
    var body: some View {
        GeometryReader{geo in
            NavigationView{
                if self.NoUser == true{
                    VStack(alignment: .center){
                        Spacer()
                        Text("Please log in to use Favourites!")
                            .foregroundColor(Color.yellow)
                            .italic()
                            .font(.system(size: 30))
                        Spacer()
                    }.frame(width: geo.size.width,height: geo.size.height)
                        .background(Color.black)
                        .navigationBarTitle(Text("Favourites"),displayMode: .inline)
                }else{
                    List{
                        ForEach(self.favs, id:\.name){movie in
                            NavigationLink(destination: MovieDetailView(onemovie: movie)){
                                HStack{
                                    Image(movie.name)
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .shadow(color: .black, radius: 5)
                                    
                                    VStack(alignment: .leading){
                                        Spacer()
                                        Text("\(movie.name)")
                                            .font(self.smallView ? .headline : .title)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("\(movie.showStars)")
                                            .foregroundColor(.yellow)
                                        Spacer()
                                        RatingStarView(rating: .constant(movie.rating))
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: geo.size.width)
                                .frame(height: self.smallView ? 120 : 240)
                            }
                        }
                    }
                    .navigationBarTitle("Favourites")
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.smallView.toggle()
                        }){
                            Image(systemName: self.smallView ? "square.grid.2x2":"list.bullet")
                                .padding([.top,.leading,.bottom],3)
                    })
                }
            }
        }.onAppear(perform: load)
    }
    func load(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        if self.regularuser.username == ""{
            self.NoUser = true
        }else{
            self.NoUser = false
            self.favs = []
            let favsResult = self.realm?.objects(User.self).filter("username = '\(self.regularuser.username)'").first?.favourites
            for movie in favsResult!{
                self.favs.append(movie)
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
