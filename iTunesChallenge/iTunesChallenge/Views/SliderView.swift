//
//  SliderView.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//



import SwiftUI

struct SliderView<MaxMinLabel: View>: View {
    
    @Binding var progress: Double
    
    let totalFrameHeight: CGFloat = 24
    let thumbSize: CGFloat = 24
    let sliderHeight: CGFloat = 8
    
    var onEditingChanged: (Bool) -> Void = { _ in }
    
    @ViewBuilder let minimumValueLabel: () -> MaxMinLabel
    @ViewBuilder let maximumValueLabel: () -> MaxMinLabel
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let trackWidth = proxy.size.width - thumbSize
                let offset = thumbSize / 2 + trackWidth * progress
                Slider(value: $progress) { isEditing in
                    onEditingChanged(isEditing)
                }
                .sliderThumbVisibility(.hidden)
                .tint(.gray)
                .overlay {
                    Circle()
                        .frame(width: thumbSize, height: thumbSize)
                        .position(x: offset, y: (totalFrameHeight + sliderHeight) / 2)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: totalFrameHeight)
            HStack {
                minimumValueLabel()
                Spacer()
                maximumValueLabel()
            }
            .opacity(0.7)
            .font(.footnote)
        }
    }
}

#Preview {
    @Previewable @State var progress = 0.5
    SliderView(progress: $progress) { _ in
        
    } minimumValueLabel: {
        Text("0:00")
    } maximumValueLabel: {
        Text("1:00")
    }
}
