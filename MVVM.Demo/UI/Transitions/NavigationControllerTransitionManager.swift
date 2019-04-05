//
//  NavigationControllerTransitionManager.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

class NavigationControllerTransitionManager: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return getAnimationControllerForPush(navigationController, from: fromVC, to: toVC)
        case .pop:
            return getAnimationControllerForPop(navigationController, from: fromVC, to: toVC)
        case .none:
            return nil
        @unknown default:
            fatalError("Please support all cases.")
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    private func getAnimationControllerForPush(_ navigationController: UINavigationController, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionManager: TransitionManager? = toVC.getTransitionManager()
        transitionManager?.isPresenting = true
        return transitionManager
    }
    
    private func getAnimationControllerForPop(_ navigationController: UINavigationController, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitionManager: TransitionManager? = fromVC.getTransitionManager()
        transitionManager?.isPresenting = false
        return transitionManager
    }
}
