//
//  LaunchScreenViewModel+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

class MockLaunchScreenViewModelDelegate: LaunchScreenViewModelDelegate {
    var launchScreenViewModelDidLaunchLogInTestClosure: (() -> Void)?
    func launchScreenViewModelDidLaunchLogIn(_ source: LaunchScreenViewModel) {
        self.launchScreenViewModelDidLaunchLogInTestClosure?()
    }
    
    var launchScreenViewModelDidLaunchPartyTestClosure: (() -> Void)?
    func launchScreenViewModelDidLaunchParty(_ source: LaunchScreenViewModel) {
        self.launchScreenViewModelDidLaunchPartyTestClosure?()
    }
}

class LaunchScreenViewModel_Test: XCTestCase {
    var mockUserService: MockUserService!
    var mockPartyService: MockPartyService!
    var target: LaunchScreenViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.mockUserService = MockUserService(isLoggedIn: false)
        self.mockPartyService = MockPartyService()
    
        self.target = LaunchScreenViewModel(
            userService: self.mockUserService,
            partyService: self.mockPartyService)
    }
}

class LaunchScreenViewModel_when_initialized: LaunchScreenViewModel_Test {
    func test_then_target_delegate_is_nil() {
        XCTAssertNil(self.target.delegate)
    }
}

class LaunchScreenViewModel_when_initialized_and_user_is_logged_out: LaunchScreenViewModel_Test {
    func test_then_logInButtonText_is_expected() throws {
        XCTAssertEqual(try self.target.logInButtonText.toBlocking().first(), "Faux Login")
    }
}

class LaunchScreenViewModel_when_initialized_and_user_is_logged_in: LaunchScreenViewModel_Test {
    var expectedUserName: String?
    
    override func setUp() {
        super.setUp()
        self.expectedUserName = self.mockUserService.userName.value
        self.mockUserService.isLoggedInMockValue.accept(true)
    }
    
    func test_then_logInButtonText_is_expected() throws {
        XCTAssertEqual(try self.target.logInButtonText.toBlocking().first(), "Faux Log Out \(self.expectedUserName ?? String.empty)")
    }
}

class LaunchScreenViewModel_when_setup_is_called: LaunchScreenViewModel_Test {
    var mockDelegate: MockLaunchScreenViewModelDelegate!
    var returnTarget: LaunchScreenViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.mockDelegate = MockLaunchScreenViewModelDelegate()
        self.returnTarget = self.target.setup(delegate: self.mockDelegate)
    }
    
    func test_then_returnTarget_is_target() {
        XCTAssertTrue(self.returnTarget === self.target)
    }
    
    func test_then_delegate_is_mockDelegate() {
        XCTAssertTrue(self.target.delegate === self.mockDelegate)
    }
}

class LaunchScreenViewModel_when_logInOutButtonTapped: LaunchScreenViewModel_Test {
    var mockDelegate: MockLaunchScreenViewModelDelegate!
    var userServiceLogOutCallCount: Int = 0
    var launchScreenViewModelDidLaunchLogInCallCount: Int = 0
    
    override func setUp() {
        super.setUp()
        
        self.mockUserService.logOutTestClosure = {
            self.userServiceLogOutCallCount = self.userServiceLogOutCallCount + 1
        }
        
        self.mockDelegate = MockLaunchScreenViewModelDelegate()
        self.mockDelegate.launchScreenViewModelDidLaunchLogInTestClosure = {
            self.launchScreenViewModelDidLaunchLogInCallCount = self.launchScreenViewModelDidLaunchLogInCallCount + 1
        }
        
        let _ = self.target
            .setup(delegate: self.mockDelegate)
    }
    
    func test_and_userService_isLoggedIn_is_false_then_delegate_launchScreenViewModelDidLaunchLogIn_is_called_once() {
        self.mockUserService.isLoggedInMockValue.accept(false)
        self.target.logInOutButtonTapped.accept(())
        XCTAssert(self.launchScreenViewModelDidLaunchLogInCallCount == 1)
        XCTAssert(self.userServiceLogOutCallCount == 0)
    }
    
    func test_and_userService_isLoggedIn_is_true_then_userService_called_logout_once() {
        self.mockUserService.isLoggedInMockValue.accept(true)
        self.target.logInOutButtonTapped.accept(())
        XCTAssert(self.launchScreenViewModelDidLaunchLogInCallCount == 0)
        XCTAssert(self.userServiceLogOutCallCount == 1)
    }
}

class LaunchScreenViewModel_when_logUserOut_is_called: LaunchScreenViewModel_Test {
    var userServiceLogOutCallCount: Int = 0
    
    override func setUp() {
        super.setUp()
        
        self.mockUserService.logOutTestClosure = {
            self.userServiceLogOutCallCount = self.userServiceLogOutCallCount + 1
        }
        
        self.target.logUserOut()
    }
    
    func test_then_userService_called_logout_once() {
        XCTAssert(self.userServiceLogOutCallCount == 1)
    }
}

class LaunchScreenViewModel_when_getNextColor_is_called: LaunchScreenViewModel_Test {
    var getNextColorCallCount: Int = 0
    
    override func setUp() {
        super.setUp()
        
        self.mockPartyService.getNextColorTestClosure = {
            self.getNextColorCallCount = self.getNextColorCallCount + 1
        }
        
        let _ = self.target.getNextColor()
    }
    
    func test_then_partyService_called_getNextColor_once() {
        XCTAssert(self.getNextColorCallCount == 1)
    }
}

class LaunchScreenViewModel_when_launchLogIn_is_called: LaunchScreenViewModel_Test {
    var mockDelegate: MockLaunchScreenViewModelDelegate!
    var launchScreenViewModelDidLaunchLogInCallCount: Int = 0
    
    override func setUp() {
        super.setUp()
        
        self.mockDelegate = MockLaunchScreenViewModelDelegate()
        self.mockDelegate.launchScreenViewModelDidLaunchLogInTestClosure = {
            self.launchScreenViewModelDidLaunchLogInCallCount = self.launchScreenViewModelDidLaunchLogInCallCount + 1
        }
        
        self.target
            .setup(delegate: self.mockDelegate)
            .launchLogIn()
    }
    
    func test_then_delegate_launchScreenViewModelDidLaunchLogIn_is_called_once() {
        XCTAssert(self.launchScreenViewModelDidLaunchLogInCallCount == 1)
    }
}

class LaunchScreenViewModel_when_launchParty_is_called: LaunchScreenViewModel_Test {
    var mockDelegate: MockLaunchScreenViewModelDelegate!
    var launchScreenViewModelDidLaunchPartyCallCount: Int = 0
    
    override func setUp() {
        super.setUp()
        
        self.mockDelegate = MockLaunchScreenViewModelDelegate()
        self.mockDelegate.launchScreenViewModelDidLaunchPartyTestClosure = {
            self.launchScreenViewModelDidLaunchPartyCallCount = self.launchScreenViewModelDidLaunchPartyCallCount + 1
        }
        
        self.target
            .setup(delegate: self.mockDelegate)
            .launchParty.accept(())
    }
    
    func test_then_delegate_launchScreenViewModelDidLaunchLogIn_is_called_once() {
        XCTAssert(self.launchScreenViewModelDidLaunchPartyCallCount == 1)
    }
}
