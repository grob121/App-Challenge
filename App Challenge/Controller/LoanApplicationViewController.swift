//
//  LoanApplicationViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class LoanApplicationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var successfulApplicationView: UIVisualEffectView!
    @IBOutlet weak var requestedAmountField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var loanReasonsField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    
    // MARK: - Passed Data Objects
    var previousVC = String()
    var requestedAmountValue = String()
    var passwordValue = String()
    var durationValue = String()
    
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

        // Display loan amount and duration preferred
        displayAmountDurationValue()
        
        // Display details if member
        displayMemberDetails()
        
        // Conform to text field delegate
        setDelegatesForTextFields()
    }
    
    // MARK: - Loan Application Flow and Control
    @IBAction func applyLoan(_ sender: Any) {
        view.endEditing(true)
        
        // Validate user inputs on text fields
        if(validateFields()) {
            // Save user to NewCustomer or Member entities based on requirements
            saveNewCustomerOrMember()
        }
    }
    
    @IBAction func dismissLoanApplicationView(_ sender: Any) {
        view.endEditing(true)
        
        if previousVC == "memberLoginVC" {
            showAlert(title: "Are you sure you want to exit?", message: "This will also end your session.", actions: ["Cancel","OK"])
            return
        }
        if [loanReasonsField, titleField, firstNameField, lastNameField, dateOfBirthField, emailField, mobileNumberField].fieldsWithContent {
            dismiss(animated: true, completion: nil)
            return
        }
    
        showAlert(title: "Are you sure you want to exit?", message: "This will discard your changes.", actions: ["Cancel","OK"])
    }
    
    func displaySuccesfulLoanView() {
        view.addSubview(successfulApplicationView)
        successfulApplicationView.bounds = view.bounds
        successfulApplicationView.center = view.center
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "successfulLoan"), object: nil)
    
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Core Data Fetch and Save
    func saveNewCustomerOrMember() {
        if previousVC == "startLoanVC" {
            for newCustomer in fetchNewCustomers()! {
                self.newCustomer = newCustomer
                if self.newCustomer.title == titleField.text && self.newCustomer.firstName == firstNameField.text && self.newCustomer.lastName == lastNameField.text && self.newCustomer.dateOfBirth == dateOfBirthField.text {
                    showAlert(title: "Loan Application Failed", message: "Please login or sign up to apply for loan again.", actions: ["OK"])
                    return
                }
            }
            for member in fetchMembers()! {
                self.member = member
                if self.member.title == titleField.text && self.member.firstName == firstNameField.text && self.member.lastName == lastNameField.text && self.member.dateOfBirth == dateOfBirthField.text {
                    showAlert(title: "Loan Application Failed", message: "Please login or sign up to apply for loan again.", actions: ["OK"])
                    return
                }
            }
            
            setNewCustomerEntityValues()
            
            if saveData() {
                displaySuccesfulLoanView()
            } else {
                showAlert(title: "Loan Application Failed", message: "Please try again.", actions: ["OK"])
                return
            }
        } else {
            
            setMemberEntityValues()
            
            if saveData() {
                for member in fetchMembers()! {
                    self.member = member
                    if self.member.loanReasons!.isEmpty {
                        deleteNewMember(self.member)
                    }
                }
                displaySuccesfulLoanView()
            } else {
                showAlert(title: "Loan Application Failed", message: "Please try again.", actions: ["OK"])
                return
            }
        }
    }
    
    func setNewCustomerEntityValues() {
        self.newCustomer = getNewCustomerEntity(self.newCustomer)
        self.newCustomer.setValue(requestedAmountField.text, forKey: "requestedAmount")
        self.newCustomer.setValue(durationField.text, forKey: "duration")
        self.newCustomer.setValue(loanReasonsField.text, forKey: "loanReasons")
        self.newCustomer.setValue(titleField.text, forKey: "title")
        self.newCustomer.setValue(firstNameField.text, forKey: "firstName")
        self.newCustomer.setValue(lastNameField.text, forKey: "lastName")
        self.newCustomer.setValue(dateOfBirthField.text, forKey: "dateOfBirth")
        self.newCustomer.setValue(emailField.text, forKey: "email")
        self.newCustomer.setValue(mobileNumberField.text, forKey: "mobileNumber")
    }
    
    func setMemberEntityValues() {
        self.member = getMemberEntity(self.member)
        self.member.setValue(requestedAmountField.text, forKey: "requestedAmount")
        self.member.setValue(durationField.text, forKey: "duration")
        self.member.setValue(loanReasonsField.text, forKey: "loanReasons")
        self.member.setValue(titleField.text, forKey: "title")
        self.member.setValue(firstNameField.text, forKey: "firstName")
        self.member.setValue(lastNameField.text, forKey: "lastName")
        self.member.setValue(dateOfBirthField.text, forKey: "dateOfBirth")
        self.member.setValue(emailField.text, forKey: "email")
        self.member.setValue(mobileNumberField.text, forKey: "mobileNumber")
        self.member.setValue(passwordValue, forKey: "password")
    }
    
    // MARK: - Text Fields and Delegates
    func displayAmountDurationValue() {
        requestedAmountField.text = requestedAmountValue
        requestedAmountField.textColor = UIColor.darkGray
        durationField.text = durationValue
        durationField.textColor = UIColor.darkGray
    }
    
    func setDelegatesForTextFields() {
        loanReasonsField.delegate = self
        titleField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        dateOfBirthField.delegate = self
        emailField.delegate = self
        mobileNumberField.delegate = self
    }
    
    func displayMemberDetails() {
        if previousVC == "memberLoginVC" {
            titleField.text = member.title
            titleField.isEnabled = false
            firstNameField.text = member.firstName
            firstNameField.isEnabled = false
            lastNameField.text = member.lastName
            lastNameField.isEnabled = false
            dateOfBirthField.text = member.dateOfBirth
            dateOfBirthField.isEnabled = false
            passwordValue = member.password!
        }
    }
    
    func validateFields() -> Bool {
        if [loanReasonsField, titleField, firstNameField, lastNameField, dateOfBirthField, emailField, mobileNumberField].fieldsEmpty {
            showAlert(title: "Error", message: "Please complete the form to continue.", actions: ["OK"])
            return false
        }
        if !(emailField.text?.isValidEmail())! {
            showAlert(title: "Error", message: "Your email has invalid format.", actions: ["OK"])
            return false
        }
        if !(mobileNumberField.text?.isValidPhoneNumber())! {
            showAlert(title: "Error", message: "Mobile Number has invalid format.", actions: ["OK"])
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
