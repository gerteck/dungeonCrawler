//
//  KnockbackSystemTests.swift
//  dungeonCrawlerTests
//
//  Created by Wen Kang Yap on 19/3/26.
//

import XCTest
import simd
@testable import dungeonCrawler

@MainActor
final class KnockbackSystemTests: XCTestCase {

    var world: World!
    var system: KnockbackSystem!

    override func setUp() {
        super.setUp()
        world = World()
        system = KnockbackSystem()
    }

    override func tearDown() {
        world = nil
        system = nil
        super.tearDown()
    }

    // MARK: - Position integration

    func testKnockbackMovesEntityByVelocityTimesDeltaTime() {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entity)
        world.addComponent(component: KnockbackComponent(velocity: SIMD2(100, 0), remainingTime: 1.0), to: entity)

        system.update(deltaTime: 0.5, world: world)

        let transform = world.getComponent(type: TransformComponent.self, for: entity)
        XCTAssertNotNil(transform)
        XCTAssertEqual(transform!.position.x, 50, accuracy: 0.001)
        XCTAssertEqual(transform!.position.y, 0, accuracy: 0.001)
    }

    func testKnockbackMovesInCorrectDirection() {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entity)
        world.addComponent(component: KnockbackComponent(velocity: SIMD2(-200, 150), remainingTime: 1.0), to: entity)

        system.update(deltaTime: 1.0, world: world)

        let transform = world.getComponent(type: TransformComponent.self, for: entity)
        XCTAssertNotNil(transform)
        XCTAssertEqual(transform!.position.x, -200, accuracy: 0.001)
        XCTAssertEqual(transform!.position.y, 150, accuracy: 0.001)
    }

    // MARK: - Timer countdown

    func testRemainingTimeDecreasesByDeltaTime() {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entity)
        world.addComponent(component: KnockbackComponent(velocity: .zero, remainingTime: 0.5), to: entity)

        system.update(deltaTime: 0.2, world: world)

        let kb = world.getComponent(type: KnockbackComponent.self, for: entity)
        XCTAssertNotNil(kb)
        XCTAssertEqual(kb!.remainingTime, 0.3, accuracy: 0.001)
    }

    // MARK: - Component removal

    func testKnockbackComponentRemovedWhenExpired() {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entity)
        world.addComponent(component: KnockbackComponent(velocity: .zero, remainingTime: 0.1), to: entity)

        system.update(deltaTime: 0.2, world: world)

        XCTAssertNil(world.getComponent(type: KnockbackComponent.self, for: entity))
    }

    func testKnockbackComponentKeptWhenNotExpired() {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entity)
        world.addComponent(component: KnockbackComponent(velocity: .zero, remainingTime: 0.5), to: entity)

        system.update(deltaTime: 0.1, world: world)

        XCTAssertNotNil(world.getComponent(type: KnockbackComponent.self, for: entity))
    }

    // MARK: - Entities without knockback unaffected

    func testEntityWithoutKnockbackNotMoved() {
        let entity = world.createEntity()
        world.addComponent(component: TransformComponent(position: SIMD2(50, 50)), to: entity)

        system.update(deltaTime: 1.0, world: world)

        let transform = world.getComponent(type: TransformComponent.self, for: entity)
        XCTAssertNotNil(transform)
        XCTAssertEqual(transform!.position.x, 50, accuracy: 0.001)
        XCTAssertEqual(transform!.position.y, 50, accuracy: 0.001)
    }

    // MARK: - Multiple entities

    func testMultipleEntitiesHandledIndependently() {
        let entityA = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entityA)
        world.addComponent(component: KnockbackComponent(velocity: SIMD2(100, 0), remainingTime: 1.0), to: entityA)

        let entityB = world.createEntity()
        world.addComponent(component: TransformComponent(position: .zero), to: entityB)
        world.addComponent(component: KnockbackComponent(velocity: SIMD2(0, 100), remainingTime: 1.0), to: entityB)

        system.update(deltaTime: 1.0, world: world)

        let transformA = world.getComponent(type: TransformComponent.self, for: entityA)
        let transformB = world.getComponent(type: TransformComponent.self, for: entityB)
        XCTAssertEqual(transformA!.position.x, 100, accuracy: 0.001)
        XCTAssertEqual(transformA!.position.y, 0,   accuracy: 0.001)
        XCTAssertEqual(transformB!.position.x, 0,   accuracy: 0.001)
        XCTAssertEqual(transformB!.position.y, 100, accuracy: 0.001)
    }
}
