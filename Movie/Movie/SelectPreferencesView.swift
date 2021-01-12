//
//  SelectPreferencesView.swift
//  Movie
//
//  Created by LXY on 4/26/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct SelectPreferencesView: View {
    
    init(){
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .yellow
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.yellow], for: .normal)
    }
    
    static let Hpres = ["center","side"]
    static let Vpres = ["front","middle","back"]
    @State private var Hpre = 0
    @State private var Vpre = 0
    @State private var realm: Realm?
    @EnvironmentObject var regularuser: RegularUser
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{geo in
            VStack{
                Form{
                    Text("Horizontal Preference")
                        .foregroundColor(Color.yellow)
                        .italic()
                    Picker("Horizontal Preference",selection: self.$Hpre){
                        ForEach(Self.Hpres.indices,id:\.self){
                            Text(Self.Hpres[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.secondary)
                    Text("Vertical Preference")
                    .foregroundColor(Color.yellow)
                    .italic()
                    Picker("Vertical Preference", selection: self.$Vpre){
                        ForEach(Self.Vpres.indices,id:\.self){
                            Text(Self.Vpres[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.secondary)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.black)
            .navigationBarTitle(Text("Preferences"),displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action:{
                    let user = self.realm?.objects(User.self).filter("username = '\(self.regularuser.username)'").first
                    try! self.realm!.write{
                        user?.Hpre = Self.Hpres[self.Hpre]
                        user?.Vpre = Self.Vpres[self.Vpre]
                    }
                    self.regularuser.Hpre = Self.Hpres[self.Hpre]
                    self.regularuser.Vpre = Self.Vpres[self.Vpre]
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
            })
        }.onAppear(perform: self.connect)
    }
    
    func connect(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.Hpre = Self.Hpres.firstIndex(of: self.regularuser.Hpre) ?? 0
        self.Vpre = Self.Vpres.firstIndex(of: self.regularuser.Vpre) ?? 0
    }
}

struct SelectPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPreferencesView()
    }
}
