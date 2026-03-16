//
//  HealthComponent.swift
//  dungeonCrawler
//
//  Created by Ger Teck on 16/3/26.
//

import Foundation

public struct HealthComponent: Component {
    public var value: StatValue

    public init(base: Float, max: Float? = nil) {
        self.value = StatValue(base: base, min: 0, max: max ?? base)
    }
}
