import UIKit

public class KeyboardLayoutConstraint: NSLayoutConstraint {
  
  fileprivate var offset : CGFloat = 0
  fileprivate var keyboardVisibleHeight : CGFloat = 0
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    
    self.offset = constant
    
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
          UIApplication.shared.keyWindow?.layoutIfNeeded()
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
          UIApplication.shared.keyWindow?.layoutIfNeeded()
          return
      },
        completion: nil)
      
    default:
      break
    }
  }
  
  func updateConstant() {
    self.constant = self.offset + self.keyboardVisibleHeight
  }
}

class TabBarContainedKeyboardLayoutConstraint: KeyboardLayoutConstraint {
  override func updateConstant() {
    let safeAreaOffset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
    self.constant = self.offset + self.keyboardVisibleHeight - safeAreaOffset
  }
}
