import Foundation
import simd

class WeaponSystem: System {
    var priority: Int = 50
    
    private var gameTime: Float

    init() {
        self.gameTime = 0
    }

    func update(deltaTime: Foundation.TimeInterval, world: World) {
        self.gameTime += Float(deltaTime)

        for (weaponEntity, _, ownerComponent) in world.entities(with: WeaponComponent.self, and: OwnerComponent.self) {
            let ownerEntity = ownerComponent.ownerEntity
            guard let ownerTransform = world.getComponent(type: TransformComponent.self, for: ownerEntity) else { continue }
            let ownerVelocity = world.getComponent(type: VelocityComponent.self, for: ownerEntity)
            // Determine facing direction from owner velocity; default to current weapon xScale
            let facingRight: Bool
            if let vx = ownerVelocity?.linear.x, vx != 0 {
                facingRight = vx > 0
            } else {
                facingRight = true // fallback — ideally persist last direction
            }

            let mirroredOffset = SIMD2<Float>(
                facingRight ? ownerComponent.offset.x : -ownerComponent.offset.x,
                ownerComponent.offset.y
            )

            world.modifyComponent(type: TransformComponent.self, for: weaponEntity) { transform in
                transform.position = ownerTransform.position + mirroredOffset
            }

            // Copy owner velocity so syncNode's flipFactor logic flips the weapon sprite
            world.modifyComponent(type: VelocityComponent.self, for: weaponEntity) { vel in
                vel.linear.x = ownerVelocity?.linear.x ?? vel.linear.x
            }
        }


    }
}
