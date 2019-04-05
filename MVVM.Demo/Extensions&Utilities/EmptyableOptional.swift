//
//  EmptyableOptional.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 2/6/19.
//  Copyright © 2019 Jason Lew-Rapai. All rights reserved.
//

import Foundation

protocol EmptyableOptional {
    var isEmpty: Bool { get }
}

extension Array: EmptyableOptional { }
extension Dictionary: EmptyableOptional { }
extension Set: EmptyableOptional { }
extension String: EmptyableOptional { }

extension Optional where Wrapped: EmptyableOptional {
    var isNilOrEmpty: Bool {
        switch self {
        case let.some(value):
            return value.isEmpty
        case .none:
            return true
        }
    }
}
