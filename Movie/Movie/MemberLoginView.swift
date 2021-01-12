//
//  MemberLoginView.swift
//  Movie
//
//  Created by LXY on 4/21/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct MemberLoginView: View {
    
    init(){
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().backgroundColor = .black
    }
    
    @State private var realm:Realm?
    @State var loginuser: User?
    @State private var logsuccess = false
    @State private var username = ""
    @State private var password = ""
    @State private var alertmsg = ""
    @State private var alerttitle = ""
    @State private var showAlert = false
    @State private var show = false
    @EnvironmentObject var regularuser: RegularUser
    
    var body: some View {
        GeometryReader{geo in
            if !self.logsuccess{
                NavigationView{
                    VStack{
                        Text("Log in")
                            .foregroundColor(.yellow)
                            .bold()
                            .font(.system(size: 25))
                            .padding(.top, 50)
                        Text("or")
                            .foregroundColor(.yellow)
                            .italic()
                            .font(.system(size: 20))
                        Text("Sign up")
                            .foregroundColor(.yellow)
                            .bold()
                            .font(.system(size: 25))
                            .padding(.bottom, 20)
                        TextField("Username", text: self.$username)
                            .accentColor(.black)
                            .padding()
                            .frame(width: 300)
                            .background(Color.yellow)
                            .cornerRadius(25)
                        ZStack(alignment: .trailing){
                                if self.show {
                                    TextField("Password", text: self.$password)
                                        .accentColor(.black)
                                        .padding()
                                        .frame(width: 300)
                                        .background(Color.yellow)
                                        .cornerRadius(25)
                                }else{
                                    SecureField("Password", text: self.$password)
                                        .accentColor(.black)
                                        .padding()
                                        .frame(width: 300)
                                        .background(Color.yellow)
                                        .cornerRadius(25)
                                }
                            Button(action:{
                                self.show.toggle()
                            }){
                                Image(systemName: self.show ? "eye.fill" : "eye.slash.fill")
                                    .padding()
                                    .foregroundColor((self.show==true) ? Color.green : Color.black)
                                    .offset(x:0)
                            }
                            
                        }.padding(.bottom, 20)
                        HStack(spacing: 20){
                            Button(action: self.signup){
                                Text("Sign up")
                                    .bold()
                                    .font(.system(size: 25))
                                    .fixedSize()
                                    .frame(width:100,height: 35)
                                    .foregroundColor(.yellow)
                                    .padding(1)
                                    .background(Color.black)
                                    .padding(0.7)
                                    .background(Color.yellow)
                            }
                            Button(action: self.login){
                                Text("Log in")
                                    .bold()
                                    .font(.system(size: 25))
                                    .fixedSize()
                                    .frame(width:100,height: 35)
                                    .foregroundColor(.yellow)
                                    .padding(1)
                                    .background(Color.black)
                                    .padding(0.7)
                                    .background(Color.yellow)
                            }
                        }
                        Spacer()
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(Color.black)
                    .alert(isPresented: self.$showAlert, content:{
                        Alert(title: Text(self.alerttitle), message: Text(self.alertmsg), dismissButton: .default(Text("OK")))
                    })
                    .navigationBarTitle(Text("Account Login"),displayMode: .inline)
                }
                .onAppear(perform: self.connect)
            }else{
                NavigationView{
                    VStack{
                        Form{
                            Section{
                                NavigationLink(destination: SelectPreferencesView()){
                                    HStack{
                                        Text("Preferences")
                                            .bold()
                                            .font(.system(size: 20))
                                            .foregroundColor(Color.yellow)
                                        Spacer()
                                    }.frame(width: geo.size.width)
                                }
                                NavigationLink(destination: ShowTicketsView()){
                                    HStack{
                                        Text("Tickets")
                                            .bold()
                                            .font(.system(size: 20))
                                            .foregroundColor(Color.yellow)
                                        Spacer()
                                    }.frame(width: geo.size.width)
                                }
                            }
                            Spacer()
                            Section{
                                Button(action: self.logOut){
                                        Text("Log out")
                                            .bold()
                                            .font(.system(size: 25))
                                            .fixedSize()
                                            .frame(width:100,height: 35)
                                            .foregroundColor(.yellow)
                                            .padding(1)
                                            .background(Color.black)
                                            .padding(0.7)
                                            .background(Color.yellow)
                                    }
                            }.background(Color.black)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(Color.black)
                    .navigationBarTitle(Text("Member: \(self.loginuser!.username)"),displayMode: .inline)
                }
            }
        }
    }

    func connect(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
    }
    
    func signup(){
        verify(username: self.username, password: self.password, register: true)
    }
    func login(){
        verify(username: self.username, password: self.password, register: false)
    }
    
    func logOut(){
        self.logsuccess = false
        regularuser.username = ""
        regularuser.password = ""
        regularuser.Hpre = ""
        regularuser.Vpre = ""
    }
    
    func verify(username:String,password:String,register:Bool){
        if (username == "" || password == ""){
            print("no username or password input")
            self.alertmsg = "Please fill in both text fields!"
                self.showAlert  = true
                self.alerttitle = "Failed!"
        }
        else if register == true{
            let newuser = User(username, password)
            let existuser = self.realm!.objects(User.self).filter("username = '\(username)'").first
            if existuser == nil{
                try! self.realm!.write{
                    self.realm!.add(newuser)
                }
                self.showAlert = true
                self.alerttitle = "Success!"
                self.alertmsg =
                """
                You have registered successfully!
                Now log in!
                """
                print("Successfully registered!")
            }else {
                self.showAlert = true
                self.alerttitle = "Failed!"
                self.alertmsg = "The usrname already exists"
                print("The name has been taken")
            }
        }
        else if register == false{
            let existuser = self.realm!.objects(User.self).filter("username = '\(username)'").first
            if existuser == nil{
                self.showAlert = true
                self.alertmsg = "Either the username or the password is invalid"
                self.alerttitle = "Failed!"
                print("User not exist")
            }else if existuser!.password == password{
                print("User login succeeded!")
                self.showAlert  = true
                self.alerttitle = "Success!"
                self.alertmsg = "Logged in successfully!"
                self.loginuser = existuser
                self.logsuccess = true
                regularuser.username = username
                regularuser.password = password
                regularuser.Hpre = existuser!.Hpre
                regularuser.Vpre = existuser!.Vpre
                print(regularuser.Hpre)
                print(regularuser.Vpre)
            }else{
                self.showAlert = true
                self.alertmsg = "Either the username or the password is invalid"
                self.alerttitle = "Failed!"
                print("Wrong password!")
            }
        }
    }
}

struct MemberLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MemberLoginView()
    }
}

