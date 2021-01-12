//
//  ContentView.swift
//  Movie
//
//  Created by LXY on 4/20/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    init(){
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var regularuser = RegularUser()
    
    var body: some View {
        TabView{
            AllMoviesView()
                .tabItem{
                    Image(systemName: "film")
                    Text("Movies")
                }
            FavouritesView()
                .tabItem{
                    Image(systemName: "star")
                    Text("FAVOURITES")
                }
            MemberLoginView()
                .tabItem{
                    Image(systemName: "person")
                    Text("MEMBER")
                }
        }
        .background(Color.black)
        .accentColor(Color.yellow)
        .environmentObject(regularuser)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
