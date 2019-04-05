//
//  PartyViewController.swift
//  MVVM.Demo
//
//  Created by Jason Lew-Rapai on 4/20/18.
//  Copyright © 2018 Jason Lew-Rapai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PartyViewController: UIViewController, TransitionManageable {
    @IBOutlet weak var backgroundContainer: UIView!
    
    private(set) var transitionManager: TransitionManager?
    
    private var viewModel: PartyViewModel!
    private var disposeBag: DisposeBag!
    
    class func instantiate(viewModel: PartyViewModel) -> PartyViewController {
        let viewController: PartyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PartyViewController") as! PartyViewController
        viewController.viewModel = viewModel
        
        let transitionManager: DropInTransitionManager = DropInTransitionManager()
        transitionManager.beforeViewDidLoad(sourceViewController: viewController, transitionDuration: .fullScreen)
        viewController.transitionManager = transitionManager
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        self.backgroundContainer.clipsToBounds = true
        
        self.disposeBag = DisposeBag()
        
        self.viewModel.title
            .drive(self.rx.title)
            .disposed(by: self.disposeBag)
        
        Observable<Int>
            .interval(0.4, scheduler: MainScheduler.instance)
            .map { _ in self.viewModel.getNextColor() }
            .bind { [weak self] color in
                self?.updatePartyBackground(withColor: color)
            }
            .disposed(by: self.disposeBag)
        
        Observable<Int>
            .interval(0.15, scheduler: MainScheduler.instance)
            .map { _ in self.viewModel.getRandomEmoji() }
            .bind { [weak self] emoji in
                self?.addEmojiPartyMember(emoji: emoji)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func updatePartyBackground(withColor color: UIColor) {
        let background: UIView = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = color
        background.layer.cornerRadius = self.backgroundContainer.frame.height / 2
        self.backgroundContainer.addSubview(background)
        self.backgroundContainer.bringSubviewToFront(background)
        
        let constraints: [NSLayoutConstraint] = [
            background.centerXAnchor.constraint(equalTo: self.backgroundContainer.centerXAnchor),
            background.centerYAnchor.constraint(equalTo: self.backgroundContainer.centerYAnchor),
            background.heightAnchor.constraint(equalToConstant: self.backgroundContainer.frame.height),
            background.widthAnchor.constraint(equalToConstant: self.backgroundContainer.frame.height),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        background.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animateKeyframes(
            withCustomEasing: .decelerationCurve,
            duration: 3.6, delay: 0.0,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    background.transform = .identity
                }
                UIView.addKeyframe(withRelativeStartTime: 7/10, relativeDuration: 3/10) {
                    background.alpha = 0.0
                }
            },
            completion: { (finished) in
                background.removeFromSuperview()
            })
    }
    
    private func addEmojiPartyMember(emoji: String) {
        let emojiLabel: UILabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = emoji
        self.view.addSubview(emojiLabel)
        
        let top: UInt32 = UInt32(self.view.frame.height)
        
        let constraints: [NSLayoutConstraint] = [
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(arc4random_uniform(top))),
            emojiLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        emojiLabel.transform = CGAffineTransform(translationX: self.view.frame.width + 24, y: 0)
        
        let delay: TimeInterval = TimeInterval(arc4random_uniform(3) / 10)
        
        UIView.animate(
            withCustomEasing: .accelerationCurve,
            duration: 1.4, delay: delay,
            animations: {
                emojiLabel.transform = CGAffineTransform(translationX: -25.0, y: 0)
            },
            completion: { finished in
                emojiLabel.removeFromSuperview()
            })
    }
}
