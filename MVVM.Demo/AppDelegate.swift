//
//  AppDelegate.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var assembler: Assembler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.assembler = Assembler.init([
            AppAssembly(),
        ])
        
        self.window?.rootViewController = self.assembler.resolver
            .resolve(MainCoordinator.self)!
            .start()
        
        return true
    }
}
