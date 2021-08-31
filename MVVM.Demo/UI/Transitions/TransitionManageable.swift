//
//  TransitionManageable.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

protocol TransitionManageable: AnyObject {
    var transitionManager: TransitionManager? { get }
}

extension UIViewController {
    func getTransitionManager() -> TransitionManager? {
        return (self as? TransitionManageable)?.transitionManager
    }
}
