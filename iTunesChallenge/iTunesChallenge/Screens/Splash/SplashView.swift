//
//  SplashView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import SwiftUI

struct SplashView: View {
    
    @State var showLogo = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            let color1: Color = showLogo ? .black : .brand
            let color2: Color = showLogo ? .brand : .black
            LinearGradient(colors: [color1, color2], startPoint: .topTrailing, endPoint: .bottomLeading)
            if showLogo {
                Image("musical-note")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .transition(.scale)
            }
        }
        .animation(.default.speed(0.2), value: showLogo)
        .ignoresSafeArea()
        .onAppear {
            showLogo = true
        }
    }
}

#Preview {
    SplashView()
}

