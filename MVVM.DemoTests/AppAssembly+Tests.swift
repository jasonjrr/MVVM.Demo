//
//  AppAssembly+Tests.swift
//  MVVM.DemoTests
//
//  Created by Jason Lew-Rapai on 2/7/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import XCTest
@testable import MVVM_Demo
import Swinject

class AppAssemblyTests: XCTestCase {
    var testAssembler: Assembler!
    var target: AppAssembly!
    
    var testResolver: Resolver { return self.testAssembler.resolver }
    
    override func setUp() {
        super.setUp()
        
        self.target = AppAssembly()
        
        self.testAssembler = Assembler([self.target])
    }
    
    func test_MainCoordinator_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(MainCoordinator.self))
    }
    
    func test_NavigationControllerTransitionManager_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(NavigationControllerTransitionManager.self))
    }
    
    func test_PartyServiceProtocol_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(PartyServiceProtocol.self))
    }
    
    func test_UserServiceProtocol_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(UserServiceProtocol.self))
    }
    
    func test_LaunchScreenViewModel_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(LaunchScreenViewModel.self))
    }
    
    func test_LoginViewModel_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(LoginViewModel.self))
    }
    
    func test_PartyViewModel_is_registered() {
        XCTAssertNotNil(self.testResolver.resolve(PartyViewModel.self))
    }
}
