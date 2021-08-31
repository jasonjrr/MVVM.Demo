//
//  LoginViewController.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/19/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoginViewController: UIViewController, DialogTransitionTarget {
  let dialogCard: UIView = UIView()
  let dialogCardStackView: UIStackView = UIStackView()
  let titleLabel: UILabel = UILabel()
  let userNameLabel: UILabel = UILabel()
  let userNameTextField: UITextField = UITextField()
  let passwordLabel: UILabel = UILabel()
  let passwordTextField: UITextField = UITextField()
  let bottomButtonsStackView: UIStackView = UIStackView()
  let cancelButton: UIButton = UIButton()
  let loginButton: UIButton = UIButton()
  
  private(set) var transitionManager: TransitionManager?
  
  private let viewModel: LoginViewModel
  private var disposeBag: DisposeBag!
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)

    let transitionManager: DialogTransitionManager = DialogTransitionManager()
    transitionManager.beforeViewDidLoad(target: self, transitionDuration: .dialogMedium)
    self.transitionManager = transitionManager
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.dialogCard)
    
    self.dialogCard.backgroundColor = .systemBackground
    self.dialogCard.layer.cornerRadius = 8
    self.dialogCard.applyShadowDown(withDepth: 24)
    self.dialogCard.snp.makeConstraints { make in
      make.leading.equalTo(24.0)
      make.top.greaterThanOrEqualTo(24.0)
      make.trailing.equalTo(-24)
      make.centerY.lessThanOrEqualTo(self.view.snp.centerYWithinMargins)
    }
    
    let keyboardConstraint = KeyboardLayoutConstraint.initialize(item: self.view, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.dialogCard, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    self.view.addConstraint(keyboardConstraint)
    keyboardConstraint.isActive = true
    
    self.dialogCard.addSubview(self.dialogCardStackView)
    
    self.dialogCardStackView.axis = .vertical
    self.dialogCardStackView.snp.makeConstraints { make in
      make.leading.top.equalTo(24.0)
      make.trailing.equalTo(-24.0)
      make.bottom.equalTo(-16.0)
    }
    
    let titleWrapperView = UIView()
    titleWrapperView.addSubview(self.titleLabel)
    self.titleLabel.text = "Login to your fake demo account!"
    self.titleLabel.numberOfLines = 0
    self.titleLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
    self.titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.dialogCardStackView.addArrangedSubview(titleWrapperView)
    self.dialogCardStackView.addArrangedSubview(self.userNameLabel)
    self.dialogCardStackView.addArrangedSubview(self.userNameTextField)
    self.dialogCardStackView.addArrangedSubview(self.passwordLabel)
    self.dialogCardStackView.addArrangedSubview(self.passwordTextField)
    self.dialogCardStackView.addArrangedSubview(self.bottomButtonsStackView)
    
    self.dialogCardStackView.setCustomSpacing(24.0, after: titleWrapperView)
    self.dialogCardStackView.setCustomSpacing(8.0, after: self.userNameLabel)
    self.dialogCardStackView.setCustomSpacing(16.0, after: self.userNameTextField)
    self.dialogCardStackView.setCustomSpacing(8.0, after: self.passwordLabel)
    self.dialogCardStackView.setCustomSpacing(16.0, after: self.passwordTextField)
    
    self.userNameLabel.text = "Username"
    self.userNameLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
    
    self.userNameTextField.borderStyle = .roundedRect
    self.userNameTextField.returnKeyType = .done
    
    self.passwordLabel.text = "Password"
    self.passwordLabel.font = .systemFont(ofSize: 17.0, weight: .medium)
    self.passwordTextField.isSecureTextEntry = true
    self.passwordTextField.borderStyle = .roundedRect
    self.passwordTextField.returnKeyType = .done
    
    self.bottomButtonsStackView.distribution = .fillEqually
    self.bottomButtonsStackView.spacing = 8
    self.bottomButtonsStackView.snp.makeConstraints { make in
      make.height.equalTo(48.0)
    }
    
    self.bottomButtonsStackView.addArrangedSubview(self.cancelButton)
    self.bottomButtonsStackView.addArrangedSubview(self.loginButton)
    
    self.cancelButton.setTitle("Cancel", for: .normal)
    self.cancelButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
    self.cancelButton.setTitleColor(.systemBlue, for: .normal)
    
    self.loginButton.setTitle("Login", for: .normal)
    self.loginButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .medium)
    self.loginButton.setTitleColor(.systemBlue, for: .normal)
    self.loginButton.setTitleColor(.secondaryLabel, for: .disabled)
    
    self.disposeBag = DisposeBag()
    bindViewModel()
    bindComponents()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.userNameTextField.becomeFirstResponder()
  }
  
  private func bindViewModel() {
    self.viewModel.userName
      .asDriver(onErrorJustReturn: nil)
      .drive(self.userNameTextField.rx.text)
      .disposed(by: self.disposeBag)
    
    self.viewModel.password
      .asDriver(onErrorJustReturn: nil)
      .drive(self.passwordTextField.rx.text)
      .disposed(by: self.disposeBag)
    
    self.viewModel.canLogIn
      .drive(onNext: { [weak self] in self?.loginButton.isEnabled = $0 })
      .disposed(by: self.disposeBag)
  }
  
  private func bindComponents() {
    self.userNameTextField.rx.controlEvent(.editingChanged)
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .withLatestFrom(self.userNameTextField.rx.text)
      .bind(to: self.viewModel.userName)
      .disposed(by: self.disposeBag)
    
    self.passwordTextField.rx.controlEvent(.editingChanged)
      .withLatestFrom(self.passwordTextField.rx.text)
      .bind(to: self.viewModel.password)
      .disposed(by: self.disposeBag)
    
    self.cancelButton.rx.tap
      .bind { [weak self] in self?.dismiss(animated: true, completion: nil) }
      .disposed(by: self.disposeBag)
    
    self.loginButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.submitLogInCredentials.accept(())
        self?.dismiss(animated: true) { [weak self] in
          self?.viewModel.didLogLogIn.accept(())
        }
      }
      .disposed(by: self.disposeBag)
  }
}
