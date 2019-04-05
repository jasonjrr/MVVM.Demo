//
//  PartyViewModel.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/20/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PartyViewModel {
    private let userService: UserServiceProtocol
    private let partyService: PartyServiceProtocol
    
    var title: Driver<String> {
        return self.userService.userName
            .asObservable()
            .asDriver(onErrorJustReturn: nil)
            .map { userName -> String in
                if let userName = userName {
                    return "Party on, \(userName)!"
                }
                return "Welcome, mysterious stranger"
            }
    }
    
    init(userService: UserServiceProtocol, partyService: PartyServiceProtocol) {
        self.userService = userService
        self.partyService = partyService
    }
    
    func getNextColor() -> UIColor {
        return self.partyService.getNextColor()
    }
    
    func getRandomEmoji() -> String {
        return self.partyService.getRandomEmoji()
    }
}
