//
//  StartLoanViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class StartLoanViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var userIdentifierView: UIVisualEffectView!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var durationValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification for successful loan
        registerSuccessfulLoanNotification()
        
        // Set default values for amount and duration labels
        setDefaultAmountDurationLabel()
    }
    
    // MARK: - Text Fields
    func setDefaultAmountDurationLabel() {
        amountValueLabel.text = "$8,500"
        durationValueLabel.text = "19 months"
    }
    
    // MARK: - UISlider
    @IBAction func amountSliderValueChanged(_ sender: UISlider) {
        let interval = 100
        let amountValue = Int(sender.value/Float(interval))*interval
        sender.value = Float(amountValue)
        
        amountValueLabel.isHidden = false
        amountValueLabel.text = "$\(Int(sender.value))"
    }
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
        let interval = 1
        let durationValue = Int(sender.value/Float(interval)) * interval
        sender.value = Float(durationValue)
        
        durationValueLabel.isHidden = false
        durationValueLabel.text = "\(Int(sender.value)) months"
    }
    
    // MARK: - Notification
    @objc func dismissView(_ notification:Notification) {
        userIdentifierView.removeFromSuperview()
    }
    
    func registerSuccessfulLoanNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView(_:)), name: NSNotification.Name(rawValue: "successfulLoan"), object: nil)
    }
    
    // MARK: - Flow and Segues
    @IBAction func submitLoanPreferences(_ sender: Any) {
        view.addSubview(userIdentifierView)
        userIdentifierView.bounds = view.bounds
        userIdentifierView.center = view.center
    }
    
    @IBAction func startApplication(_ sender: Any) {
        performSegue(withIdentifier: "showApplyLoanPage", sender: nil)
    }
    
    @IBAction func memberLogin(_ sender: Any) {
        performSegue(withIdentifier: "showMemberLoginPage", sender: nil)
    }
    
    @IBAction func dismissUserIdentifierView(_ sender: Any) {
        userIdentifierView.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showApplyLoanPage") {
            let loanApplicationVC = segue.destination as! LoanApplicationViewController
            loanApplicationVC.requestedAmountValue = amountValueLabel.text!
            loanApplicationVC.durationValue = durationValueLabel.text!
            loanApplicationVC.previousVC = "startLoanVC"
        }
        if (segue.identifier == "showMemberLoginPage") {
            let memberLoginNC = segue.destination as! UINavigationController
            let memberLoginVC = memberLoginNC.topViewController as! MemberLoginViewController
            memberLoginVC.amountValueLabel = amountValueLabel.text!
            memberLoginVC.durationValueLabel = durationValueLabel.text!
        }
    }

}
