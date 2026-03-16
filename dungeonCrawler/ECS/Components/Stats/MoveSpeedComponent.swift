//
//  MoveSpeedComponent.swift
//  dungeonCrawler
//
//  Created by Ger Teck on 16/3/26.
//

import Foundation

public struct MoveSpeedComponent: Component {
    public var value: StatValue

    public init(base: Float) {
        self.value = StatValue(base: base, min: 0, max: nil)
    }
}
