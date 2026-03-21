//
//  ProjectileSystem.swift
//  dungeonCrawler
//
//  Created by Letian on 20/3/26.
//

import Foundation
import simd

public final class ProjectileSystem: System {
    public let priority: Int = 60 // After weapon spawn new projectiles
    public func update(deltaTime: Double, world: World) {
        let dt = Float(deltaTime)
        for (projectileEntity, _, velocityComponent, _) in world.entities(with: ProjectileComponent.self, and: VelocityComponent.self, and: TransformComponent.self) {
            world.modifyComponent(type: TransformComponent.self, for: projectileEntity) { transform in
                transform.position += velocityComponent.linear * dt
            }
            world.modifyComponent(type: EffectiveRangeComponent.self, for: projectileEntity) { rangeComponent in
                rangeComponent.value.current -= simd_length(velocityComponent.linear) * dt
            }
            if let range = world.getComponent(type: EffectiveRangeComponent.self, for: projectileEntity), range.value.current <= 0 {
                world.destroyEntity(entity: projectileEntity)
            }
        }
    }
}
