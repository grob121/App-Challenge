//
//  MemberLoginViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import CoreData

class MemberLoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Passed Data Objects
    var amountValueLabel = String()
    var durationValueLabel = String()
    
    // MARK: - Core Data Mapped Entities
    var member = Member()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up keyboard
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        // Conform to text field delegate
        setDelegatesForTextFields()
    }
    
    // MARK: - Login and Sign up Navigation
    @IBAction func loginMember(_ sender: Any) {
        view.endEditing(true)
        
        for member in fetchMembers()! {
            self.member = member
            if self.member.email == emailField.text  && self.member.password == passwordField.text {
                performSegue(withIdentifier: "proceedLoanApplicationPage", sender: nil)
                return
            }
        }
    
        showAlert(title: "Login Error", message: "Email or password is incorrect.", actions: ["OK"])
    }
    
    @IBAction func signUpMember(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: "showSignUpPage", sender: nil)
    }
    
    @IBAction func dismissMemberLoginView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "proceedLoanApplicationPage") {
            let loanApplicationVC = segue.destination as! LoanApplicationViewController
            loanApplicationVC.requestedAmountValue = amountValueLabel
            loanApplicationVC.durationValue = durationValueLabel
            loanApplicationVC.previousVC = "memberLoginVC"
            loanApplicationVC.member = self.member
        }
    }
    
    // MARK: - Text Fields and Delegates
    func setDelegatesForTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    func validateFields() {
        if [emailField, passwordField].fieldsEmpty {
            showAlert(title: "Error", message: "Please complete the form to continue.", actions: ["OK"])
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // MARK: - Keyboard Configuration
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
}
