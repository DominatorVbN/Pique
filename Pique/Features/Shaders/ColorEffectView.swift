//
//  ColorEffectView.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//

import SwiftUI

struct ColorEffectView: View {
    
    @State var noiseScale: Float = 0.1
    
    var browserWindow: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.green.opacity(0.3))
            ContainerRelativeShape()
                .fill(.green.opacity(0.3))
                .frame(width:100)
                .padding(6)
        }
        .containerShape(RoundedRectangle(cornerRadius: 12))
        .aspectRatio(1.8, contentMode: .fit)
        .padding()
        .padding()
    }
    
    var body: some View {
        let fill = ShaderLibrary.noise(
            .float(noiseScale)
        )
        VStack {
            Spacer()
            browserWindow
                .colorEffect(fill)
            Spacer()
            
            GroupBox("Noise Complexity") {
                Slider(value: $noiseScale, in: 0.1...1)
            }
        }
    }
}

#Preview {
    ColorEffectView()
}
