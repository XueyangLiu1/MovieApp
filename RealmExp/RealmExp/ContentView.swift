//
//  ContentView.swift
//  RealmExp
//
//  Created by LXY on 4/16/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var logsuccess = false
    @State private var show = false
    @State private var errormsg = ""
    @State private var error = false
    @State private var admin = false
    
    @State var realm: Realm?
    @State var loginuser: User?
    
    var body: some View {
        Group{
            VStack(spacing: 20){
                TextField("Username", text: $username)
                    .padding()
                    .frame(width: 300)
                    .background(Color(red: 233.0/255,green: 234.0/255, blue: 243.0/255))
                    .cornerRadius(25)
                    .offset(x:-20)
                ZStack(alignment: .trailing){
                    HStack{
                        if self.show {
                            TextField("Password", text: $password)
                                .padding()
                                .frame(width: 300)
                                .background(Color(red: 233.0/255,green: 234.0/255, blue: 243.0/255))
                                .cornerRadius(25)
                                .offset(x:-20)
                        }else{
                            SecureField("Password", text: $password)
                                .padding()
                                .frame(width: 300)
                                .background(Color(red: 233.0/255,green: 234.0/255, blue: 243.0/255))
                                .cornerRadius(25)
                                .offset(x:-20)
                        }
                    }
                    Button(action:{
                        self.show.toggle()
                    }){
                        Image(systemName: self.show ? "eye.fill" : "eye.slash.fill")
                            .padding()
                            .foregroundColor((self.show==true) ? Color.green : Color.secondary)
                            .offset(x:30)
                    }
                }
                Button(action: AdminsignIn){
                    Text("Sign in")
                        .padding()
                        .fixedSize()
                        .frame(width:100,height: 35)
                        .foregroundColor(.yellow)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }.padding([.leading, .trailing])
                .alert(isPresented: $error, content: {
                    Alert(title: Text("Login failed"), message: Text(self.errormsg),dismissButton: .default(Text("OK")))
                })
        }
        .navigate(to: adminView(), when: $admin)
    }
    func AdminsignIn(){
        logIn(username: self.username, password: self.password, register: false)
    }
    
    func logIn(username: String, password: String, register: Bool) {
        print("Log in as user: \(username) with register: \(register)")
        for u in SyncUser.all {
            u.value.logOut()
        }
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { (user, err) in
            if let error = err {
                self.errormsg = "Login failed: \(error.localizedDescription)"
                self.error = true
                print("Login failed: \(error)")
                return
            }
            print("Login succeeded!")
            if register == false {self.admin = true}
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
