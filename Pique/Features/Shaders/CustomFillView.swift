//
//  CustomFillView.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .init(x: rect.midX, y: 0))
            path.addLine(to: .init(x: 0, y: rect.maxY))
            path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
        }
    }
    
    
}

struct CustomFillView: View {
    
    enum ShapeType: String, CaseIterable {
        case circle
        case rectangle
        case squircles
        case triangle
    }
    
    @State var shapeType: ShapeType = .circle

    @ViewBuilder
    var filledShape: some View {
        let fill = ShaderLibrary.Stripes(
            .float(12),
            .colorArray([
                .orange, .white, .green, .blue, .indigo
            ])
        )
        Group {
            switch shapeType {
            case .circle:
                Circle()
                    .fill(fill)
            case .rectangle:
                Rectangle()
                    .fill(fill)
            case .squircles:
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(fill)
            case .triangle:
                Triangle()
                    .fill(fill)
            }
        }
            
    }
    
    var body: some View {
        VStack {
            Spacer()
            filledShape
                .frame(width: 200, height: 200)
                .shadow(radius: 24)
            Spacer()
            GroupBox(label: Text("Shape")) {
                Picker("Shape", selection: $shapeType) {
                    ForEach(ShapeType.allCases, id: \.self) { shape in
                        Text(shape.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
        }
    }
}

#Preview {
    CustomFillView()
}
