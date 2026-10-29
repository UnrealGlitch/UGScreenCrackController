//
//  UGScreenCrackControllerInputData.swift
//  UGScreenCrackController
//
//  Created by UnrealGlitch on 09.09.2026.
//

/// Input data for the UGScreenCrackController class for initialization.
public struct UGScreenCrackControllerInputData {

    // MARK: - Life cycle

    /// Initializer.
    /// - Parameters:
    ///   - crackConfiguration: Crack placement, size, and count configuration.
    ///   - appearanceConfiguration: Crack colors and edge configuration.
    public init(
        crackConfiguration: UGCrackConfiguration,
        appearanceConfiguration: UGCrackAppearanceConfiguration
    ) {
        self.crackConfiguration = crackConfiguration
        self.appearanceConfiguration = appearanceConfiguration
    }

    // MARK: - Internal properties

    /// Crack placement, size, and count configuration.
    internal let crackConfiguration: UGCrackConfiguration

    /// Crack colors and edge configuration.
    internal let appearanceConfiguration: UGCrackAppearanceConfiguration

}
