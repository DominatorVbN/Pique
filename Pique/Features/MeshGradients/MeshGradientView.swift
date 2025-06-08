import SwiftUI
import simd

struct MeshGradientView: View {
    // MARK: – Configuration
    private let gridSize = 6
    private let radialAmplitude: Float = 0.1   // max ±10% of width/height (also used for S-curve amplitude)
    private let radialFrequency: Float = 1e-8
    private let sCycleFrequency: Float = 0.2    // cycles per second
    private let phaseOffsetScale: Float = 0.5   // adjust spread of S-curve phases

    // MARK: – State
    @State private var basePoints: [SIMD2<Float>] = Self.makeBaseGrid(size: 6)
    @State private var referenceDate = Date()
    @State private var showPoints = true
    @State private var animatePoints = false
    @State private var algorithm: DistributionAlgorithm = .radial

    var body: some View {
        VStack {
            animatedGradient
                .padding()

            controls
                .padding(.horizontal)
        }
    }

    private var animatedGradient: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 0.01)) { timeline in
                let points = currentPoints(at: timeline.date)
                MeshGradient(
                    width: gridSize,
                    height: gridSize,
                    points: points,
                    colors: Self.makeColorArray(count: gridSize * gridSize)
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay(pointOverlay(points: points, in: geometry))
            }
        }
    }

    private func currentPoints(at date: Date) -> [SIMD2<Float>] {
        guard animatePoints else { return basePoints }

        switch algorithm {
        case .radial:
            return radialPoints(at: date)
        case .sCurve:
            return sCurvePoints(at: date)
        }
    }

    private func radialPoints(at date: Date) -> [SIMD2<Float>] {
        let t = Float(date.timeIntervalSince(referenceDate)) * 1e9
        let center = SIMD2<Float>(0.5, 0.5)

        return basePoints.enumerated().map { index, point in
            guard point.x > 0, point.x < 1, point.y > 0, point.y < 1 else {
                return point
            }

            let delta = point - center
            let radius = simd_length(delta)
            let direction = simd_normalize(delta)
            let phase = Float(index) * 0.3
            let offset = sin(t * radialFrequency + phase) * radialAmplitude

            let shifted = center + direction * (radius + offset)
            return SIMD2<Float>(
                x: shifted.x.clamped(to: 0...1),
                y: shifted.y.clamped(to: 0...1)
            )
        }
    }

    private func sCurvePoints(at date: Date) -> [SIMD2<Float>] {
        let elapsed = Float(date.timeIntervalSince(referenceDate))
        // u in [0,1]
        let u = (sin(2 * .pi * sCycleFrequency * elapsed) + 1) / 2
        // blend factor: 0→0.5 S→line, 0.5→1 line→reverse S
        let blend: Float = u < 0.5 ? (u * 2) : ((u - 0.5) * 2)
        let toReverse = u >= 0.5

        return basePoints.enumerated().map { index, point in
            guard point.x > 0, point.x < 1, point.y > 0, point.y < 1 else {
                return point
            }

            // compute phase offset by index
            let idxPosition = Self.interiorPositionRatio(at: index, size: gridSize)
            let phaseOffset = idxPosition * phaseOffsetScale

            // sinusoidal offset in [-amplitude..amplitude]
            let basePhase = 2 * .pi * (point.x + phaseOffset)
            let sinOffset = sin(basePhase) * radialAmplitude

            // blend offset: S→0 or 0→-S
            let offsetY: Float = toReverse
                ? mix(0, -sinOffset, blend)
                : mix(sinOffset, 0, blend)

            // apply relative to original y
            let newY = (point.y + offsetY).clamped(to: 0...1)
            return SIMD2<Float>(x: point.x, y: newY)
        }
    }

    private func pointOverlay(points: [SIMD2<Float>], in geometry: GeometryProxy) -> some View {
        ZStack {
            ForEach(points.indices, id: \.self) { i in
                Circle()
                    .strokeBorder(.secondary)
                    .background(Circle().fill(.white))
                    .frame(width: 10, height: 10)
                    .opacity(showPoints ? 1 : 0)
                    .position(
                        x: geometry.size.width  * CGFloat(points[i].x),
                        y: geometry.size.height * CGFloat(points[i].y)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // calculate normalized new position
                                let newX = Float(value.location.x / geometry.size.width).clamped(to: 0...1)
                                let newY = Float(value.location.y / geometry.size.height).clamped(to: 0...1)
                                basePoints[i] = SIMD2<Float>(newX, newY)
                            }
                    )
            }
        }
    }

    private var controls: some View {
        GroupBox {
            VStack(spacing: 12) {
                Toggle("Show Points", isOn: $showPoints)
                Toggle("Animate Points", isOn: $animatePoints)
                Picker("Algorithm", selection: $algorithm) {
                    ForEach(DistributionAlgorithm.allCases, id: \.self) { algo in
                        Text(algo.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
        }
    }

    private static func makeBaseGrid(size: Int) -> [SIMD2<Float>] {
        stride(from: 0, through: 1, by: 1 / Float(size - 1)).flatMap { y in
            stride(from: 0, through: 1, by: 1 / Float(size - 1)).map { x in
                SIMD2<Float>(x, y)
            }
        }
    }

    private static func interiorPositionRatio(at index: Int, size: Int) -> Float {
        let grid = makeBaseGrid(size: size)
        let interiorIndices = grid.indices.filter { p in
            let pt = grid[p]
            return pt.x > 0 && pt.x < 1 && pt.y > 0 && pt.y < 1
        }
        let total = Float(interiorIndices.count)
        guard let rank = interiorIndices.firstIndex(of: index) else { return 0 }
        return Float(rank) / max(1, total - 1)
    }

    private static func makeColorArray(count: Int) -> [Color] {
        let palette: [Color] = [
            .red, .orange, .yellow, .green, .mint, .teal,
            .cyan, .blue, .indigo, .purple, .pink, .brown,
            .gray, .black, .white
        ]
        return (0..<count).map { palette[$0 % palette.count] }
    }

    private func mix(_ a: Float, _ b: Float, _ t: Float) -> Float {
        a + (b - a) * t
    }
}


enum DistributionAlgorithm: String, CaseIterable {
    case radial
    case sCurve = "s-curve"
}

extension Comparable {
    func clamped(to bounds: ClosedRange<Self>) -> Self {
        min(max(self, bounds.lowerBound), bounds.upperBound)
    }
}

struct MeshGradientView_Previews: PreviewProvider {
    static var previews: some View {
        MeshGradientView()
            .frame(width: 300, height: 300)
    }
}
