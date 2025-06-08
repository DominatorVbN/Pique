//
//  TextRendererView.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//

import SwiftUI

struct TextRendererView: View {
    
    enum TextTransition: String, CaseIterable {
        case base = "Base"
        case lineFadeMoveDown = "Line Fade Move Down"
        case glyphFadeMoveDown = "Glyph Fade Move Down"
        case emphasisGlyphFadeMoveDown = "Emphasis Glyph Fade Move Down"
    }
    
    @State var textShown = false
    @State var transition: TextTransition = .base
    
    var text: some View {
        let watchPartyAroundIndia = Text("Watch Party Around India 🇮🇳")
                                .customAttribute(EmphasisAttribute())
                        .foregroundStyle(.pink)
                        .bold()
        return Text("It's WWDC tommorow, be sure to look out for \(watchPartyAroundIndia)")
            .multilineTextAlignment(.center)
            .font(.title)
            .bold()
            .padding()
    }
    
    var body: some View {
        VStack {
            Spacer()
            if textShown {
                switch transition {
                case .base:
                    text
                        .transition(.baseTextTransition)
                case .lineFadeMoveDown:
                    text
                        .transition(.lineFadeMoveDown)
                case .glyphFadeMoveDown:
                    text
                        .transition(.glyphFadeMoveDown)
                case .emphasisGlyphFadeMoveDown:
                    text
                        .transition(.emphasisGlyphFadeMoveDown)
                }
            }
            Spacer()
            GroupBox {
                VStack {
                    Toggle("Visible", isOn: $textShown.animation())
                    Picker("Text Transition", selection: $transition) {
                        ForEach(TextTransition.allCases, id: \.self) { transition in
                            Text(transition.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .padding()

        }
        .animation(.default, value: textShown)
    }
}

#Preview {
    TextRendererView()
}
