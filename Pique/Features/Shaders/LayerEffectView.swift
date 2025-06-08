//
//  LayerEffectView.swift
//  Pique
//
//  Created by Amit Samant on 08/06/25.
//

import SwiftUI

struct LayerEffectView: View {
    
    @State var origin: CGPoint = .zero
    @State var counter: Int = 0
    
    @State var amplitude: Double = 12
    @State var frequency: Double = 15
    @State var decay: Double = 8
    @State var speed: Double = 1200
    
    var image: some View {
        Image(.mcritchieflower)
            .allowedDynamicRange(.high)
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    var body: some View {
        VStack {
            Spacer()
            image
                .frame(width: 300, height: 500)
                .onPressingChanged { point in
                    if let point {
                        origin = point
                        counter += 1
                    }
                }
                .modifier(
                    RippleEffect(
                        at: origin,
                        trigger: counter,
                        amplitude: amplitude,
                        frequency: frequency,
                        decay: decay,
                        speed: speed
                    )
                )
            Spacer()
            GroupBox {
                Grid {
                    GridRow {
                        VStack(spacing: 4) {
                            Text("speed")
                            Slider(value: $speed, in: 1000 ... 5000)
                        }
                        VStack(spacing: 4) {
                            Text("Amplitude")
                            Slider(value: $amplitude, in: 0 ... 100)
                        }
                    }
                    GridRow {
                        VStack(spacing: 4) {
                            Text("Frequency")
                            Slider(value: $frequency, in: 0 ... 30)
                        }
                        VStack(spacing: 4) {
                            Text("Decay")
                            Slider(value: $decay, in: 0 ... 20)
                        }
                    }
                }
                .font(.subheadline)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    LayerEffectView()
}


struct RippleEffect<T: Equatable>: ViewModifier {
    var origin: CGPoint

    var trigger: T
    
    var amplitude: Double
    var frequency: Double
    var decay: Double
    var speed: Double

    init(
        at origin: CGPoint,
        trigger: T,
        amplitude: Double,
        frequency: Double,
        decay: Double,
        speed: Double
    ) {
        self.origin = origin
        self.trigger = trigger
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.speed = speed
    }

    func body(content: Content) -> some View {
        let origin = origin
        let duration = duration

        content.keyframeAnimator(
            initialValue: 0,
            trigger: trigger
        ) { view, elapsedTime in
            view.modifier(
                RippleModifier(
                    origin: origin,
                    elapsedTime: elapsedTime,
                    duration: duration,
                    amplitude: amplitude,
                    frequency: frequency, decay: decay, speed: speed
                )
            )
        } keyframes: { _ in
            MoveKeyframe(0)
            LinearKeyframe(duration, duration: duration)
        }
    }

    var duration: TimeInterval { 3 }
}

/// A modifier that applies a ripple effect to its content.
struct RippleModifier: ViewModifier {
    var origin: CGPoint

    var elapsedTime: TimeInterval

    var duration: TimeInterval
    
    var amplitude: Double
    var frequency: Double
    var decay: Double
    var speed: Double
    
    init(
        origin: CGPoint,
        elapsedTime: TimeInterval,
        duration: TimeInterval,
        amplitude: Double,
        frequency: Double,
        decay: Double,
        speed: Double
    ) {
        self.origin = origin
        self.elapsedTime = elapsedTime
        self.duration = duration
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.speed = speed
    }

    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Ripple(
            .float2(origin),
            .float(elapsedTime),

            // Parameters
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )

        let maxSampleOffset = maxSampleOffset
        let elapsedTime = elapsedTime
        let duration = duration

        content.visualEffect { view, _ in
            view.layerEffect(
                shader,
                maxSampleOffset: maxSampleOffset,
                isEnabled: 0 < elapsedTime && elapsedTime < duration
            )
        }
    }

    var maxSampleOffset: CGSize {
        CGSize(width: amplitude, height: amplitude)
    }
}

extension View {
    func onPressingChanged(_ action: @escaping (CGPoint?) -> Void) -> some View {
        modifier(SpatialPressingGestureModifier(action: action))
    }
}

struct SpatialPressingGestureModifier: ViewModifier {
    var onPressingChanged: (CGPoint?) -> Void

    @State var currentLocation: CGPoint?

    init(action: @escaping (CGPoint?) -> Void) {
        self.onPressingChanged = action
    }

    func body(content: Content) -> some View {
        let gesture = SpatialPressingGesture(location: $currentLocation)

        content
            .gesture(gesture)
            .onChange(of: currentLocation, initial: false) { _, location in
                onPressingChanged(location)
            }
    }
}

struct SpatialPressingGesture: UIGestureRecognizerRepresentable {
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @objc
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
        ) -> Bool {
            true
        }
    }

    @Binding var location: CGPoint?

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }

    func makeUIGestureRecognizer(context: Context) -> UILongPressGestureRecognizer {
        let recognizer = UILongPressGestureRecognizer()
        recognizer.minimumPressDuration = 0
        recognizer.delegate = context.coordinator

        return recognizer
    }

    func handleUIGestureRecognizerAction(
        _ recognizer: UIGestureRecognizerType, context: Context) {
            switch recognizer.state {
                case .began:
                    location = context.converter.localLocation
                case .ended, .cancelled, .failed:
                    location = nil
                default:
                    break
            }
        }
    }
