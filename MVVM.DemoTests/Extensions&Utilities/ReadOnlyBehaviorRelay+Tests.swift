//
//  ReadOnlyBehaviorRelay+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo
import RxSwift
import RxCocoa

class ReadOnlyBehaviorRelay_Tests: XCTestCase {
    var backingRelay: BehaviorRelay<String?>!
    var target: ReadOnlyBehaviorRelay<String?>!
    
    override func setUp() {
        super.setUp()
        
        self.backingRelay = BehaviorRelay(value: "InitialValue")
        self.target = ReadOnlyBehaviorRelay(self.backingRelay)
    }
}

class ReadOnlyBehaviorRelay_when_initialized: ReadOnlyBehaviorRelay_Tests {
    func test_then_value_is_equal_to_backingRelay_value() {
        XCTAssertEqual(self.target.value, self.backingRelay.value)
    }
}
