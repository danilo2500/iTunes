//
//  GradientBackgroundView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//



import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(colors: [.brand, .black], startPoint: .topTrailing, endPoint: .bottomLeading)
    }
}

#Preview {
    GradientBackgroundView()
}
