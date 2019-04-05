//
//  DropInTransitionManager.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/20/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

class DropInTransitionManager: TransitionManager {
    func beforeViewDidLoad(sourceViewController: UIViewController, transitionDuration: TransitionSpeed) {
        super.beforeViewDidLoad(transitionDuration: transitionDuration)
        sourceViewController.transitioningDelegate = self
    }
    
    override func present(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: toViewController.view.frame.height * -1)
        toViewController.view.alpha = 0.0
        container.addSubview(toViewController.view)
        
        UIView.animate(
            withCustomEasing: .decelerationCurve,
            duration: duration, delay: 0.0,
            animations: {
                toViewController.view.transform = .identity
                toViewController.view.alpha = 1.0
            },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
    
    override func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        let offScreenTop: CGAffineTransform = CGAffineTransform(translationX: 0, y: fromViewController.view.frame.height * -1)
        
        container.addSubview(toViewController.view)
        container.addSubview(fromViewController.view)
        
        UIView.animate(
            withCustomEasing: .accelerationCurve,
            duration: duration, delay: 0.0,
            animations: {
                fromViewController.view.transform = offScreenTop
                fromViewController.view.alpha = 0.0
            },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
}
