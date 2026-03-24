//
//  EnemyEntityFactory.swift
//  dungeonCrawler
//
//  Created by Wen Kang Yap on 24/3/26.
//

import Foundation
import simd

// Components attached:
//   • TransformComponent   — position, rotation, scale
//   • SpriteComponent      — visual representation
//   • EnemyTagComponent    — marks this as an enemy and holds its type
//   • VelocityComponent    — movement vector (set each frame by EnemyAISystem)
//   • EnemyStateComponent  — AI mode (wander/chase) and related config
//   • CollisionBoxComponent  — axis-aligned bounding box for collision
//
// Future additions:
//   • HealthComponent      — current / max health
//   • CombatStatsComponent — attack damage, attack speed

public struct EnemyEntityFactory: EntityFactory {
    let position: SIMD2<Float>
    let type: EnemyType
    let baseScale: Float

    public init(
        at position: SIMD2<Float>,
        type: EnemyType,
        baseScale: Float = 1
    ) {
        self.position = position
        self.type = type
        self.baseScale = baseScale
    }

    @discardableResult
    public func make(in world: World) -> Entity {
        let entity = world.createEntity()
        let finalScale = baseScale * type.scale

        world.addComponent(component: TransformComponent(position: position, rotation: 0, scale: finalScale), to: entity)
        world.addComponent(component: SpriteComponent(textureName: type.textureName), to: entity)
        world.addComponent(component: EnemyTagComponent(enemyType: type), to: entity)
        world.addComponent(component: VelocityComponent(), to: entity)
        world.addComponent(component: EnemyStateComponent(), to: entity)
        world.addComponent(component: CollisionBoxComponent(size: SIMD2(48 * finalScale, 48 * finalScale)), to: entity)

        return entity
    }
}
