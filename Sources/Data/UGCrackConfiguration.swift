//
//  UGCrackConfiguration.swift
//  UGScreenCrackController
//
//  Created by UnrealGlitch on 09.09.2026.
//

import UIKit

/// Crack placement, size, and count configuration.
public struct UGCrackConfiguration {

    // MARK: - Life cycle

    /// Initializer.
    /// - Parameters:
    ///   - crackZPosition: Z position of the cracks.
    ///   - maxCracks: Maximum number of simultaneous cracks. Nonpositive values disable cracks.
    ///   - crackSize: Range used to choose width and height. Bounds must be positive and finite.
    public init(
        crackZPosition: CGFloat,
        maxCracks: Int = 20,
        crackSize: ClosedRange<CGFloat> = 40...80
    ) {
        self.crackZPosition = crackZPosition
        self.maxCracks = maxCracks
        self.crackSize = crackSize
    }

    // MARK: - Internal properties

    /// Z position of the cracks.
    internal let crackZPosition: CGFloat

    /// Maximum number of simultaneous cracks.
    internal let maxCracks: Int

    /// Range used to choose the width and height of each crack.
    internal let crackSize: ClosedRange<CGFloat>

}
