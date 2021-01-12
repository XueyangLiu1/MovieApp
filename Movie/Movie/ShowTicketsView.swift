//
//  ShowTicketsView.swift
//  Movie
//
//  Created by LXY on 4/24/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ShowTicketsView: View {
    
    init(){
        UITableViewCell.appearance().backgroundColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.yellow]
        UINavigationBar.appearance().backgroundColor = .black
    }
    
    @EnvironmentObject var regularuser: RegularUser
    @State private var realm: Realm?
    @State private var tickets:[myFakeTickets] = []
    @State private var cancelAlert = false
    @State private var cancelledOne:myFakeTickets?
    @State private var deleting = false
    
    var body: some View {
        GeometryReader{geo in
            if !self.tickets.isEmpty && !self.deleting{
                List{
                    ForEach(self.tickets,id:\.id){ticket in
                        HStack{
                            Image(ticket.moviename)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .shadow(color: .black, radius: 5)
                            VStack(spacing: 20){
                                Text(ticket.moviename)
                                    .foregroundColor(.yellow)
                                    .italic()
                                Text("\(ticket.seats.count) tickets")
                                    .foregroundColor(.yellow)
                                HStack{
                                    Text("at")
                                    ForEach(ticket.seats.indices,id:\.self){
                                        Text("(\(ticket.seats[$0].row),\(ticket.seats[$0].column)) ")
                                    }
                                }.foregroundColor(.yellow)
                                HStack(spacing: 15){
                                    Text("on   \(ticket.date)")
                                    Text(ticket.time)
                                    Spacer()
                                    Text("Cancel")
                                        .background(Color.black)
                                        .padding(0.7)
                                        .background(Color.yellow)
                                        .onTapGesture {
                                            self.cancelAlert = true
                                            self.cancelledOne = ticket
                                    }
                                }.foregroundColor(.yellow)
                            }
                        }.frame(width: geo.size.width*0.95,height: 160)
                    }
                }
            }else if !self.deleting{
                VStack(alignment: .center){
                    Spacer()
                    Text("Go book some tickets!")
                        .foregroundColor(Color.yellow)
                        .italic()
                        .font(.system(size: 30))
                    Spacer()
                }.frame(width: geo.size.width,height: geo.size.height)
                    .background(Color.black)
            }else{
                LoadingView()
            }
        }
        .onAppear(perform: self.connect)
        .alert(isPresented: self.$cancelAlert){
            Alert(title: Text("Cancelling tickets!"), message: Text("Are you sure to cancel those tickets?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Confirm"), action: {
                self.deleting=true
                self.deleteOne()
            }))
        }
    }
    
    func connect(){
        let config = SyncUser.current?.configuration(realmURL: Constants.MOVIES_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        while self.realm == nil {}
        let tickets = self.realm?.objects(User.self).filter("username = '\(regularuser.username)'").first?.orders
        print(tickets!.count)
        for elem in tickets!{
            self.tickets.append(elem.copytoFake())
        }
    }
    func deleteOne(){
        var newTickets:[myFakeTickets] = []
        for elem in self.tickets{
            if elem.id != self.cancelledOne!.id{
                newTickets.append(elem)
            }
        }
        self.tickets = newTickets
        
        var seats:[Seat] = []
        for elem in self.cancelledOne!.seats{
            seats.append(elem)
        }
        let deleteOne = self.realm?.objects(Tickets.self).filter("id = '\(self.cancelledOne!.id)'").first
        try! self.realm!.write{
            for seat in seats{
                seat.taken = false
            }
            realm?.delete(deleteOne!)
        }
        self.deleting = false
    }
}

struct ShowTicketsView_Previews: PreviewProvider {
    static let t = Tickets()
    static var previews: some View {
        ShowTicketsView()
    }
}
