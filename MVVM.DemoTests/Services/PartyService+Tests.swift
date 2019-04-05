//
//  PartyService+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

class PartyService_Test: XCTestCase {
    var target: PartyService!
    
    override func setUp() {
        super.setUp()
        
        self.target = PartyService()
    }
}

class PartyService_when_getNextColor_is_called: PartyService_Test {
    func test_then_the_expected_color_is_returned() {
        XCTAssertEqual(self.target.getNextColor(), UIColor.red)
        XCTAssertEqual(self.target.getNextColor(), UIColor.orange)
        XCTAssertEqual(self.target.getNextColor(), UIColor.yellow)
        XCTAssertEqual(self.target.getNextColor(), UIColor.green)
        XCTAssertEqual(self.target.getNextColor(), UIColor.blue)
        XCTAssertEqual(self.target.getNextColor(), UIColor.purple)
        // restart
        XCTAssertEqual(self.target.getNextColor(), UIColor.red)
        XCTAssertEqual(self.target.getNextColor(), UIColor.orange)
        XCTAssertEqual(self.target.getNextColor(), UIColor.yellow)
        XCTAssertEqual(self.target.getNextColor(), UIColor.green)
        XCTAssertEqual(self.target.getNextColor(), UIColor.blue)
        XCTAssertEqual(self.target.getNextColor(), UIColor.purple)
    }
}

class PartyService_when_getRandomEmoji_is_called: PartyService_Test {
    var expectedEmojis: [String]!
    
    override func setUp() {
        super.setUp()
        
        self.expectedEmojis = [
            "😀",
            "🤣",
            "🤪",
            "🧐",
            "😎",
            "😏",
            "😤",
            "🤯",
            "😳",
            "🤮",
        ]
    }
    
    func test_then_emoji_returned_is_expected() {
        for _ in 0..<200 {
            XCTAssertTrue(self.expectedEmojis
                .contains(self.target.getRandomEmoji()))
        }
    }
}
