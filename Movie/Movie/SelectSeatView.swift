//
//  SelectSeatView.swift
//  Movie
//
//  Created by LXY on 4/24/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct SelectSeatView: View {
    
    init(screen:Screen, seatNum: Int){
        self.screen = screen
        self.seatNum = seatNum
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().backgroundColor = .black
    }
    
    @EnvironmentObject var regularuser: RegularUser
    
    let screen: Screen
    let seatNum: Int
    @State private var realm: Realm?
    @State private var myFakeSeats: [myFakeSeat] = [myFakeSeat()]
    @State private var rowMax = 0
    @State private var rows:[FakeRow] = []
    @State private var mySeat:[String] = []
    @State private var bookAlert = false
    @State private var LessSeatAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{geo in
            VStack(spacing: 12){
                if !self.myFakeSeats.isEmpty{
                    Text("Screen")
                    .italic()
                    .font(.system(size: 30))
                    .fixedSize()
                    .frame(width:100,height: 40)
                    .foregroundColor(.white)
                    .padding(1)
                    .background(Color.black)
                    .padding(0.5)
                    .background(Color.white)
                    .padding(.bottom,20)
                    ForEach(self.rows,id:\.fakerownum){ row in
                        HStack(spacing: 12){
                            Image(systemName: "\(row.fakerownum).square")
                                .resizable()
                                .foregroundColor(.yellow)
                                .scaledToFit()
                            ForEach(row.fakeseats,id:\.id){seat in
                                SingleSeatView(id: seat.id, Hpre: seat.Hpre, Vpre: seat.Vpre, exist: seat.exist, taken: seat.taken,myseats: self.mySeat)
                                    .onTapGesture {
                                        if seat.exist{
                                            if self.mySeat.count < self.seatNum && seat.taken == false{
                                                self.mySeat.append(seat.id)
                                                seat.taken = true
                                            }else if seat.taken == true && self.ifIn(id: seat.id, idArr: self.mySeat){
                                                self.mySeat = self.mySeat.filter(){$0 != seat.id}
                                                seat.taken = false
                                            }else{return}
                                        }else{return}
                                }
                            }
                        }.frame(width: geo.size.width*0.9,height: 30)
                    }
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                            Image(systemName: "circle")
                            Text("Available")
                            Spacer()
                        }
                        .foregroundColor(.white)
                        HStack{
                            Image(systemName: "circle.fill")
                            Text("Unavailable")
                            Spacer()
                        }
                        .foregroundColor(.red)
                        HStack{
                            Image(systemName: "circle")
                            Text("Recommended")
                            Spacer()
                        }
                        .foregroundColor(.yellow)
                        HStack{
                            Image(systemName: "circle.fill")
                            Text("Your pick")
                            Spacer()
                        }
                        .foregroundColor(.yellow)
                        .alert(isPresented: self.$LessSeatAlert){
                            Alert(title: Text("No enough seats!"), message: Text("You should choose \(self.seatNum) seat(s)!"), dismissButton: .default(Text("OK")))
                        }
                        HStack{
                            Text("Remain to select: \(self.seatNum - self.mySeat.count)")
                                .italic()
                                .foregroundColor(Color.white)
                            Spacer()
                            Button(action:{
                                if(self.seatNum == self.mySeat.count){
                                    self.bookAlert = true
                                }else{
                                    self.LessSeatAlert = true
                                }
                            }){
                                Text("Confirm")
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
                        .alert(isPresented: self.$bookAlert){
                            Alert(title: Text("Confirm your booking"), primaryButton: .cancel(), secondaryButton: .default(Text("Confirm"),action: {self.book();self.presentationMode.wrappedValue.dismiss()}))
                        }
                    }.frame(width: geo.size.width*0.9, height: 150)
                }else{
                    VStack{
                        Text("There seems to be an error.")
                            .foregroundColor(Color.yellow)
                        Text(" Please try again!")
                            .foregroundColor(Color.yellow)
                    }
                }
                
            }
            .onAppear(perform: self.load)
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.black)
            .navigationBarTitle(Text("Select"),displayMode: .inline)
        }
    }
    
    
    func load(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        while self.realm == nil{}
        let getSeats = self.realm?.objects(Screen.self).filter("id = '\(self.screen.id)'").first?.seats.sorted(by: ["row","column"])
        self.myFakeSeats = []
        for elem in getSeats!{
            self.myFakeSeats.append(elem.copytoFake())
        }
        self.rowMax = getSeats!.last!.row
        for i in 1...self.rowMax{
            let seatsInRow = getSeats?.filter("row = \(i)").sorted(byKeyPath: "column",ascending: true)
            var seatsInRowArr:[myFakeSeat] = []
            for elem in seatsInRow!{
                seatsInRowArr.append(elem.copytoFake())
            }
            let newRow = FakeRow(fakerownum: i, fakeseats: seatsInRowArr)
            self.rows.append(newRow)
        }
    }
    
    func ifIn(id:String,idArr:[String])->Bool{
        for elem in idArr{
            if elem == id {return true}
        }
        return false
    }
    
    func book(){
        var bookingSeats:[Seat] = []
        for id in mySeat{
            let singleResult = self.realm?.objects(Seat.self).filter("id = '\(id)'").first
            bookingSeats.append(singleResult!)
        }
        let ticket = Tickets(Screenid: self.screen.screenId, moviename: self.screen.moviename, date: self.screen.date,
                             time: self.screen.time, seats: bookingSeats, username: self.regularuser.username)
        let user = realm?.objects(User.self).filter("username = '\(self.regularuser.username)'").first
        try! self.realm!.write{
            user?.orders.append(ticket)
            for seat in bookingSeats{
                seat.taken = true
            }
        }
    }
}

struct FakeRow{
    let fakerownum:Int
    let fakeseats:[myFakeSeat]
}


struct SelectSeatView_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectSeatView(screen: Screen(),seatNum: 1)
    }
}

