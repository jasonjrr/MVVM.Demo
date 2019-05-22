//
//  LaunchScreenViewModel.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LaunchScreenViewModelDelegate: class {
  func launchScreenViewModelDidLaunchLogIn(_ source: LaunchScreenViewModel)
  func launchScreenViewModelDidLaunchParty(_ source: LaunchScreenViewModel)
}

class LaunchScreenViewModel {
  private let userService: UserServiceProtocol
  private let partyService: PartyServiceProtocol
  private let disposeBag: DisposeBag = DisposeBag()
  
  private(set) weak var delegate: LaunchScreenViewModelDelegate?
  
  // Inputs
  let logInOutButtonTapped: PublishRelay<Void>! = PublishRelay()
  let launchParty: PublishRelay<Void>! = PublishRelay()
  
  // Outputs
  
  let logInButtonText: Driver<String>
  
  init(userService: UserServiceProtocol, partyService: PartyServiceProtocol) {
    self.userService = userService
    self.partyService = partyService
    
    let userName: Observable<String> = self.userService.userName.asObservable()
      .map { $0 ?? String.empty }
    
    self.logInButtonText = Observable.combineLatest(
      userName,
      self.userService.isLoggedIn.asObservable())
      .map { userName, isLoggedIn in
        return isLoggedIn
          ? "Faux Log Out \(userName)"
          : "Faux Login"
      }
      .asDriver(onErrorJustReturn: String.empty)
    
    self.logInOutButtonTapped
      .withLatestFrom(self.userService.isLoggedIn.asObservable())
      .subscribe(onNext: { [weak self] isLoggedIn in
        if isLoggedIn {
          self?.logUserOut()
        } else {
          self?.launchLogIn()
        }
      })
      .disposed(by: self.disposeBag)
    
    self.launchParty
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.delegate?.launchScreenViewModelDidLaunchParty(self)
      })
      .disposed(by: self.disposeBag)
  }
  
  func setup(delegate: LaunchScreenViewModelDelegate?) -> Self {
    self.delegate = delegate
    return self
  }
  
  func logUserOut() {
    self.userService.logOut()
  }
  
  func getNextColor() -> UIColor {
    return self.partyService.getNextColor()
  }
  
  func launchLogIn() {
    self.delegate?.launchScreenViewModelDidLaunchLogIn(self)
  }
}
