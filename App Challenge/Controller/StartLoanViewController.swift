//
//  StartLoanViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class StartLoanViewController: UIViewController {

    @IBOutlet var userIdentifierView: UIVisualEffectView!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var durationValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSuccessfulLoanNotification()
        amountValueLabel.text = "$8,500"
        durationValueLabel.text = "19 months"
    }
    
    @IBAction func amountSliderValueChanged(_ sender: UISlider) {
        let interval = 100
        let amountValue = Int(sender.value / Float(interval) ) * interval
        sender.value = Float(amountValue)
        
        amountValueLabel.isHidden = false
        amountValueLabel.text = "$\(Int(sender.value))"
    }
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
        let interval = 1
        let durationValue = Int(sender.value / Float(interval) ) * interval
        sender.value = Float(durationValue)
        
        durationValueLabel.isHidden = false
        durationValueLabel.text = "\(Int(sender.value)) months"
    }
    
    @objc func dismissView(_ notification:Notification) {
        userIdentifierView.removeFromSuperview()
    }
    
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
    
    func registerSuccessfulLoanNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView(_:)), name: NSNotification.Name(rawValue: "successfulLoan"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showApplyLoanPage") {
            let loanApplicationVC = segue.destination as! LoanApplicationViewController
            loanApplicationVC.requestedAmountValue = amountValueLabel.text!
            loanApplicationVC.durationValue = durationValueLabel.text!
        }
        
        if (segue.identifier == "showMemberLoginPage") {
            let memberLoginNC = segue.destination as! UINavigationController
            let memberLoginVC = memberLoginNC.topViewController as! MemberLoginViewController
            memberLoginVC.amountValueLabel = amountValueLabel.text!
            memberLoginVC.durationValueLabel = durationValueLabel.text!
        }
    }

}
