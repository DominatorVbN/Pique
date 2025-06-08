//
//  HueRotationView.swift
//  Pique
//
//  Created by Amit Samant on 07/06/25.
//

import SwiftUI

struct HueAndScaleView: View {
    
    @State var hueDenominator: CGFloat = 10
    @State var offsetDenominator: CGFloat = 1.25
    @State var brightnessDenominator: CGFloat = 400
    @State var blurDenominator: CGFloat = 50
    @State var showControls: Bool = false
    
    func cell(forDev dev: String) -> some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(.purple)
            .overlay {
                Text(dev)
                    .font(.title)
                    .bold()
                    .opacity(0.8)
            }
            .frame(height: 80)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(String.devs, id: \.self) { dev in
                cell(forDev: dev)
                    .visualEffect { content, proxy in
                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                        let parentBounds = proxy
                            .bounds(of: .scrollView(axis: .vertical)) ??
                            .infinite
                        
                        // The distance this view extends past the bottom edge
                        // of the scroll view.
                        let distance = min(0, frame.minY)
                        
                        return content
                            .hueRotation(.degrees(frame.origin.y / 10))
                            .scaleEffect(1 + distance / parentBounds.height)
                            .offset(y: -distance / offsetDenominator)
                            .brightness(-distance / brightnessDenominator)
                            .blur(radius: -distance / blurDenominator)
                    }
            }
        }
        .contentMargins(.vertical, 36)
        .sheet(isPresented: $showControls) {
            ScrollView {
                
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
                    
                    LabeledContent("Offset denominator") {
                        Slider(value: $offsetDenominator, in: 1...4.5, step: 0.25) {
                            Text("Offset Denominator: \(offsetDenominator.rounded())")
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("4.5")
                        }
                    }
                    
                    LabeledContent("Brightness denominator") {
                        Slider(value: $hueDenominator, in: 100...1000, step: 5) {
                            Text("Brightness Denominator: \(hueDenominator.rounded())")
                        } minimumValueLabel: {
                            Text("100")
                        } maximumValueLabel: {
                            Text("1000")
                        }
                    }
                    
                    LabeledContent("Blur denominator") {
                        Slider(value: $blurDenominator, in: 10...100) {
                            Text("Blur Denominator: \(blurDenominator.rounded())")
                        } minimumValueLabel: {
                            Text("10")
                        } maximumValueLabel: {
                            Text("100")
                        }
                    }
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            }
            .presentationDetents([.height(100), .medium])
            .presentationBackgroundInteraction(
                .enabled(upThrough: .medium)
            )
            .presentationBackground(.thinMaterial)
        }
        .onAppear {
            showControls = true
        }
        
    }
}

#Preview {
    HueRotationView()
}
