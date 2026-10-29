//
//  UGScreenCrackController+Cracks.swift
//  UGScreenCrackController
//
//  Created by UnrealGlitch on 09.09.2026.
//

import SpriteKit
import UIKit

extension UGScreenCrackController {

    /// Builds a random crack only when all its layers fit inside the available area.
    /// - Parameters:
    ///   - size: Size of the crack.
    ///   - frame: Available area in scene coordinates.
    internal func buildCrackNode(size: CGSize, within frame: CGRect) -> SKNode? {
        let appearance = inputData.appearanceConfiguration
        let mainPath = CGMutablePath()
        let detailPath = CGMutablePath()
        let branches = mainBranches(size: size)

        for points in branches {
            let width = CGFloat.random(in: 0.85...1.3)
            addTaperedPath(to: mainPath, points: points, width: width)
            addForks(to: detailPath, along: points, width: width)
        }
        addConnections(to: detailPath, between: branches)

        let edgePath = CGMutablePath()
        edgePath.addPath(mainPath)
        edgePath.addPath(detailPath)
        let pathBounds = edgePath.boundingBoxOfPath
        let bounds = pathBounds.union(pathBounds.offsetBy(
            dx: appearance.edgeOffset.x,
            dy: appearance.edgeOffset.y
        ))
        guard let position = randomPosition(for: bounds, within: frame) else {
            return nil
        }

        let node = SKNode()
        node.position = position
        node.zPosition = inputData.crackConfiguration.crackZPosition

        let edge = filledNode(path: edgePath, color: appearance.edgeColor)
        edge.position = appearance.edgeOffset
        node.addChild(edge)

        let main = filledNode(path: mainPath, color: appearance.mainColor)
        main.zPosition = ZPositions.main.rawValue
        node.addChild(main)

        let details = filledNode(path: detailPath, color: appearance.detailColor)
        details.zPosition = ZPositions.details.rawValue
        node.addChild(details)
        return node
    }

}

// MARK: - Private functions

private extension UGScreenCrackController {

    /// Places the complete crack, including forks and the edge, inside the available area.
    /// - Parameters:
    ///   - bounds: Bounds of the crack node.
    ///   - frame: Available area in scene coordinates.
    func randomPosition(for bounds: CGRect, within frame: CGRect) -> CGPoint? {
        let minX = frame.minX - bounds.minX
        let maxX = frame.maxX - bounds.maxX
        let minY = frame.minY - bounds.minY
        let maxY = frame.maxY - bounds.maxY
        guard minX <= maxX, minY <= maxY else {
            return nil
        }

        return CGPoint(
            x: CGFloat.random(in: minX...maxX),
            y: CGFloat.random(in: minY...maxY)
        )
    }

    /// Draws all outlines of a layer with a single node.
    func filledNode(path: CGPath, color: UIColor) -> SKShapeNode {
        let node = SKShapeNode(path: path)
        node.fillColor = color
        node.strokeColor = .clear
        node.lineWidth = 0
        node.isAntialiased = true
        node.isUserInteractionEnabled = false
        return node
    }

}
