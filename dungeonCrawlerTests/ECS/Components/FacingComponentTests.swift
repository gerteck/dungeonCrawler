//
//  FacingComponentTests.swift
//  dungeonCrawlerTests
//
//  Created by Letian on 21/3/26.
//

import Foundation
import XCTest
import simd
@testable import dungeonCrawler

/**
 * Now only player entity has facing component composed
 *
 * Only 9 cases can happen
 * Move: left, right, no-op
 * Fire: left, right, no-op
 */
@MainActor
class FacingComponentTests: XCTestCase {
    var world: World!
    var mockProvider: MockInputProvider!
    var system: InputSystem!

    override func setUp() {
        super.setUp()
        world = World()
        mockProvider = MockInputProvider()
        system = InputSystem(inputProvider: mockProvider)
    }

    override func tearDown() {
        system = nil
        mockProvider = nil
        world = nil
        super.tearDown()
    }
    
    private func initEntityFacingRight() -> Entity {
        let entity = world.createEntity()
        world.addComponent(component: InputComponent(), to: entity)
        world.addComponent(component: FacingComponent(facing: .right), to: entity)
        return entity
    }
    private func initEntityFacingLeft() -> Entity {
        let entity = world.createEntity()
        world.addComponent(component: InputComponent(), to: entity)
        world.addComponent(component: FacingComponent(facing: .left), to: entity)
        return entity
    }
    
    func testMoveLeftAimLeft() {
        let player = initEntityFacingRight()
        mockProvider.rawMoveVector = SIMD2<Float>(-1, 0)
        mockProvider.rawAimVector = SIMD2<Float>(-1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .left)
    }
    
    func testMoveLeftAimRight() {
        let player = initEntityFacingRight()
        mockProvider.rawMoveVector = SIMD2<Float>(-1, 0)
        mockProvider.rawAimVector = SIMD2<Float>(1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .right)
    }
    
    func testMoveLeftAimRightStartLeft() {
        let player = initEntityFacingLeft()
        mockProvider.rawMoveVector = SIMD2<Float>(-1, 0)
        mockProvider.rawAimVector = SIMD2<Float>(1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .right)
    }
    
    func testMoveRightAimLeft() {
        let player = initEntityFacingRight()
        mockProvider.rawMoveVector = SIMD2<Float>(1, 0)
        mockProvider.rawAimVector = SIMD2<Float>(-1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .left)
    }
    
    func testMoveRighttAimRight() {
        let player = initEntityFacingRight()
        mockProvider.rawMoveVector = SIMD2<Float>(1, 0)
        mockProvider.rawAimVector = SIMD2<Float>(1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .right)
    }
    
    func testMoveNooptAimRight() {
        let player = initEntityFacingRight()
        mockProvider.rawMoveVector = SIMD2<Float>(0, 0)
        mockProvider.rawAimVector = SIMD2<Float>(1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .right)
    }
    
    func testMoveNooptAimLeft() {
        let player = initEntityFacingRight()
        mockProvider.rawMoveVector = SIMD2<Float>(0, 0)
        mockProvider.rawAimVector = SIMD2<Float>(-1, 0)
        mockProvider.isShootPressed = true
        system.update(deltaTime: 0.1, world: world)
        let facing = world.getComponent(type: FacingComponent.self, for: player)?.facing
        XCTAssertEqual(facing, .left)
    }
}
