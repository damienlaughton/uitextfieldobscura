//
//  BaseViewController.swift
//  uitextfieldobscura
//
//  Created by Damien Laughton on 19/05/2019.
//  Copyright © 2019 Damien Laughton. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint?

}

/// Adjust any scroll view bottom constraint when the keyboard
/// appears or disappears
extension BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startObservingKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {

        stopObservingKeyboardNotifications()

        super.viewWillDisappear(animated)
    }

    /// Add the observors for keyboard showing / hiding
    func startObservingKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// Remove the observors for keyboard showing / hiding
    func stopObservingKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// When the keyboard shows, get it's height and adjust the constant
    /// of the scroll view bottom constraint, setting it to the height.
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            scrollViewBottomConstraint?.constant = keyboardRectangle.height
        }
    }

    /// When the keyboard hides, reset the constant
    /// of the scroll view bottom constraint to zero.
    @objc func keyboardWillHide(_ notification: Notification) {

        scrollViewBottomConstraint?.constant = 0.0
    }
}

/// Dismiss keyboard when tap on view
extension BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }

    /// Hide the keyboard when the user taps somewhere ele on the screen
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// Hides the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

/// Hides the keyboard when its 'Return' key is tapped
extension BaseViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
