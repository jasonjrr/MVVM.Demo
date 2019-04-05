//
//  MainCoordinator.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import Swinject

class MainCoordinator: Coordinator {
    private let resolver: Resolver
    private let navigationControllerTransitionManager: NavigationControllerTransitionManager
    var rootNavigationController: UINavigationController!
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.navigationControllerTransitionManager = resolver.resolve(NavigationControllerTransitionManager.self)!
    }
    
    func start() -> UINavigationController {
        if self.rootNavigationController == nil {
            self.rootNavigationController = UINavigationController()
            self.rootNavigationController.navigationBar.isTranslucent = true
            self.rootNavigationController.delegate = self.navigationControllerTransitionManager
        }
        
        let viewModel: LaunchScreenViewModel = self.resolver.resolve(LaunchScreenViewModel.self)!
            .setup(delegate: self)
        let viewController: LaunchScreenViewController = LaunchScreenViewController.instantiate(
            viewModel: viewModel)
        self.rootNavigationController.viewControllers = [viewController]
        
        return self.rootNavigationController
    }
    
    private func launchParty() {
        let viewController: PartyViewController = PartyViewController.instantiate(
            viewModel: self.resolver.resolve(PartyViewModel.self)!)
        self.rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: LaunchScreenViewModelDelegate {
    func launchScreenViewModelDidLaunchLogIn(_ source: LaunchScreenViewModel) {
        let viewController: LoginViewController = LoginViewController.instantiate(
            viewModel: self.resolver.resolve(LoginViewModel.self)!
                .setup(completion: userDidLogIn))
        self.rootNavigationController.present(viewController, animated: true, completion: nil)
    }
    
    func launchScreenViewModelDidLaunchParty(_ source: LaunchScreenViewModel) {
        self.launchParty()
    }
    
    private func userDidLogIn() {
        let userService: UserServiceProtocol = self.resolver.resolve(UserServiceProtocol.self)!
        if userService.isLoggedIn.value {
            print("Logged In!")
            self.launchParty()
        } else {
            print("You broke this somehow...")
        }
    }
}
