//
//  MemberLoginViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class MemberLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var amountValueLabel = String()
    var durationValueLabel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func loginMember(_ sender: Any) {
        view.endEditing(true)
        
        if [emailField, passwordField].fieldsEmpty {
            showAlert(title: "Error", message: "Please complete the form to continue.", actions: ["OK"])
            return
        }
        
        performSegue(withIdentifier: "proceedLoanApplicationPage", sender: nil)
    }
    
    @IBAction func signUpMember(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: "showSignUpPage", sender: nil)
    }
    
    @IBAction func dismissMemberLoginView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func KeyboardWasShown(_ notiification: NSNotification) {
        guard let info = notiification.userInfo, let KeyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let KeyboardFrame = KeyboardFrameValue.cgRectValue
        let KeyboardSize = KeyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: KeyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func UIKeyboardWillBeHidden(_ notiification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "proceedLoanApplicationPage") {
            let loanApplicationVC = segue.destination as! LoanApplicationViewController
            loanApplicationVC.requestedAmountValue = amountValueLabel
            loanApplicationVC.durationValue = durationValueLabel
        }
    }

}


