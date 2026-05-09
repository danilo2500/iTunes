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
            LinearGradient(colors: [.brand, .black], startPoint: .topTrailing, endPoint: .bottomLeading)
            if showLogo {
                Image("musical-note")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .transition(.scale)
            }
        }
        .animation(.default, value: showLogo)
        .ignoresSafeArea()
        .onAppear {
            showLogo = true
        }
    }
}

#Preview {
    SplashView()
}
