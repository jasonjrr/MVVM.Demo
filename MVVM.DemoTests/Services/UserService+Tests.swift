//
//  UserService+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo

class UserService_Test: XCTestCase {
    var target: UserService!
    
    override func setUp() {
        super.setUp()
        
        self.target = UserService()
    }
}

class UserService_when_initialized: UserService_Test {
    func test_userName_is_nil() {
        XCTAssertNil(self.target.userName.value)
    }
    
    func test_isLoggedIn_is_false() {
        XCTAssertFalse(self.target.isLoggedIn.value)
    }
}

class UserService_when_logIn_is_called: UserService_Test {
    var expectedUserName: String = "TestUserName"
    
    override func setUp() {
        super.setUp()
        
        self.target.logIn(userName: self.expectedUserName, password: "TestPassword")
    }
    
    func test_userName_is_equal_to_expected_userName() {
        XCTAssertEqual(self.target.userName.value, self.expectedUserName)
    }
    
    func test_isLoggedIn_is_true() {
        XCTAssertTrue(self.target.isLoggedIn.value)
    }
}

class UserService_when_logOut_is_called: UserService_Test {
    var expectedUserName: String = "TestUserName"
    
    override func setUp() {
        super.setUp()
        
        self.target.logIn(userName: self.expectedUserName, password: "TestPassword")
        
        self.target.logOut()
    }
    
    func test_userName_is_nil() {
        XCTAssertNil(self.target.userName.value)
    }
    
    func test_isLoggedIn_is_false() {
        XCTAssertFalse(self.target.isLoggedIn.value)
    }
}
