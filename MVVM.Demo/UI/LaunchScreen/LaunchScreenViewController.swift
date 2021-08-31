//
//  LaunchScreenViewController.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LaunchScreenViewController: UIViewController {
  let stackView: UIStackView = UIStackView()
  let loginButton: UIButton = UIButton()
  let partyButton: UIButton = UIButton()
  
  private let viewModel: LaunchScreenViewModel
  private var disposeBag: DisposeBag!
  
//  class func instantiate(viewModel: LaunchScreenViewModel) -> LaunchScreenViewController {
//    let viewController: LaunchScreenViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreenViewController") as! LaunchScreenViewController
//    viewController.viewModel = viewModel
//    return viewController
//  }
  
  init(viewModel: LaunchScreenViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Welcome to the DEMO"
    
    self.view.backgroundColor = .systemBackground
    self.view.addSubview(self.stackView)
    
    self.stackView.axis = .vertical
    self.stackView.spacing = 16.0
    self.stackView.snp.makeConstraints { make in
      make.leading.top.greaterThanOrEqualTo(24.0)
      make.trailing.bottom.lessThanOrEqualTo(-24.0)
      make.width.equalTo(160.0)
      make.centerWithinMargins.equalTo(self.view.snp.centerWithinMargins)
    }
    
    self.stackView.addArrangedSubview(self.loginButton)
    self.stackView.addArrangedSubview(self.partyButton)
    
    self.loginButton.backgroundColor = UIColor.white
    self.loginButton.titleLabel?.numberOfLines = 0
    self.loginButton.layer.borderColor = UIColor.orange.cgColor
    self.loginButton.layer.borderWidth = 2
    self.loginButton.layer.cornerRadius = 4
    self.loginButton.setTitleColor(UIColor.orange, for: UIControl.State())
    self.loginButton.setTitle("Faux Login", for: UIControl.State())
    self.loginButton.snp.makeConstraints { make in
      make.height.equalTo(64.0)
    }
    
    self.partyButton.backgroundColor = UIColor.white
    self.partyButton.layer.borderColor = UIColor.red.cgColor
    self.partyButton.layer.borderWidth = 2
    self.partyButton.layer.cornerRadius = 4
    self.partyButton.setTitleColor(UIColor.red, for: UIControl.State())
    self.partyButton.setTitle("Just Party", for: UIControl.State())
    self.partyButton.snp.makeConstraints { make in
      make.height.equalTo(64.0)
    }
    
    self.disposeBag = DisposeBag()
    bindViewModel()
    bindComponents()
  }
  
  private func bindViewModel() {
    self.viewModel.logInButtonText
      .drive(self.loginButton.rx.title())
      .disposed(by: self.disposeBag)
  }
  
  private func bindComponents() {
    self.loginButton.rx.tap
      .bind(to: self.viewModel.logInOutButtonTapped)
      .disposed(by: self.disposeBag)
    
    self.partyButton.rx.tap
      .bind(to: self.viewModel.launchParty)
      .disposed(by: self.disposeBag)
    
    Observable<Int>
      .interval(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
      .map { [weak self] _ in self?.viewModel.getNextColor() }
      .bind { [weak self] color in
        guard let this = self else { return }
        UIView.transition(
          with: this.partyButton, duration: 0.2,
          options: [.curveEaseInOut, .transitionCrossDissolve],
          animations: {
            this.partyButton.layer.borderColor = color?.cgColor
            this.partyButton.setTitleColor(color, for: UIControl.State())
          },
          completion: nil)
      }
      .disposed(by: self.disposeBag)
  }
}
