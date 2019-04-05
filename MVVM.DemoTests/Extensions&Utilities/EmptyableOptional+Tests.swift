//
//  EmptyableOptional+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

fileprivate struct EmptyTrueTestObject: EmptyableOptional {
    var isEmpty: Bool { return true }
}

fileprivate struct EmptyFalseTestObject: EmptyableOptional {
    var isEmpty: Bool { return false }
}

class EmptyableOptionalTests: XCTestCase {
    func test_when_target_is_nil_isNilOrEmpty_is_true() {
        let target: EmptyTrueTestObject? = nil
        XCTAssertEqual(target.isNilOrEmpty, true)
    }
    
    func test_when_target_isEmpty_is_true_isNilOrEmpty_is_true() {
        let target: EmptyTrueTestObject? = EmptyTrueTestObject()
        XCTAssertEqual(target.isNilOrEmpty, true)
    }
    
    func test_when_target_isEmpty_is_false_isNilOrEmpty_is_false() {
        let target: EmptyFalseTestObject? = EmptyFalseTestObject()
        XCTAssertEqual(target.isNilOrEmpty, false)
    }
}
