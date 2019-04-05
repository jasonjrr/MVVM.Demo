//
//  TransitionSpeed.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

enum TransitionSpeed {
    case `default`
    case fullScreen
    case dialogSmall
    case dialogMedium
    case dialogLarge
    
    var presentDuration: TimeInterval {
        switch self {
        case .default: return 0.3
        case .fullScreen: return 0.375
        case .dialogSmall: return 0.24
        case .dialogMedium: return 0.3
        case .dialogLarge: return 0.35
        }
    }
    
    var dismissDuration: TimeInterval {
        switch self {
        case .default: return 0.24
        case .fullScreen: return 0.34
        case .dialogSmall: return 0.16
        case .dialogMedium: return 0.2
        case .dialogLarge: return 0.24
        }
    }
}
