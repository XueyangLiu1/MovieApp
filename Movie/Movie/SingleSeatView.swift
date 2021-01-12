//
//  SingleSeatView.swift
//  Movie
//
//  Created by LXY on 4/25/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI

struct SingleSeatView: View {
    
    let id:String
    let Hpre:String
    let Vpre:String
    let exist:Bool
    let taken:Bool
    let myseats:[String]
    @EnvironmentObject var regularuser: RegularUser
    
    var body: some View {
        if !exist{
            return Image(systemName: "clear").resizable().scaledToFit().foregroundColor(.black).font(Font.title.weight(.ultraLight))
        }else if taken{
            if ifIn(id: self.id,idArr: myseats){
                return Image(systemName: "person.fill").resizable().scaledToFit().foregroundColor(.yellow).font(Font.title.weight(.ultraLight))
            }
            return Image(systemName: "person.fill").resizable().scaledToFit().foregroundColor(.red).font(Font.title.weight(.ultraLight))
        }else if Hpre == regularuser.Hpre && Vpre == regularuser.Vpre{
            return Image(systemName: "person").resizable().scaledToFit().foregroundColor(.yellow).font(Font.title.weight(.ultraLight))
        }else{
            return Image(systemName: "person").resizable().scaledToFit().foregroundColor(.white).font(Font.title.weight(.ultraLight))
        }
    }
    
    func ifIn(id:String,idArr:[String])->Bool{
        for elem in idArr{
            if elem == id {return true}
        }
        return false
    }
    
}

struct SingleSeatView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSeatView(id: "", Hpre: "side", Vpre: "front", exist: true, taken: false,myseats: [""])
    }
}
