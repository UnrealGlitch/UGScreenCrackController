//
//  UGScreenCrackController+Paths.swift
//  UGScreenCrackController
//
//  Created by UnrealGlitch on 09.09.2026.
//

import SpriteKit

extension UGScreenCrackController {

    /// Builds fractures of varying lengths around the impact point.
    internal func mainBranches(size: CGSize) -> [[CGPoint]] {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let count = Int.random(in: 5...7)
        let angleStep = 2 * CGFloat.pi / CGFloat(count)
        let rotation = CGFloat.random(in: 0...(2 * .pi))

        return (0..<count).map { index in
            let angle = rotation + angleStep * (CGFloat(index) + CGFloat.random(in: -0.3...0.3))
            let length: CGFloat = index == 0 ? 1 : CGFloat.random(in: 0.45...0.95)
            let end = CGPoint(
                x: center.x + cos(angle) * size.width * 0.46 * length,
                y: center.y + sin(angle) * size.height * 0.46 * length
            )
            return fracturePoints(from: center, to: end, segments: Int.random(in: 5...8))
        }
    }

    /// Adds forks at fracture bends on both sides of the main branch.
    internal func addForks(to path: CGMutablePath, along points: [CGPoint], width: CGFloat) {
        guard let end = points.last, points.count >= 5 else {
            return
        }

        let firstSide: CGFloat = Bool.random() ? 1 : -1
        let indices = (2..<(points.count - 2)).shuffled().prefix(Int.random(in: 1...2))
        for (offset, index) in indices.enumerated() {
            let start = points[index]
            let next = points[index + 1]
            let side = offset.isMultiple(of: 2) ? firstSide : -firstSide
            let angle = atan2(next.y - start.y, next.x - start.x) + side * CGFloat.random(in: 0.4...0.85)
            let length = hypot(end.x - start.x, end.y - start.y) * CGFloat.random(in: 0.4...0.7)
            let tip = CGPoint(x: start.x + cos(angle) * length, y: start.y + sin(angle) * length)
            let fork = fracturePoints(from: start, to: tip, segments: Int.random(in: 3...5))
            let progress = CGFloat(index) / CGFloat(points.count - 1)
            let forkWidth = width * pow(1 - progress, 0.8) * CGFloat.random(in: 0.55...0.8)
            addTaperedPath(to: path, points: fork, width: forkWidth)
        }
    }

    /// Adds sparse angular connections near the impact point without forming complete rings.
    internal func addConnections(to path: CGMutablePath, between branches: [[CGPoint]]) {
        let gapIndex = Int.random(in: branches.indices)
        for index in branches.indices where index != gapIndex && Bool.random() {
            let nextIndex = (index + 1) % branches.count
            let start = branches[index][Int.random(in: 1...2)]
            let end = branches[nextIndex][Int.random(in: 1...2)]
            let points = fracturePoints(from: start, to: end, segments: Int.random(in: 2...3))
            addTaperedPath(to: path, points: points, width: 0.35)
        }
    }

    /// Builds a filled outline tapering from its base to a sharp tip.
    internal func addTaperedPath(to path: CGMutablePath, points: [CGPoint], width: CGFloat) {
        guard points.count >= 2 else {
            return
        }

        // The left edge runs forward and the right edge backward in a single buffer.
        var outline = [CGPoint](repeating: .zero, count: points.count * 2)
        for index in points.indices {
            let point = points[index]
            let previous = points[max(0, index - 1)]
            let next = points[min(points.count - 1, index + 1)]
            let dx = next.x - previous.x
            let dy = next.y - previous.y
            let length = max(hypot(dx, dy), 0.001)
            let progress = CGFloat(index) / CGFloat(points.count - 1)
            let halfWidth = width * pow(1 - progress, 0.8) / 2
            let normal = CGVector(dx: -dy / length * halfWidth, dy: dx / length * halfWidth)
            outline[index] = CGPoint(x: point.x + normal.dx, y: point.y + normal.dy)
            outline[outline.count - 1 - index] = CGPoint(x: point.x - normal.dx, y: point.y - normal.dy)
        }

        path.addLines(between: outline)
        path.closeSubpath()
    }

}

// MARK: - Private functions

private extension UGScreenCrackController {

    /// Builds a jagged line between the given endpoints.
    func fracturePoints(from start: CGPoint, to end: CGPoint, segments: Int) -> [CGPoint] {
        let delta = CGVector(dx: end.x - start.x, dy: end.y - start.y)
        var points = [start]
        points.reserveCapacity(segments + 1)

        for index in 1..<segments {
            let progress = (CGFloat(index) + CGFloat.random(in: -0.2...0.2)) / CGFloat(segments)
            let offset = CGFloat.random(in: -0.09...0.09) * sin(progress * .pi)
            points.append(CGPoint(
                x: start.x + delta.dx * progress - delta.dy * offset,
                y: start.y + delta.dy * progress + delta.dx * offset
            ))
        }
        points.append(end)
        return points
    }

}
