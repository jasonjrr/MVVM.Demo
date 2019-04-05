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

class LoginViewController: UIViewController, DialogTransitionTarget {
    @IBOutlet weak var dialogCard: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomButtonsStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private(set) var transitionManager: TransitionManager?
    
    private var viewModel: LoginViewModel!
    private var disposeBag: DisposeBag!
    
    class func instantiate(viewModel: LoginViewModel) -> LoginViewController {
        let viewController: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController.viewModel = viewModel
        
        let transitionManager: DialogTransitionManager = DialogTransitionManager()
        transitionManager.beforeViewDidLoad(target: viewController, transitionDuration: .dialogMedium)
        viewController.transitionManager = transitionManager
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dialogCard.layer.cornerRadius = 8
        self.dialogCard.applyShadowDown(withDepth: 24)
        
        self.bottomButtonsStackView.distribution = .fillEqually
        self.bottomButtonsStackView.spacing = 8
        
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
            .map { next -> String? in
                if let text = next {
                    var maskedPassword: String = String.empty
                    for _ in 0..<text.count {
                        maskedPassword.append("●")
                    }
                    return maskedPassword
                } else {
                    return nil
                }
            }
            .asDriver(onErrorJustReturn: nil)
            .drive(self.passwordTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.canLogIn
            .do(onNext: { [weak self] in self?.loginButton.isUserInteractionEnabled = $0 })
            .map { $0 ? UIColor.orange : UIColor.lightGray }
            .drive(onNext: { self.loginButton.tintColor = $0 })
            .disposed(by: self.disposeBag)
    }
    
    private func bindComponents() {
        self.userNameTextField.rx.controlEvent(.editingChanged)
            .debounce(0.3, scheduler: MainScheduler.instance)
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
                self?.dismiss(animated: true) {
                    self?.viewModel.didLogLogIn.accept(())
                }
            }
            .disposed(by: self.disposeBag)
    }
}
