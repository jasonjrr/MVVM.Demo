//
//  UIView+ShadowDepth.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/20/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

extension UIView {
    class var defaultShadowOpacity: Float {
        return 0.24
    }
    
    class var defaultShadowColor: UIColor {
        return UIColor.black
    }
    
    func applyShadow(horizontalOffset: CGFloat, verticalOffset: CGFloat, opacity: Float, radius: CGFloat, color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(
            width: horizontalOffset,
            height: verticalOffset < 1 ? 1 : verticalOffset)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func applyShadow(horizontalOffset: CGFloat, verticalOffset: CGFloat, opacity: Float, radius: CGFloat) {
        applyShadow(horizontalOffset: horizontalOffset, verticalOffset: verticalOffset, opacity: opacity, radius: radius, color: UIView.defaultShadowColor)
    }
    
    func hideShadow() {
        self.layer.shadowOpacity = 0.0
    }
    
    func applyShadowDown(withDepth depth: Int) {
        applyShadowDown(withDepth: depth, opacity: UIView.defaultShadowOpacity)
    }
    
    func applyShadowDown(withDepth depth: Int, opacity: Float) {
        let opacity: Float = opacity + (Float(depth) / 100)
        switch depth {
        case 0:
            hideShadow()
        case 1:
            applyShadow(horizontalOffset: 0, verticalOffset: 1, opacity: opacity, radius: 1)
        case 2:
            applyShadow(horizontalOffset: 0, verticalOffset: 2, opacity: opacity, radius: 1)
        case 3:
            applyShadow(horizontalOffset: 0, verticalOffset: 2, opacity: opacity, radius: 2)
        case 4:
            applyShadow(horizontalOffset: 0, verticalOffset: 3, opacity: opacity, radius: 2)
        case 5:
            applyShadow(horizontalOffset: 0, verticalOffset: 3, opacity: opacity, radius: 3)
        case 6:
            applyShadow(horizontalOffset: 0, verticalOffset: 4, opacity: opacity, radius: 3)
        case 7:
            applyShadow(horizontalOffset: 0, verticalOffset: 4, opacity: opacity, radius: 4)
        case 8:
            applyShadow(horizontalOffset: 0, verticalOffset: 5, opacity: opacity, radius: 4)
        case 9:
            applyShadow(horizontalOffset: 0, verticalOffset: 5, opacity: opacity, radius: 5)
        case 10:
            applyShadow(horizontalOffset: 0, verticalOffset: 6, opacity: opacity, radius: 5)
        case 11:
            applyShadow(horizontalOffset: 0, verticalOffset: 7, opacity: opacity, radius: 5)
        case 12:
            applyShadow(horizontalOffset: 0, verticalOffset: 8, opacity: opacity, radius: 5)
        case 13:
            applyShadow(horizontalOffset: 0, verticalOffset: 8, opacity: opacity, radius: 6)
        case 14:
            applyShadow(horizontalOffset: 0, verticalOffset: 9, opacity: opacity, radius: 6)
        case 15:
            applyShadow(horizontalOffset: 0, verticalOffset: 10, opacity: opacity, radius: 6)
        case 16:
            applyShadow(horizontalOffset: 0, verticalOffset: 10, opacity: opacity, radius: 7)
        case 17:
            applyShadow(horizontalOffset: 0, verticalOffset: 10, opacity: opacity, radius: 8)
        default:
            applyShadow(horizontalOffset: 0, verticalOffset: CGFloat(depth), opacity: opacity, radius: CGFloat(depth))
        }
    }
}
