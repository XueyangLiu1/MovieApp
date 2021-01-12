//
//  SelectDateandTimeView.swift
//  Movie
//
//  Created by LXY on 4/24/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct SelectDateandTimeView: View {
    
    init(moviename:String){
        self.moviename = moviename
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().backgroundColor = .black
    }
    
    let moviename:String
    @State private var loadCompleted = false
    @State private var realm: Realm?
    @State private var allPossible: [Screen] = []
    @State private var seatsCount = 1
    @EnvironmentObject var regularuser : RegularUser
    @State private var NoUser = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                VStack{
                    if self.loadCompleted && !self.allPossible.isEmpty{
                        Form{
                            Section{
                                Stepper("How many tickets?            \(self.seatsCount)", value: self.$seatsCount, in: 1...48)
                                    .foregroundColor(Color.yellow)
                                    .accentColor(Color.white)
                                    .background(Color.secondary)
                            }
                            Section(header: Text("Select one screen to continue").foregroundColor(.white)){
                                List{
                                    ForEach(self.selectAvailable(NumNeeded: self.seatsCount),id:\.id){screen in
                                        NavigationLink(destination: SelectSeatView(screen: screen,seatNum: self.seatsCount)){
                                            HStack{
                                                Text("Screen \(screen.screenId)")
                                                    .italic()
                                                    .foregroundColor(Color.yellow)
                                                Spacer()
                                                Text(screen.date)
                                                    .bold()
                                                    .foregroundColor(Color.white)
                                                Text(screen.time)
                                                    .bold()
                                                    .foregroundColor(Color.white)
                                                Spacer()
                                            }
                                            .frame(maxWidth: geo.size.width)
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        VStack(alignment: .center){
                            Spacer()
                            Text("The movie is currently not on!")
                                .foregroundColor(Color.yellow)
                                .italic()
                                .font(.system(size: 30))
                            Spacer()
                        }.frame(width: geo.size.width,height: geo.size.height)
                            .background(Color.black)
                    }
                }.blur(radius: self.loadCompleted && self.regularuser.username != "" ? 0:5)
                if !self.loadCompleted{
                    LoadingView()
                }
            }
            .onAppear(perform: self.load)
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.black)
            .navigationBarTitle(Text(self.moviename),displayMode: .inline)
            .alert(isPresented: self.$NoUser){
                Alert(title: Text("No User!") , message: Text("Please log in first!"), dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
        }
    }
    
    func load(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        while self.realm == nil{}
        let getScreens = self.realm?.objects(Screen.self).filter("moviename = '\(self.moviename)'").sorted(by:["date","time"])
        self.allPossible = []
        for elem in getScreens!{
            self.allPossible.append(elem)
        }
        self.NoUser = (self.regularuser.username == "")
        self.loadCompleted = true
    }
    
    func countAvailableSeats(screen:Screen)->Int{
        var count = 0
        for seat in screen.seats{
            if seat.exist == true && seat.taken == false{
                count+=1
            }
        }
        return count
    }
    
    func selectAvailable(NumNeeded: Int)->[Screen]{
        var result:[Screen] = []
        for screen in self.allPossible{
            if countAvailableSeats(screen:screen)>(NumNeeded-1){
                result.append(screen)
            }
        }
        return result
    }
}

struct SelectDateandTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateandTimeView(moviename: "The Wolf of Wall Street")
    }
}



