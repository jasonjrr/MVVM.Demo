//
//  Coordinator.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var rootNavigationController: UINavigationController! { get }
    @discardableResult func start() -> UINavigationController
}
