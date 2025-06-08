//
//  ScrollEffectsView.swift
//  Pique
//
//  Created by Amit Samant on 07/06/25.
//

import SwiftUI

struct CircularCarouselView: View {
    let items = ImageItem.allCases
    @State var rotationFactor: CGFloat = 1.5
    @State var offset: CGFloat = 8
    
    fileprivate func image(_ item: ImageItem) -> some View {
        return item.image
            .resizable()
            .scaledToFill()
            .frame(height: 500)
            // To match the width to parent, while respecting `contentMargins`
            .containerRelativeFrame(.horizontal)
            .clipShape(RoundedRectangle(cornerRadius: 36))
            .allowedDynamicRange(.high)
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 22) {
                    ForEach(items) { item in
                        image(item)
                            // Did they forgot to mark scrollTransition closure to be main actor isolated ?
                            .scrollTransition(axis: .horizontal) { content, phase in
                                content
                                    .rotationEffect(.degrees(phase.value * rotationFactor))
                                    .offset(y: phase.isIdentity ? 0 : offset)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            // Have margins so that view width less than parent width
            .contentMargins(54)
            .scrollTargetBehavior(.paging)
            
            GroupBox {
                VStack {
                    LabeledContent("Rotation") {
                        Slider(value: $rotationFactor, in: 1...10, step: 0.5) {
                            Text("Rotation Factor: \(rotationFactor.rounded())")
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("10")
                        }
                    }
                    LabeledContent("Offset  ") {
                        Slider(value: $offset, in: 4...120, step: 4) {
                            Text("Rotation Factor: \(offset.rounded())")
                        } minimumValueLabel: {
                            Text("4")
                        } maximumValueLabel: {
                            Text("120")
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
