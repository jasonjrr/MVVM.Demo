//
//  AppAssembly.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import Foundation
import Swinject

class AppAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: Coordinators
        container.register(MainCoordinator.self) { r in
            return MainCoordinator(resolver: r)
        }.inObjectScope(.container)
        
        // MARK: Services
        container.register(NavigationControllerTransitionManager.self) { r in
            return NavigationControllerTransitionManager()
        }.inObjectScope(.container)
        
        container.register(PartyServiceProtocol.self) { r in
            return PartyService()
        }.inObjectScope(.transient)
        
        container.register(UserServiceProtocol.self) { r in
            return UserService()
        }.inObjectScope(.container)
        
        // MARK: ViewModels
        container.register(LaunchScreenViewModel.self) { r in
            return LaunchScreenViewModel(
                userService: r.resolve(UserServiceProtocol.self)!,
                partyService: r.resolve(PartyServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(LoginViewModel.self) { r in
            return LoginViewModel(
                userService: r.resolve(UserServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(PartyViewModel.self) { r in
            return PartyViewModel(
                userService: r.resolve(UserServiceProtocol.self)!,
                partyService: r.resolve(PartyServiceProtocol.self)!)
        }.inObjectScope(.transient)
    }
}
