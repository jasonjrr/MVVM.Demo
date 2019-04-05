//
//  UIView+ShadowDepth+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/7/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
import UIKit
@testable import MVVM_Demo

class UIView_ShadowDepth_Static_Tests: XCTestCase {
    func test_defaultShadowOpacity_is_expected() {
        XCTAssertEqual(UIView.defaultShadowOpacity, 0.24)
    }
    
    func test_defaultShadowColor_is_expected() {
        XCTAssertEqual(UIView.defaultShadowColor, UIColor.black)
    }
}

class UIView_ShadowDepth_Test: XCTestCase {
    var targetView: UIView!
    
    override func setUp() {
        super.setUp()
        
        self.targetView = UIView()
    }
}

class UIView_ShadowDepth_when_applyShadow_is_called: UIView_ShadowDepth_Test {
    let expectedMasksToBounds: Bool = false
    let expectedShadowColor: UIColor = UIColor.green
    let expectedShadowOffset: CGSize = CGSize(width: 10, height: 10)
    let expectedShadowOpacity: Float = 0.24
    let expectedShadowRadius: CGFloat = 8
    
    override func setUp() {
        super.setUp()
        
        self.targetView.applyShadow(
            horizontalOffset: self.expectedShadowOffset.width,
            verticalOffset: self.expectedShadowOffset.height,
            opacity: self.expectedShadowOpacity,
            radius: self.expectedShadowRadius,
            color: self.expectedShadowColor)
    }
    
    func test_then_masksToBounds_is_expected() {
        XCTAssertEqual(self.targetView.layer.masksToBounds, self.expectedMasksToBounds)
    }
    
    func test_then_shadowColor_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowColor, self.expectedShadowColor.cgColor)
    }
    
    func test_then_shadowOffset_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowOffset, self.expectedShadowOffset)
    }
    
    func test_then_shadowOpacity_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowOpacity, self.expectedShadowOpacity)
    }
    
    func test_then_shadowRadius_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowRadius, self.expectedShadowRadius)
    }
}

class UIView_ShadowDepth_when_applyShadow_is_called_and_verticalOffset_is_less_than_1: UIView_ShadowDepth_Test {
    override func setUp() {
        super.setUp()
        
        self.targetView.applyShadow(
            horizontalOffset: 10,
            verticalOffset: -1,
            opacity: 0.24,
            radius: 8,
            color: UIColor.black)
    }
    
    func test_then_actual_verticalOffset_is_1() {
        XCTAssertEqual(self.targetView.layer.shadowOffset.height, 1)
    }
}

class UIView_ShadowDepth_when_applyShadow_is_called_with_color_defaulted: UIView_ShadowDepth_Test {
    let expectedMasksToBounds: Bool = false
    let expectedShadowOffset: CGSize = CGSize(width: 10, height: 10)
    let expectedShadowOpacity: Float = 0.24
    let expectedShadowRadius: CGFloat = 8

    override func setUp() {
        super.setUp()
        
        self.targetView.applyShadow(
            horizontalOffset: self.expectedShadowOffset.width,
            verticalOffset: self.expectedShadowOffset.height,
            opacity: self.expectedShadowOpacity,
            radius: self.expectedShadowRadius)
    }
    
    func test_then_masksToBounds_is_expected() {
        XCTAssertEqual(self.targetView.layer.masksToBounds, self.expectedMasksToBounds)
    }
    
    func test_then_shadowColor_is_default() {
        XCTAssertEqual(self.targetView.layer.shadowColor, UIView.defaultShadowColor.cgColor)
    }
    
    func test_then_shadowOffset_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowOffset, self.expectedShadowOffset)
    }
    
    func test_then_shadowOpacity_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowOpacity, self.expectedShadowOpacity)
    }
    
    func test_then_shadowRadius_is_expected() {
        XCTAssertEqual(self.targetView.layer.shadowRadius, self.expectedShadowRadius)
    }
}

class UIView_ShadowDepth_when_hideShadow_is_called: UIView_ShadowDepth_Test {
    override func setUp() {
        super.setUp()
        
        self.targetView.applyShadow(
            horizontalOffset: 10,
            verticalOffset: -1,
            opacity: 0.24,
            radius: 8,
            color: UIColor.black)
        
        self.targetView.hideShadow()
    }
    
    func test_then_shadowOpacity_is_0() {
        XCTAssertEqual(self.targetView.layer.shadowOpacity, 0)
    }
}

class UIView_ShadowDepth_when_applyShadowDown_withDepth_is_called: UIView_ShadowDepth_Test {
    func test_then_vertical_offset_is_greater_than_0() {
        for depth: Int in 1..<30 {
            self.targetView.applyShadowDown(withDepth: depth)
            XCTAssert(self.targetView.layer.shadowOffset.height > 0)
        }
    }
    
    func test_and_depth_is_0_then_shadowOpacity_is_0() {
        self.targetView.applyShadowDown(withDepth: 0)
        XCTAssertEqual(self.targetView.layer.shadowOpacity, 0)
    }
}
