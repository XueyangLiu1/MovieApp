//
//  AllMoviesView.swift
//  Movie
//
//  Created by LXY on 4/21/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct AllMoviesView: View {
    
    init(){
        UITableView.appearance().backgroundColor = .black
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
    }
    
    @State private var error = false
    @State private var errormsg = ""
    @State private var informConnectSuccess = false
    @State private var stayConnectSuccess = false
    @State private var movies:[Movie] = []
    @State private var realm:Realm?
    @State private var smallView: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                if self.stayConnectSuccess{
                    NavigationView{
                        List{
                            
                            ForEach(self.movies, id:\.name){movie in
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
                        .navigationBarTitle("Movies")
                        .navigationBarItems(trailing:
                            Button(action: {
                                self.smallView.toggle()
                            }){
                                Image(systemName: self.smallView ? "square.grid.2x2":"list.bullet")
                                    .padding([.top,.leading,.bottom],3)
                        })
                    }.blur(radius: self.stayConnectSuccess ? 0:15)
                }
                if !self.stayConnectSuccess{
                    LoadingView()
                }
            }
        }
        .onAppear(perform: connectDB)
        .alert(isPresented: self.$error, content: {
            Alert(title: Text("DataBase Error"), message: Text(self.errormsg),dismissButton: .default(Text("OK")))
        })
        .alert(isPresented: $informConnectSuccess, content: {
            Alert(title: Text("DataBase"), message: Text("Successfully connected to the database!"),
                dismissButton: .default(Text("OK"), action: {
                    if self.movies.count == 0{
                        self.getAllMovies()
                    }
            }))
        })
    }
    
    func getAllMovies(){
        while self.realm == nil {}
        let movieResult = self.realm?.objects(Movie.self)
        print(self.realm?.objects(Movie.self).count ?? 0)
        for elem in movieResult!{
            self.movies.append(elem)
        }
    }
    
//        for i in 1...movieResult!.count{
//            self.movies+=[movieResult![i-1]]
//        }
    
    
    func connectDB(){
        if !self.stayConnectSuccess{
            for u in SyncUser.all{
                u.value.logOut()
            }
            let creds = SyncCredentials.usernamePassword(username: Constants.admin, password: Constants.password, register: false)
            SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { (user, err) in
                if let error = err {
                    self.errormsg = "Failed to connect the database"
                    self.error = true
                    print("Failed to connect the database: \(error)")
                    return
                }
                print("Connected to DB!")
                let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
                self.realm = try! Realm(configuration: config!)
                while self.realm == nil{}
                self.informConnectSuccess = true
                self.stayConnectSuccess = true
            })
        }
    }
}

struct AllMoviesView_Previews: PreviewProvider {
    
    static var previews: some View {
        AllMoviesView()
    }
}
