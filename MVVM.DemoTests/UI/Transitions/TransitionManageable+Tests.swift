//
//  TransitionManageable+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

fileprivate class TestTransitionManager: TransitionManager {}

fileprivate class TransitionManageableTestViewController: UIViewController, TransitionManageable {
    private(set) var transitionManager: TransitionManager?
    
    init(transitionManager: TransitionManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.transitionManager = transitionManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController_TransitionManageable_Extension_Tests: XCTestCase {
    fileprivate var expectedTransitionManager: TestTransitionManager!
    var target: UIViewController!
    
    override func setUp() {
        super.setUp()
        
        self.expectedTransitionManager = TestTransitionManager()
        self.target = TransitionManageableTestViewController(transitionManager: self.expectedTransitionManager)
    }
    
    func test_when_getTransitionManager_getTransitionManager_returns_expected() {
        XCTAssertEqual(self.target.getTransitionManager(), self.expectedTransitionManager)
    }
    
    func test_when_viewController_is_not_TransitionManageable_getTransitionManager_returns_nil() {
        XCTAssertNil(UIViewController().getTransitionManager())
    }
}
