//
//  MockPartyService.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import Foundation
import XCTest
@testable import MVVM_Demo

class MockPartyService: PartyServiceProtocol {
    var getNextColorTestClosure: (() -> Void)?
    func getNextColor() -> UIColor {
        self.getNextColorTestClosure?()
        return UIColor.blue
    }
    
    var getRandomEmojiTestClosure: (() -> Void)?
    func getRandomEmoji() -> String {
        self.getRandomEmojiTestClosure?()
        return "🤯"
    }
}
