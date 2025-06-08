//
//  HueRotationView.swift
//  Pique
//
//  Created by Amit Samant on 07/06/25.
//

import SwiftUI

struct HueRotationView: View {
    @State var hueDenominator: CGFloat = 10
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(String.devs, id: \.self) { dev in
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.purple)
                        .overlay {
                            Text(dev)
                                .font(.title)
                                .bold()
                                .opacity(0.8)
                        }
                        .frame(height: 80)
                        .visualEffect { content, proxy in
                            content
                                .hueRotation(
                                    .degrees(
                                        proxy.frame(in: .global).origin.y / hueDenominator
                                    )
                                )
                        }
                }
            }
        }
        .contentMargins(16)
        .safeAreaInset(edge: .bottom) {
            VStack {
                LabeledContent("Hue denominator") {
                    Slider(value: $hueDenominator, in: 10...50, step: 1) {
                        Text("Hue Denominator: \(hueDenominator.rounded())")
                    } minimumValueLabel: {
                        Text("10")
                    } maximumValueLabel: {
                        Text("50")
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.regularMaterial)
            )
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    HueRotationView()
}
