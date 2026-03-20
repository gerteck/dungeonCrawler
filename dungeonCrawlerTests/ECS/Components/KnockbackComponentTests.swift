//
//  KnockbackComponentTests.swift
//  dungeonCrawlerTests
//
//  Created by Wen Kang Yap on 19/3/26.
//

import XCTest
import simd
@testable import dungeonCrawler

final class KnockbackComponentTests: XCTestCase {

    // MARK: - Default initialisation

    func testDefaultRemainingTime() {
        let kb = KnockbackComponent(velocity: .zero)
        XCTAssertEqual(kb.remainingTime, 0.2, accuracy: 0.001)
    }

    func testVelocityStoredCorrectly() {
        let vel = SIMD2<Float>(100, -50)
        let kb = KnockbackComponent(velocity: vel)
        XCTAssertEqual(kb.velocity.x, 100, accuracy: 0.001)
        XCTAssertEqual(kb.velocity.y, -50, accuracy: 0.001)
    }

    // MARK: - Custom initialisation

    func testCustomRemainingTime() {
        let kb = KnockbackComponent(velocity: .zero, remainingTime: 0.5)
        XCTAssertEqual(kb.remainingTime, 0.5, accuracy: 0.001)
    }

    func testCustomVelocityAndDuration() {
        let kb = KnockbackComponent(velocity: SIMD2(200, 300), remainingTime: 0.3)
        XCTAssertEqual(kb.velocity.x, 200, accuracy: 0.001)
        XCTAssertEqual(kb.velocity.y, 300, accuracy: 0.001)
        XCTAssertEqual(kb.remainingTime, 0.3, accuracy: 0.001)
    }

    // MARK: - Mutation

    func testRemainingTimeCanBeDecremented() {
        var kb = KnockbackComponent(velocity: .zero, remainingTime: 0.3)
        kb.remainingTime -= 0.1
        XCTAssertEqual(kb.remainingTime, 0.2, accuracy: 0.001)
    }

    func testVelocityCanBeChanged() {
        var kb = KnockbackComponent(velocity: SIMD2(100, 0))
        kb.velocity = SIMD2(0, 200)
        XCTAssertEqual(kb.velocity.x, 0, accuracy: 0.001)
        XCTAssertEqual(kb.velocity.y, 200, accuracy: 0.001)
    }

    func testRemainingTimeCanGoBelowZero() {
        var kb = KnockbackComponent(velocity: .zero, remainingTime: 0.1)
        kb.remainingTime -= 0.2
        XCTAssertLessThan(kb.remainingTime, 0)
    }
}
