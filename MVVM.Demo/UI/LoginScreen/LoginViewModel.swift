//
//  LoginViewModel.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    private let userService: UserServiceProtocol
    private var completion: (() -> Void)?
    let disposeBag: DisposeBag = DisposeBag()

    // Inputs
    
    let userName: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    let submitLogInCredentials: PublishRelay<Void> = PublishRelay()
    let didLogLogIn: PublishRelay<Void> = PublishRelay()
    
    // Outputs
    
    let canLogIn: Driver<Bool>
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        
        self.canLogIn = Observable.combineLatest(
            self.userName.asObservable(),
            self.password.asObservable()) { (userName, password) in
                guard let userName = userName, let password = password else { return false }
                return userName.count > 0 && password.count > 0
            }
            .asDriver(onErrorJustReturn: false)
        
        let credentials = Observable.combineLatest(
            self.userName,
            self.password)
        
        self.submitLogInCredentials
            .withLatestFrom(credentials)
            .subscribe(onNext: { [weak self] userName, password in
                guard let userName = userName, let password = password else { return }
                self?.userService.logIn(userName: userName, password: password)
            })
            .disposed(by: self.disposeBag)
        
        self.didLogLogIn
            .withLatestFrom(self.userService.isLoggedIn.asObservable())
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.completion?()
            })
            .disposed(by: self.disposeBag)
    }
    
    func setup(completion: (() -> Void)?) -> Self {
        self.completion = completion
        return self
    }
}
