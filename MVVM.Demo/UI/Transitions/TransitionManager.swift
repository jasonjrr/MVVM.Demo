//
//  TransitionManager.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var transitionDuration: TransitionSpeed!
    var isPresenting: Bool = false
    
    func beforeViewDidLoad(transitionDuration: TransitionSpeed = .default) {
        self.transitionDuration = transitionDuration
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isPresenting {
            present(transitionContext: transitionContext)
        } else {
            dismiss(transitionContext: transitionContext)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.isPresenting
            ? self.transitionDuration.presentDuration
            : self.transitionDuration.dismissDuration
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
    
    // MARK: Other
    func present(transitionContext: UIViewControllerContextTransitioning) {}
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {}
}
