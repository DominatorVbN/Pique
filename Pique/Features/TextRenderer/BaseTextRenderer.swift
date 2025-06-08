//
//  BaseTextRenderer.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//
import SwiftUI

struct BaseTextRenderer: TextRenderer {
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        for line in layout {
            ctx.draw(line)
        }
    }
}

struct BaseTextTransition: Transition {
    
    // For accesibility
    static var properties: TransitionProperties {
        TransitionProperties(hasMotion: false)
    }
    
    let duration: TimeInterval
    
    init(duration: TimeInterval = 0.9) {
        self.duration = duration
    }
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        let renderer = BaseTextRenderer()
        
        content.transaction { transaction in
            if !transaction.disablesAnimations {
                transaction.animation = .linear(duration: duration)
            }
        } body: { view in
            view.textRenderer(renderer)
        }
    }
}

extension Transition where Self == BaseTextTransition {
    static var baseTextTransition: Self { BaseTextTransition() }
}
