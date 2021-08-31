
//
//  DialogTransitionManager.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

protocol DialogTransitionTarget: AnyObject {
    var view: UIView! { get }
    var dialogCard: UIView { get }
    
    var transitioningDelegate: UIViewControllerTransitioningDelegate? { get set }
    var modalPresentationStyle: UIModalPresentationStyle { get set }
    
    func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}

class DialogTransitionManager: TransitionManager {
    func beforeViewDidLoad(target: DialogTransitionTarget, transitionDuration: TransitionSpeed = .dialogSmall) {
        super.beforeViewDidLoad(transitionDuration: transitionDuration)
        target.transitioningDelegate = self
        target.modalPresentationStyle = .overFullScreen
    }
    
    override func present(transitionContext: UIViewControllerContextTransitioning) {
        let container: UIView = transitionContext.containerView
        let dialogTarget: DialogTransitionTarget = transitionContext.viewController(forKey: .to) as! DialogTransitionTarget
        
        dialogTarget.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        dialogTarget.dialogCard.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        
        container.addSubview(dialogTarget.view)
        
        UIView.animateKeyframes(
            withCustomEasing: .decelerationCurve,
            duration: duration, delay: 0,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/3) {
                    dialogTarget.view.backgroundColor = UIColor.black.withAlphaComponent(0.24)
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    dialogTarget.dialogCard.transform = .identity
                }
        },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    override func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        let dialogTarget: DialogTransitionTarget = transitionContext.viewController(forKey: .from) as! DialogTransitionTarget
        
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withCustomEasing: .accelerationCurve,
            duration: duration, delay: 0,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    dialogTarget.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                    dialogTarget.dialogCard.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }
        },
            completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
