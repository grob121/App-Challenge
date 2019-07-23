//
//  CreateAccountViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 19/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import CoreData

class CreateAccountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var successfulCreateView: UIVisualEffectView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    
    // MARK: - Core Data Mapped Entities
    var member = Member()
    var newCustomer = NewCustomer()
    
    // MARK: - Date Picker and Picker View Utils
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    var titleArray = [String]()
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up keyboard
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        // Conform to text field delegate
        setDelegatesForTextFields()
    }
    
    // MARK: - Create Account Control and Flow
    @IBAction func signUpMember(_ sender: Any) {
        view.endEditing(true)
        
        // Validate user inputs on text fields
        if(validateFields()) {
            // Save user as member to Member entity
            createNewMember()
        }
    }
    
    @IBAction func dismissCreateAccountView(_ sender: Any) {
        view.endEditing(true)
        
        if [emailField, passwordField, confirmPasswordField, titleField, firstNameField, lastNameField, dateOfBirthField, mobileNumberField].fieldsWithContent {
            dismiss(animated: true, completion: nil)
            return
        }
        
        showAlert(title: "Are you sure you want to exit?", message: "This will discard your changes.", actions: ["Cancel","OK"])
    }
    
    func displaySuccesfulCreateAccountView() {
        view.addSubview(successfulCreateView)
        successfulCreateView.bounds = view.bounds
        successfulCreateView.center = view.center
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Core Data Fetch and Save
    func createNewMember() {
        for member in fetchMembers()! {
            self.member = member
            if self.member.title == titleField.text && self.member.firstName == firstNameField.text && self.member.lastName == lastNameField.text && self.member.dateOfBirth == dateOfBirthField.text {
                showAlert(title: "Create Account Failed", message: "This account is existing.", actions: ["OK"])
                return
            }
        }
        
        setMemberEntityValues()
        
        if saveData() {
            for newCustomer in fetchNewCustomers()! {
                self.newCustomer = newCustomer
                if self.newCustomer.title == titleField.text && self.newCustomer.firstName == firstNameField.text && self.newCustomer.lastName == lastNameField.text && self.newCustomer.dateOfBirth == dateOfBirthField.text {
                    deleteNewCustomer(self.newCustomer)
                }
            }
            displaySuccesfulCreateAccountView()
        } else {
            showAlert(title: "Loan Application Failed", message: "Please try again.", actions: ["OK"])
            return
        }
    }
    
    func setMemberEntityValues() {
        self.member = getMemberEntity(self.member)
        self.member.setValue("", forKey: "requestedAmount")
        self.member.setValue("", forKey: "duration")
        self.member.setValue("", forKey: "loanReasons")
        self.member.setValue(passwordField.text, forKey: "password")
        self.member.setValue(titleField.text, forKey: "title")
        self.member.setValue(firstNameField.text, forKey: "firstName")
        self.member.setValue(lastNameField.text, forKey: "lastName")
        self.member.setValue(dateOfBirthField.text, forKey: "dateOfBirth")
        self.member.setValue(emailField.text, forKey: "email")
        self.member.setValue(mobileNumberField.text, forKey: "mobileNumber")
    }
    
    // MARK: - Text Fields and Delegates
    func setDelegatesForTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        titleField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        dateOfBirthField.delegate = self
        mobileNumberField.delegate = self
    }
    
    func validateFields() -> Bool {
        if [emailField, passwordField, confirmPasswordField, titleField, firstNameField, lastNameField, dateOfBirthField, mobileNumberField].fieldsEmpty {
            showAlert(title: "Error", message: "Please complete the form to continue.", actions: ["OK"])
            return false
        }
        if !(emailField.text?.isValidEmail())! {
            showAlert(title: "Error", message: "Email has invalid format.", actions: ["OK"])
            return false
        }
        if !(mobileNumberField.text?.isValidPhoneNumber())! {
            showAlert(title: "Error", message: "Mobile Number has invalid format.", actions: ["OK"])
            return false
        }
        if !(passwordField.text?.isValidPassword())! {
            showAlert(title: "Invalid Password", message: "Password must have minimum of 8 characters, at least 1 uppercase alphabet, 1 lowercase Alphabet, 1 number and 1 special character to proceed.", actions: ["OK"])
            return false
        }
        if (passwordField.text != confirmPasswordField.text) {
            showAlert(title: "Password Mismatch", message: "Make sure that Password and Confirm Password fields have the same content.", actions: ["OK"])
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateOfBirthField {
            showDatePicker()
        }
        if textField == titleField {
            showPickerView(textField)
        }
        if textField == mobileNumberField {
            showDonePhonePad()
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
    
    // MARK: - Date Picker Set Up
    func showDatePicker(){
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dateOfBirthField.inputAccessoryView = toolbar
        dateOfBirthField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateOfBirthField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        view.endEditing(true)
    }
    
    // MARK: - Picker View Delegate and Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    func showPickerView(_ textField : UITextField){
        pickerView.delegate = self
        pickerView.dataSource = self
        titleArray = ["Mr.","Ms.","Mrs."]
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerView));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPickerView));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = pickerView
    }
    
    @objc func donePickerView() {
        titleField.text = titleArray[selectedRow]
        view.endEditing(true)
    }
    
    @objc func cancelPickerView() {
        view.endEditing(true)
    }

    // MARK: - Phone Pad Modification
    func showDonePhonePad(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePhonePad));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        mobileNumberField.inputAccessoryView = toolbar
    }
    
    @objc func donePhonePad() {
        view.endEditing(true)
    }
    
}
