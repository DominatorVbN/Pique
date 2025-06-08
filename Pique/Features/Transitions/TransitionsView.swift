//
//  TransitionsView.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//

import SwiftUI

struct CoinRotateTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .rotation3DEffect(
                .degrees(
                    phase == .willAppear ? 360 :
                        phase == .didDisappear ? -360 : .zero
                ),
                axis: (0,1,0)
            )
            .scaleEffect(phase.isIdentity ? 1 : 0.5)
            .brightness(phase == .willAppear ? 1 : 0)
            .blur(radius: phase.isIdentity ? 0 : 10)
            .opacity(phase.isIdentity ? 1 : 0)
    }
}

extension Transition where Self == CoinRotateTransition {
    static var coinRotate: CoinRotateTransition { CoinRotateTransition() }
}

struct TwirlTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0.5)
            .opacity(phase.isIdentity ? 1 : 0)
            .blur(radius: phase.isIdentity ? 0 : 10)
            .rotationEffect(
                .degrees(
                    phase == .willAppear ? 360 :
                        phase == .didDisappear ? -360 : .zero
                )
            )
            .brightness(phase == .willAppear ? 1 : 0)
    }
}

extension Transition where Self == TwirlTransition {
    static var twirl: TwirlTransition { TwirlTransition() }
}

struct TransitionsView: View {
    
    enum Transitions: String, CaseIterable {
        case scaleAndFade = "Scale and Fade"
        case scaleBlurAndFade = "Scale, Blur, and Fade"
        case twirl = "Twirl"
        case cointRotate = "Coin Rotate"
    }
    
    @State var transition: Transitions = .scaleAndFade
    @State var showImage: Bool = true
    
    var avatar: some View {
        ZStack {
            Circle()
                .fill(.teal)
            Image(.memoji)
                .resizable()
                .scaledToFit()
                .padding()
        }
        .frame(width: 200, height: 200)
    }
    
    var body: some View {
        VStack {
            Spacer()
            if showImage {
                Group {
                    switch transition {
                    case .scaleAndFade:
                        avatar
                            .transition(.scale.combined(with: .opacity))
                    case .scaleBlurAndFade:
                        avatar
                            .transition(.blurReplace.combined(with: .scale).combined(with: .opacity))
                    case .twirl:
                        avatar
                            .transition(.twirl)
                    case .cointRotate:
                        avatar
                            .transition(.coinRotate)
                    }
                }
                .animation(.default, value: showImage)
                Spacer()
            }

            GroupBox {
                Toggle("Show Image", isOn: $showImage.animation())
                Picker("Transition", selection: $transition) {
                    ForEach(Transitions.allCases, id: \.self) { transiton in
                        Text(transiton.rawValue.capitalized)
                    }
                }
                .pickerStyle(.inline)
            }
            .padding()
        }
    }
}

#Preview {
    TransitionsView()
}
