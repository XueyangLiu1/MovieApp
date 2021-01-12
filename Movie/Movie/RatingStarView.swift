//
//  RatingStarView.swift
//  Movie
//
//  Created by LXY on 4/22/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI

struct RatingStarView: View {
    
    @Binding var rating: Int
    
    var body: some View {
        HStack{
            ForEach(1..<6, id:\.self){ num in
                Image(systemName: "star.fill")
                    .foregroundColor(num>self.rating ? Color.gray : Color.yellow)
                    .onTapGesture {
                        self.rating = num
                }
            }
        }
    }
}

struct RatingStarView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStarView(rating: .constant(3))
    }
}
