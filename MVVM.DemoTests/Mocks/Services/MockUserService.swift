//
//  MockUserService.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import Foundation
import XCTest
@testable import MVVM_Demo
import RxSwift
import RxCocoa

class MockUserService: UserServiceProtocol {
    let userNameMockValue: BehaviorRelay<String?>
    let userName: ReadOnlyBehaviorRelay<String?>
    
    let isLoggedInMockValue: BehaviorRelay<Bool>
    let isLoggedIn: ReadOnlyBehaviorRelay<Bool>
    
    init(isLoggedIn: Bool) {
        let userName: String? = isLoggedIn ? "MockUserName" : nil
        
        self.userNameMockValue = BehaviorRelay(value: userName)
        self.isLoggedInMockValue = BehaviorRelay(value: isLoggedIn)
        
        self.userName = ReadOnlyBehaviorRelay(self.userNameMockValue)
        self.isLoggedIn = ReadOnlyBehaviorRelay(self.isLoggedInMockValue)
    }
    
    var logInTestClosure: ((_ userName: String, _ password: String) -> Void)?
    func logIn(userName: String, password: String) {
        self.logInTestClosure?(userName, password)
    }
    
    var logOutTestClosure: (() -> Void)?
    func logOut() {
        self.logOutTestClosure?()
    }
}
