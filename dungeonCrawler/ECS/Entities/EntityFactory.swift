//
//  EntityFactory.swift
//  dungeonCrawler
//
//  Created by Jannice Suciptono on 11/3/26.
//

import Foundation
import simd

public enum EntityFactory {
    
    // MARK: - Player
    //
    // Components attached:
    //   • TransformComponent  — position, rotation, scale
    //   • VelocityComponent   — movement vector (starts at zero)
    //   • InputComponent      — intent from InputSystem
    //   • SpriteComponent     — visual representation
    //   • PlayerTag           — marks this as the human-controlled entity
    //
    // Future additions:
    //   • StatsComponent      — health, attack, speed modifier
    //   • WeaponSlotComponent — which weapon is equipped
    //   • AnimationComponent  — walk / idle / attack animation state machine
    
    @discardableResult
    public static func makePlayer(
        in world: World,
        at position: SIMD2<Float>,
        textureName: String = "knight", // set to knight for now
        scale: Float = 1
    ) -> Entity {
        let entity = world.createEntity()
        
        world.addComponent(component: TransformComponent(position: position, rotation: 0, scale: scale), to: entity)
        world.addComponent(component: VelocityComponent(), to: entity)
        world.addComponent(component: InputComponent(), to: entity)
        world.addComponent(component: SpriteComponent(textureName: textureName), to: entity)
        world.addComponent(component: PlayerTagComponent(), to: entity)
        
        return entity
    }

    @discardableResult
    public static func makeWeapon(
        in world: World,
        ownedBy player: Entity,
        offset: SIMD2<Float> = .zero,
        scale: Float = 1
    ) -> Entity {
        let entity = world.createEntity()
        
        let startPos = world.getComponent(component: TransformComponent.self, for: player)?.position ?? .zero
        world.addComponent(component: TransformComponent(position: startPos + offset, rotation: 0, scale: scale), to: entity)
        world.addComponent(component: OwnerComponent(ownerEntity: player, offset: offset), to: entity)
        world.addComponent(component: WeaponComponent(type: .handgun, baseDamage: 10, effectiveRange: 10, manaCost: 10, attackSpeed: 1, 
                                                      coolDownInterval: TimeInterval(startTime: 0, duration: 1)), to: entity)
        return entity
    }
}
