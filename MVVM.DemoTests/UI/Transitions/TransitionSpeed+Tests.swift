//
//  TransitionSpeed+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/7/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

class TransitionSpeedTests: XCTestCase {
    func test_presentDuration_is_expected() {
        XCTAssertEqual(TransitionSpeed.default.presentDuration, 0.3)
        XCTAssertEqual(TransitionSpeed.fullScreen.presentDuration, 0.375)
        XCTAssertEqual(TransitionSpeed.dialogSmall.presentDuration, 0.24)
        XCTAssertEqual(TransitionSpeed.dialogMedium.presentDuration, 0.3)
        XCTAssertEqual(TransitionSpeed.dialogLarge.presentDuration, 0.35)
    }
    
    func test_dismissDuration_is_expected() {
        XCTAssertEqual(TransitionSpeed.default.dismissDuration, 0.24)
        XCTAssertEqual(TransitionSpeed.fullScreen.dismissDuration, 0.34)
        XCTAssertEqual(TransitionSpeed.dialogSmall.dismissDuration, 0.16)
        XCTAssertEqual(TransitionSpeed.dialogMedium.dismissDuration, 0.2)
        XCTAssertEqual(TransitionSpeed.dialogLarge.dismissDuration, 0.24)
    }
}
