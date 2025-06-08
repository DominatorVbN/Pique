//
//  BaseFadeTextRenderer.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//
import SwiftUI

struct EmphasisGlyphFadeMoveDownEffectTextRenderer: TextRenderer, Animatable {
    
    var elapsedTime: TimeInterval
    var elementDuration: TimeInterval
    var totalDuration: TimeInterval
    
    var animatableData: Double {
        get { elapsedTime }
        set { elapsedTime = newValue }
    }
    
    var spring: Spring {
        .snappy(duration: elementDuration - 0.05, extraBounce: 0.4)
    }
    
    init(elapsedTime: TimeInterval, elementDuration: Double = 0.4, totalDuration: TimeInterval) {
        self.elapsedTime = min(elapsedTime, totalDuration)
        self.elementDuration = min(elementDuration, totalDuration)
        self.totalDuration = totalDuration
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        for run in layout.flattenedRuns {
            if run[EmphasisAttribute.self] != nil {
                let elements = run
                let elementDelay = self.elementDelay(count: elements.count)
                
                for (i, slice) in elements.enumerated() {
                    let timeOffset = TimeInterval(i) * elementDelay
                    let elementTime = max(0, min(elapsedTime - timeOffset, elementDuration))
                    var copy = ctx
                    draw(slice, at: elementTime, in: &copy)
                }
            } else {
                var copy = ctx
                copy.opacity = UnitCurve.easeIn.value(at: elapsedTime / 0.2)
                copy.draw(run)
            }
        }
    }
    
    private func draw(
        _ slice: Text.Layout.RunSlice,
        at time: TimeInterval,
        in context: inout GraphicsContext
    ) {
        let progress = time / elementDuration
        let opacity = UnitCurve.easeIn.value(at: 1.4 * progress)
        let blurRadius = slice.typographicBounds.rect.height / 16 * UnitCurve.easeIn.value(at: 1 - progress)
        let translationY: CGFloat = spring.value(
            fromValue: -slice.typographicBounds.descent,
            toValue: 0,
            initialVelocity: 0,
            time: time
        )
        
        context.translateBy(x: 0, y: translationY)
        context.addFilter(.blur(radius: blurRadius))
        context.opacity = opacity
        context.draw(slice)
    }
    
    func elementDelay(count: Int) -> TimeInterval {
        let count = TimeInterval(count)
        let remainingTime = totalDuration - count * elementDuration
        
        return max(remainingTime / (count + 1), (totalDuration - elementDuration) / count)
    }
}

struct EmphasisGlyphFadeMoveDownEffectTextTransition: Transition {
    
    // For accesibility
    static var properties: TransitionProperties {
        TransitionProperties(hasMotion: true)
    }
    
    let duration: TimeInterval
    
    init(duration: TimeInterval = 0.9) {
        self.duration = duration
    }
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        let duration = 0.9
        let elapsedTime = phase.isIdentity ? duration : 0
        let renderer = EmphasisGlyphFadeMoveDownEffectTextRenderer(elapsedTime: elapsedTime, totalDuration: duration)
        content.transaction { transaction in
            if !transaction.disablesAnimations {
                transaction.animation = .linear(duration: duration)
            }
        } body: { view in
            view.textRenderer(renderer)
        }
    }
}

extension Transition where Self == EmphasisGlyphFadeMoveDownEffectTextTransition {
    static var emphasisGlyphFadeMoveDown: Self { EmphasisGlyphFadeMoveDownEffectTextTransition() }
}

struct EmphasisAttribute: TextAttribute {}
