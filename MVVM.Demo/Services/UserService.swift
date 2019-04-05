//
//  UserService.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol UserServiceProtocol {
    var userName: ReadOnlyBehaviorRelay<String?> { get }
    var isLoggedIn: ReadOnlyBehaviorRelay<Bool> { get }
    
    func logIn(userName: String, password: String)
    func logOut()
}

class UserService: UserServiceProtocol {
    private let _userName: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let userName: ReadOnlyBehaviorRelay<String?>
    
    private let _isLoggedIn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isLoggedIn: ReadOnlyBehaviorRelay<Bool>
    
    private let disposeBag: DisposeBag
    
    init() {
        self.userName = ReadOnlyBehaviorRelay(self._userName)
        self.isLoggedIn = ReadOnlyBehaviorRelay(self._isLoggedIn)
        
        self.disposeBag = DisposeBag()
        
        self._userName
            .map { userName in
                return !userName.isNilOrEmpty
            }
            .subscribe(onNext: self._isLoggedIn.accept)
            .disposed(by: self.disposeBag)
    }
    
    func logIn(userName: String, password: String) {
        self._userName.accept(userName)
    }
    
    func logOut() {
        self._userName.accept(nil)
    }
}
