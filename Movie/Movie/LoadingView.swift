//
//  LoadingView.swift
//  Movie
//
//  Created by LXY on 4/24/20.
//  Copyright © 2020 LXY. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    
    var body: some View {
        ZStack{
            BlurView()
            VStack{
                Indicator()
                Text("Loading...")
                    .foregroundColor(Color.white)
                    .padding(.top,8)
            }
        }
        .frame(width:110,height:110)
        .cornerRadius(10)
    }
}

struct BlurView: UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        
    }
}

struct Indicator: UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let indi = UIActivityIndicatorView(style: .large)
        indi.color = UIColor.white
        indi.startAnimating()
        return indi
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
