//
//  DistortionEffectView.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//

import SwiftUI

struct DistortionEffectView: View {
    let startDate = Date()
    
    @State var speed: Float = 0.5
    @State var strength: Float = 8
    @State var frequency: Float = 10
    var image: some View {
        Image(.capitagreen)
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    var body: some View {
        VStack {
            Spacer()
            TimelineView(.animation) { context in
                image
                    .frame(width: 300, height: 500)
                    .visualEffect { content, proxy in
                        content
                            .distortionEffect(ShaderLibrary.complexWave(
                                .float(startDate.timeIntervalSinceNow),
                                .float2(proxy.size),
                                .float(speed),
                                .float(strength),
                                .float(frequency)
                            ), maxSampleOffset: .zero)
                    }
                
            }
            Spacer()
            GroupBox {
                LabeledContent("Speed") {
                    Slider(value: $speed, in: 0.1...4, step: 0.1) {
                        Text("Speed \(speed)")
                    } minimumValueLabel: {
                        Text("0.1")
                    } maximumValueLabel: {
                        Text("4")
                    }
                }
                
                LabeledContent("Strenth") {
                    Slider(value: $strength, in: 1...20, step: 0.1) {
                        Text("Speed \(strength)")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("20")
                    }
                }
                
                LabeledContent("Frequency") {
                    Slider(value: $frequency, in: 1...100, step: 0.1) {
                        Text("Speed \(frequency)")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("100")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    DistortionEffectView()
}
