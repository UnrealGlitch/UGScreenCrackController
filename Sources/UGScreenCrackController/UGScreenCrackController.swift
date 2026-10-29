//
//  UGScreenCrackController.swift
//  UGScreenCrackController
//
//  Created by UnrealGlitch on 09.09.2026.
//

import SpriteKit

/// A controller for drawing procedural glass cracks on a SpriteKit scene.
/// ## Description
/// Each crack has tapered branches, small forks, connecting fractures, and a dark edge.
/// The controller keeps up to the configured number of cracks, removing the oldest when needed.
/// ## Initialization
/// ### UGCrackConfiguration
///   - crackZPosition: Z position of the cracks.
///   - maxCracks: Maximum number of simultaneous cracks.
///   - crackSize: Range used to choose the width and height of each crack.
/// ### UGCrackAppearanceConfiguration
///   - edgeColor: Color of the dark edge.
///   - mainColor: Color of the main fractures.
///   - detailColor: Color of forks and connecting fractures.
///   - edgeOffset: Offset of the edge relative to the fractures.
/// ## Usage example
/// ```swift
/// self.crackController = UGScreenCrackController(
///     on: scene,
///     inputData: UGScreenCrackControllerInputData(
///         crackConfiguration: UGCrackConfiguration(crackZPosition: 100),
///         appearanceConfiguration: UGCrackAppearanceConfiguration()
///     )
/// )
/// crackController?.addRandomCrack(in: scene.frame.insetBy(dx: 24, dy: 24))
/// // When leaving the scene:
/// crackController?.stop()
/// ```
/// - Important: Create and use the controller on the main thread.
/// - Note: The caller supplies the available area in scene coordinates, including HUD margins.
public final class UGScreenCrackController {

    // MARK: - Life cycle

    /// Initializer.
    /// - Parameters:
    ///   - scene: The game scene. The controller keeps a weak reference to it.
    ///   - inputData: Input data.
    public init(on scene: SKScene, inputData: UGScreenCrackControllerInputData) {
        self.scene = scene
        self.inputData = inputData
        crackNodes.reserveCapacity(max(.zero, inputData.crackConfiguration.maxCracks))
    }

    /// Deinitializer.
    deinit {
        stop()
    }

    // MARK: - Public functions

    /// Adds a crack at a random position within the available area.
    /// - Parameter frame: Available area in scene coordinates, including the desired margins.
    /// - Note: A crack is skipped if its complete outline does not fit inside the area.
    public func addRandomCrack(in frame: CGRect) {
        let configuration = inputData.crackConfiguration

        guard let scene, configuration.maxCracks > .zero,
              configuration.crackSize.lowerBound > .zero,
              configuration.crackSize.upperBound.isFinite,
              frame.minX.isFinite, frame.maxX.isFinite,
              frame.minY.isFinite, frame.maxY.isFinite else {
            return
        }

        let size = CGSize(
            width: CGFloat.random(in: configuration.crackSize),
            height: CGFloat.random(in: configuration.crackSize)
        )
        guard let crackNode = buildCrackNode(size: size, within: frame) else {
            return
        }

        if crackNodes.count == configuration.maxCracks {
            crackNodes.removeFirst().removeFromParent()
        }
        crackNodes.append(crackNode)
        scene.addChild(crackNode)
    }

    /// Removes all cracks and releases the scene reference.
    /// - Note: Repeated calls are safe. Create a new controller to add cracks after stopping.
    public func stop() {
        for node in crackNodes {
            node.removeFromParent()
        }
        crackNodes.removeAll()
        scene = nil
    }

    // MARK: - Internal enums

    /// Z positions of crack layers relative to their parent.
    internal enum ZPositions: CGFloat {
        /// Main fractures.
        case main = 0.01

        /// Forks and connecting fractures.
        case details = 0.02
    }

    // MARK: - Internal properties

    /// Input data.
    internal let inputData: UGScreenCrackControllerInputData

    // MARK: - Private properties

    /// The game scene.
    private weak var scene: SKScene?

    /// Active cracks attached to the scene.
    private var crackNodes: [SKNode] = []

}
