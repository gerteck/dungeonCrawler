//
//  HealthComponent.swift
//  dungeonCrawler
//
//  Created by Ger Teck on 16/3/26.
//

import Foundation

public struct HealthComponent: StatProvidable {
    public var value: StatValue

    public init(base: Float, max: Float? = nil) {
        self.value = StatValue(base: base, max: max ?? base)
    }
}
