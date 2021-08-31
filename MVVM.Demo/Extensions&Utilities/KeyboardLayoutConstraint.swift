import UIKit
import RxSwift
import RxCocoa

public class KeyboardLayoutConstraint: NSLayoutConstraint {
  private var isInitialized: Bool = false
  
  fileprivate var offset: CGFloat = 0
  fileprivate var keyboardVisibleHeight: CGFloat = 0 {
    didSet { self._keyboardVisibleHeight.accept(self.keyboardVisibleHeight) }
  }
  
  private let _keyboardVisibleHeight: BehaviorRelay<CGFloat> = BehaviorRelay(value: 0)
  private(set) var keyboardVisibleHeightObservable: Observable<CGFloat>!
  
  var customOffset: CGFloat = 0
  
  public class func initialize(item view1: UIView, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, toItem view2: UIView?, attribute attr2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant c: CGFloat) -> KeyboardLayoutConstraint {
    let constraint: KeyboardLayoutConstraint = KeyboardLayoutConstraint(
      item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
    constraint.initialize()
    return constraint
  }
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    initialize()
  }
  
  private func initialize() {
    if self.isInitialized { return }
    self.isInitialized = true
    
    self.offset = constant
    self.keyboardVisibleHeightObservable = self._keyboardVisibleHeight.asObservable().distinctUntilChanged()
    
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardLayoutConstraint.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardLayoutConstraint.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: Notification
  
  @objc func keyboardWillShowNotification(_ notification: Notification) {
    guard let userInfo: [AnyHashable : Any] = notification.userInfo else { return }
    
    if let frameValue: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let frame: CGRect = frameValue.cgRectValue
      self.keyboardVisibleHeight = frame.size.height
    }
    
    self.updateConstant()
    switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
    case let (.some(duration), .some(curve)):
      let options: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: curve.uintValue)
      UIView.animate(
        withDuration: TimeInterval(duration.doubleValue),
        delay: 0,
        options: options,
        animations: {
          UIApplication.shared.windows.first?.layoutIfNeeded()
          return
      },
        completion: nil)
      
    default:
      break
    }
  }
  
  @objc func keyboardWillHideNotification(_ notification: NSNotification) {
    self.keyboardVisibleHeight = 0
    self.updateConstant()
    
    guard let userInfo: [AnyHashable : Any] = notification.userInfo else { return }
    
    switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
    case let (.some(duration), .some(curve)):
      let options: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: curve.uintValue)
      UIView.animate(
        withDuration: TimeInterval(duration.doubleValue),
        delay: 0,
        options: options,
        animations: {
          UIApplication.shared.windows.first?.layoutIfNeeded()
          return
        },
        completion: nil)
      
    default:
      break
    }
  }
  
  func updateConstant() {
    if self.keyboardVisibleHeight == 0 {
      self.constant = self.offset
    } else {
      self.constant = self.offset
        + self.keyboardVisibleHeight
        + self.customOffset
    }
  }
}
