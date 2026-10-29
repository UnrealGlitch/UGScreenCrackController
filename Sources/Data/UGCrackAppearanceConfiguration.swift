//
//  UGCrackAppearanceConfiguration.swift
//  UGScreenCrackController
//
//  Created by UnrealGlitch on 09.09.2026.
//

import UIKit

/// Crack colors and edge configuration.
public struct UGCrackAppearanceConfiguration {

    // MARK: - Life cycle

    /// Initializer.
    /// - Parameters:
    ///   - edgeColor: Color of the dark edge.
    ///   - mainColor: Color of the main fractures.
    ///   - detailColor: Color of forks and connecting fractures.
    ///   - edgeOffset: Offset of the edge relative to the fractures.
    public init(
        edgeColor: UIColor,
        mainColor: UIColor,
        detailColor: UIColor,
        edgeOffset: CGPoint
    ) {
        self.edgeColor = edgeColor
        self.mainColor = mainColor
        self.detailColor = detailColor
        self.edgeOffset = edgeOffset
    }

    // MARK: - Internal properties

    /// Color of the dark edge.
    internal let edgeColor: UIColor

    /// Color of the main fractures.
    internal let mainColor: UIColor

    /// Color of forks and connecting fractures.
    internal let detailColor: UIColor

    /// Offset of the edge relative to the fractures.
    internal let edgeOffset: CGPoint

}
