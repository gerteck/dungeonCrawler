//
//  StatValue.swift
//  dungeonCrawler
//
//  Created by Ger Teck on 16/3/26.
//

import Foundation

public struct StatValue {
    public var base: Float
    public var current: Float
    public var min: Float
    public var max: Float?

    public init(base: Float, min: Float = 0, max: Float? = nil) {
        self.base = base
        self.current = base
        self.min = min
        self.max = max
    }

    public mutating func clampToBounds() {
        current = Swift.max(min, current)
        if let max {
            current = Swift.min(max, current)
        }
    }
}
