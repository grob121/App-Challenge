//
//  LoanApplicationViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class LoanApplicationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

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
    
    var requestedAmountValue = String()
    var durationValue = String()
    
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    var titleArray = [String]()
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        
        requestedAmountField.text = requestedAmountValue
        requestedAmountField.textColor = UIColor.darkGray
        durationField.text = durationValue
        durationField.textColor = UIColor.darkGray
        
        loanReasonsField.delegate = self
        titleField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        dateOfBirthField.delegate = self
        emailField.delegate = self
        mobileNumberField.delegate = self
    }
    
    @IBAction func applyLoan(_ sender: Any) {
        view.endEditing(true)
        
        if [loanReasonsField, titleField, firstNameField, lastNameField, dateOfBirthField, emailField, mobileNumberField].fieldsEmpty {
            showAlert(title: "Error", message: "Please complete the form to continue.", actions: ["OK"])
            return
        }
        
        if !(emailField.text?.isValidEmail())! {
            showAlert(title: "Error", message: "Your email has invalid format.", actions: ["OK"])
            return
        }
        
        if !(mobileNumberField.text?.isValidPhoneNumber())! {
            showAlert(title: "Error", message: "Mobile Number has invalid format.", actions: ["OK"])
            return
        }
        
        view.addSubview(successfulApplicationView)
        successfulApplicationView.bounds = view.bounds
        successfulApplicationView.center = view.center
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "successfulLoan"), object: nil)
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissLoanApplicationView(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
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
        self.view.endEditing(true)
        return false
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

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
