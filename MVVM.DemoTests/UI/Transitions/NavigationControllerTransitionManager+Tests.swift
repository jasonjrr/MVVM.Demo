//
//  NavigationControllerTransitionManager+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/7/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

fileprivate class TestTransitionManager: TransitionManager {}

fileprivate class TestTransitionManageableViewController: UIViewController, TransitionManageable {
    var transitionManager: TransitionManager?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.transitionManager = TestTransitionManager()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NavigationControllerTransitionManager_Test: XCTestCase {
    var testNavigationController: UINavigationController!
    var target: NavigationControllerTransitionManager!
    
    override func setUp() {
        super.setUp()
        self.testNavigationController = UINavigationController(nibName: nil, bundle: nil)
        self.target = NavigationControllerTransitionManager()
    }
}

class NavigationControllerTransitionManager_when_navigationController_animationControllerFor_is_called: NavigationControllerTransitionManager_Test {
    func test_and_operation_is_none_then_expected_is_nil() {
        let expected: UIViewControllerAnimatedTransitioning? = self.target.navigationController(
            self.testNavigationController,
            animationControllerFor: .none,
            from: UIViewController(nibName: nil, bundle: nil),
            to: UIViewController(nibName: nil, bundle: nil))
        XCTAssertNil(expected)
    }
}

class NavigationControllerTransitionManager_when_navigationController_animationControllerFor_is_called_and_operation_is_push: NavigationControllerTransitionManager_Test {
    fileprivate let toViewController: TestTransitionManageableViewController = TestTransitionManageableViewController()
    var expected: UIViewControllerAnimatedTransitioning?
    
    override func setUp() {
        super.setUp()
        
        self.expected = self.target.navigationController(
            self.testNavigationController,
            animationControllerFor: .push,
            from: UIViewController(nibName: nil, bundle: nil),
            to: self.toViewController)
    }
    
    func test_then_expected_is_toVC_transitionManager() {
        XCTAssert(self.expected === self.toViewController.transitionManager)
    }
    
    func test_then_expected_isPresenting_is_true() {
        let expectedIsPresenting: Bool? = (self.expected as? TransitionManager)?.isPresenting
        XCTAssert(expectedIsPresenting == true)
    }
}

class NavigationControllerTransitionManager_when_navigationController_animationControllerFor_is_called_and_operation_is_pop: NavigationControllerTransitionManager_Test {
    fileprivate let fromViewController: TestTransitionManageableViewController = TestTransitionManageableViewController()
    var expected: UIViewControllerAnimatedTransitioning?
    
    override func setUp() {
        super.setUp()
        
        self.expected = self.target.navigationController(
            self.testNavigationController,
            animationControllerFor: .pop,
            from: self.fromViewController,
            to: UIViewController(nibName: nil, bundle: nil))
    }
    
    func test_then_expected_is_fromVC_transitionManager() {
        XCTAssert(self.expected === self.fromViewController.transitionManager)
    }
    
    func test_then_expected_isPresenting_is_false() {
        let expectedIsPresenting: Bool? = (self.expected as? TransitionManager)?.isPresenting
        XCTAssert(expectedIsPresenting == false)
    }
}

class NavigationControllerTransitionManager_when_navigationController_interactionControllerFor_is_called: NavigationControllerTransitionManager_Test {
    func test_then_expected_is_nil() {
        XCTAssertNil(self.target.navigationController(
            UINavigationController(nibName: nil, bundle: nil),
            interactionControllerFor: TestTransitionManager()))
    }
}
