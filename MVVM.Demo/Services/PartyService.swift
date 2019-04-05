//
//  PartyService.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/20/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit

protocol PartyServiceProtocol {
    func getNextColor() -> UIColor
    func getRandomEmoji() -> String
}

class PartyService: PartyServiceProtocol {
    private var colorIndex: Int = 0
    
    func getNextColor() -> UIColor {
        if self.colorIndex > 5 {
            self.colorIndex = 0
        }
        var color: UIColor
        switch self.colorIndex {
        case 0: color = UIColor.red
        case 1: color = UIColor.orange
        case 2: color = UIColor.yellow
        case 3: color = UIColor.green
        case 4: color = UIColor.blue
        case 5: color = UIColor.purple
        default: color = UIColor.black
        }
        self.colorIndex = self.colorIndex + 1
        return color
    }
    
    func getRandomEmoji() -> String {
        let emojiIndex = arc4random_uniform(10)
        switch emojiIndex {
        case 0: return "😀"
        case 1: return "🤣"
        case 2: return "🤪"
        case 3: return "🧐"
        case 4: return "😎"
        case 5: return "😏"
        case 6: return "😤"
        case 7: return "🤯"
        case 8: return "😳"
        case 9: return "🤮"
        default: return "🤔"
        }
    }
}
