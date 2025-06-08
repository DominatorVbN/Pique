//
//  ScrollEffectsView.swift
//  Pique
//
//  Created by Amit Samant on 07/06/25.
//

import SwiftUI

struct ParallaxCarouselView: View {
    let items = ImageItem.allCases
    @State var offset: CGFloat = 200
    @State var textOffset: CGFloat = 100
    
    func image(_ item: ImageItem) -> some View {
        ZStack {
            item.image
                .resizable()
                .scaledToFill()
                .frame(height: 500)
                // Did they forgot to mark scrollTransition closure to be main actor isolated ?
                .scrollTransition(axis: .horizontal) { content, phase in
                    content
                        .offset(x: phase.isIdentity ? 0 : phase.value * -offset)
                }
        }
        .containerRelativeFrame(.horizontal)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .allowedDynamicRange(.high)
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 22) {
                    ForEach(items) { item in
                        VStack {
                            image(item)
                            Text(item.name)
                                .font(.title)
                                .bold()
                                .scrollTransition(
                                    axis: .horizontal
                                ) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        .offset(x: phase.value * textOffset)
                                }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(54)
            .scrollTargetBehavior(.paging)
            
            GroupBox {
                VStack {
                    LabeledContent("Image Offset") {
                        Slider(value: $offset, in: 0...280, step: 8) {
                            Text("Rotation Factor: \(offset.rounded())")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("280")
                        }
                    }
                    
                    LabeledContent("Text Offset   ") {
                        Slider(value: $textOffset, in: 0...200, step: 8) {
                            Text("Rotation Factor: \(textOffset.rounded())")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("200")
                        }
                    }
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    CircularCarouselView()
}
