//
//  LoginViewModel+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

class LoginViewModel_Test: XCTestCase {
    var mockUserService: MockUserService!
    var target: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.mockUserService = getMockUserService()
        
        self.target = LoginViewModel(userService: self.mockUserService)
    }
    
    func getMockUserService() -> MockUserService {
        return MockUserService(isLoggedIn: false)
    }
}

class LoginViewModel_when_initialized: LoginViewModel_Test {
    func test_userName_is_nil() {
        XCTAssertNil(self.target.userName.value)
    }
    
    func test_password_is_nil() {
        XCTAssertNil(self.target.password.value)
    }
    
    func test_canLogIn_is_false() throws {
        XCTAssertEqual(try self.target.canLogIn.toBlocking().first(), false)
    }
}

class LoginViewModel_when_setup_is_called_and_user_is_not_logged_in: LoginViewModel_Test {
    var completionCount: Int = 0
    var expectedCompletion: (() -> Void)?
    
    override func setUp() {
        super.setUp()
        self.expectedCompletion = { self.completionCount = self.completionCount + 1 }
        self.target
            .setup(completion: self.expectedCompletion)
            .didLogLogIn.accept(())
    }
    
    override func getMockUserService() -> MockUserService {
        return MockUserService(isLoggedIn: true)
    }
    
    func test_then_when_didLogIn_is_fired_completion_is_not_called() {
        XCTAssertEqual(self.completionCount, 1)
    }
}

class LoginViewModel_when_setup_is_called_and_user_is_logged_in: LoginViewModel_Test {
    var completionCount: Int = 0
    var expectedCompletion: (() -> Void)?
    
    override func setUp() {
        super.setUp()
        self.expectedCompletion = { self.completionCount = self.completionCount + 1 }
        self.target
            .setup(completion: self.expectedCompletion)
            .didLogLogIn.accept(())
    }
    
    func test_then_when_didLogIn_is_fired_completion_is_not_called() {
        XCTAssertEqual(self.completionCount, 0)
    }
}

class LoginViewModel_when_userName_is_valid_and_no_password_is_entered: LoginViewModel_Test {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        super.setUp()
        
        self.scheduler
            .createColdObservable([.next(1, "TestUserName")])
            .bind(to: self.target.userName)
            .disposed(by: self.disposeBag)
    }
    
    func test_then_canLogIn_is_false() throws {
        let canLogIn = scheduler.createObserver(Bool.self)
        
        self.target.canLogIn
            .drive(canLogIn)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(canLogIn.events, [
            .next(0, false), // init
            .next(1, false),
        ])
    }
}

class LoginViewModel_when_no_userName_is_entered_and_password_is_valid: LoginViewModel_Test {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        super.setUp()
        
        self.scheduler
            .createColdObservable([.next(1, "TestPassword")])
            .bind(to: self.target.password)
            .disposed(by: self.disposeBag)
    }
    
    func test_then_canLogIn_is_false() throws {
        let canLogIn = scheduler.createObserver(Bool.self)
        
        self.target.canLogIn
            .drive(canLogIn)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(canLogIn.events, [
            .next(0, false), // init
            .next(1, false),
        ])
    }
}

class LoginViewModel_when_userName_is_valid_and_password_is_valid: LoginViewModel_Test {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        
        super.setUp()
        
        self.scheduler
            .createColdObservable([.next(1, "TestUserName")])
            .bind(to: self.target.userName)
            .disposed(by: self.disposeBag)
        
        self.scheduler
            .createColdObservable([.next(2, "TestPassword")])
            .bind(to: self.target.password)
            .disposed(by: self.disposeBag)
    }
    
    func test_then_canLogIn_is_false() throws {
        let canLogIn = scheduler.createObserver(Bool.self)
        
        self.target.canLogIn
            .drive(canLogIn)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(canLogIn.events, [
            .next(0, false), // init
            .next(1, false),
            .next(2, true),
        ])
    }
}

// MARK: submitLoginInformation

// Base
class LoginViewModel_Test_submitLoginInformation: LoginViewModel_Test {
    var logInCallCount: Int = 0
    
    override func setUp() {
        super.setUp()

        self.mockUserService.logInTestClosure = logInValidation
    }
    
    func logInValidation(userName: String, password: String) {
        self.logInCallCount = self.logInCallCount + 1
    }
}

class LoginViewModel_when_submitLoginInformation_is_called_and_userName_and_password_are_invalid: LoginViewModel_Test_submitLoginInformation {
    override func setUp() {
        super.setUp()
        
        self.target.submitLogInCredentials.accept(())
    }
    
    func test_then_userService_logIn_is_not_called() {
        XCTAssertEqual(self.logInCallCount, 0)
    }
}

class LoginViewModel_when_submitLoginInformation_is_called_and_only_userName_is_valid: LoginViewModel_Test_submitLoginInformation {
    override func setUp() {
        super.setUp()
        self.target.userName.accept("TestUserName")
        
        self.target.submitLogInCredentials.accept(())
    }
    
    func test_then_userService_logIn_is_not_called() {
        XCTAssertEqual(self.logInCallCount, 0)
    }
}

class LoginViewModel_when_submitLoginInformation_is_called_and_only_password_is_valid: LoginViewModel_Test_submitLoginInformation {
    override func setUp() {
        super.setUp()
        self.target.password.accept("TestPassword")
        
        self.target.submitLogInCredentials.accept(())
    }
    
    func test_then_userService_logIn_is_not_called() {
        XCTAssertEqual(self.logInCallCount, 0)
    }
}

class LoginViewModel_when_submitLoginInformation_is_called_and_userName_and_password_are_valid: LoginViewModel_Test_submitLoginInformation {
    
    var actualUserName: String?
    var actualPassword: String?
    
    override func setUp() {
        super.setUp()
        self.target.userName.accept("TestUserName")
        self.target.password.accept("TestPassword")
        
        self.target.submitLogInCredentials.accept(())
    }
    
    override func logInValidation(userName: String, password: String) {
        super.logInValidation(userName: userName, password: password)
        self.actualUserName = userName
        self.actualPassword = password
    }
    
    func test_then_userService_logIn_is_called_once() {
        XCTAssertEqual(self.logInCallCount, 1)
    }
    
    func test_then_actual_userName_equals_expected_userName() {
        XCTAssertEqual(self.actualUserName, self.target.userName.value)
    }
    
    func test_then_actual_password_equals_expected_password() {
        XCTAssertEqual(self.actualPassword, self.target.password.value)
    }
}
