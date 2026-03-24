//
//  RoomEntityFactory.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 24/3/26.
//

import Foundation
import simd

// Creates a room entity with all necessary components
//
// Components attached:
//   • RoomComponent       — bounds, doorways, spawn points
//   • TransformComponent  — position at room center (for spatial queries)
//
// Future additions:
//   • RoomThemeComponent  — visual style (dungeon, forest, ice cave)
//   • RoomLootComponent   — treasure chest spawn points

public struct RoomEntityFactory: EntityFactory {
    let bounds: RoomBounds
    let doorways: [Doorway]
    let spawnPoints: [SpawnPoint]
    let useGrid: Bool

    public init(
        bounds: RoomBounds,
        doorways: [Doorway] = [],
        spawnPoints: [SpawnPoint] = [],
        useGrid: Bool = false
    ) {
        self.bounds = bounds
        self.doorways = doorways
        self.spawnPoints = spawnPoints
        self.useGrid = useGrid
    }

    @discardableResult
    public func make(in world: World) -> Entity {
        let entity = world.createEntity()
        var roomComponent = RoomComponent(bounds: bounds, doorways: doorways, spawnPoints: spawnPoints)

        // Optionally add grid layout for tile-based generation
        if useGrid {
            let gridSize = SIMD2<Int>(
                Int(bounds.size.x / 32), // 32 units per tile
                Int(bounds.size.y / 32)
            )
            roomComponent.gridLayout = GridLayout(gridSize: gridSize, cellSize: 32)
        }

        world.addComponent(component: roomComponent, to: entity)
        world.addComponent(component: TransformComponent(position: bounds.center), to: entity)
        return entity
    }
}
