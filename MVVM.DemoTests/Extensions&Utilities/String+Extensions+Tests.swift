//
//  String+Extensions+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

class StringExtensionsTests: XCTestCase {
    func test_StringDotEmpty_equals_double_quote() {
        XCTAssertEqual(String.empty, "")
    }
}
