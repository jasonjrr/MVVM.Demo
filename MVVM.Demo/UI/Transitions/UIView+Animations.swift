//
//  UIView+Animations.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

/**
 Custom Easings
 
 Duration & easing
 https://material.io/guidelines/motion/duration-easing.html
 
 Movement
 https://material.io/guidelines/motion/movement.html#
 
 - standardCurve: The standard curve (also referred to as “ease in out”) is the most common easing curve. Elements quickly accelerate and slowly decelerate between on-screen locations. It applies to growing and shrinking material, among other property changes.
 
 - decelerationCurve: Using the deceleration curve (also referred to as “ease out”) elements enter the screen at full velocity and slowly decelerate to a resting point. During deceleration, elements may scale up either in size (to 100%) or opacity (to 100%). In some cases, when elements enter the screen at 0% opacity, they may slightly shrink from a larger size upon entry.
 
 - accelerationCurve: Using the acceleration curve (also referred to as “ease in”) elements leave the screen at full velocity. They do not decelerate when off-screen. They accelerate at the beginning of the animation and may scale down in either size (to 0%) or opacity (to 0%). In some cases, when elements leave the screen at 0% opacity, they may also slightly scale up or down in size.
 
 - sharpCurve: Using the sharp curve (also referred to as “ease in out”) elements quickly accelerate and decelerate. It is used by exiting elements that may return to the screen at any time. Elements may quickly accelerate from a starting point on-screen, then quickly decelerate in a symmetrical curve to a resting point immediately off-screen. The deceleration is faster than the standard curve since it doesn't follow an exact path to the off-screen point. Elements may return from that point at any time.
 */
enum CustomEasing {
    case standardCurve
    case decelerationCurve
    case accelerationCurve
    case sharpCurve
    
    var timingFunction: CAMediaTimingFunction {
        switch self {
        case .standardCurve:
            return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        case .decelerationCurve:
            return CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.2, 1.0)
        case .accelerationCurve:
            return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 1.0, 1.0)
        case .sharpCurve:
            return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.6, 1.0)
        }
    }
}

extension UIView {
    class func animate(withCustomEasing customEasing: CustomEasing, duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(customEasing.timingFunction)
        
        UIView.animate(withDuration: duration, delay: delay, animations: animations, completion: completion)
        
        CATransaction.commit()
    }
    
    class func animateKeyframes(withCustomEasing customEasing: CustomEasing, duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(customEasing.timingFunction)
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: animations, completion: completion)
        
        CATransaction.commit()
    }
}
