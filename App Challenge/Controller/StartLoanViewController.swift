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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView(_:)), name: NSNotification.Name(rawValue: "successfulLoan"), object: nil)
    }
    
    @objc func dismissView(_ notification:Notification) {
        userIdentifierView.removeFromSuperview()
    }
    
    @IBAction func submitLoanPreferences(_ sender: Any) {
        self.view.addSubview(userIdentifierView)
        userIdentifierView.bounds = self.view.bounds
        userIdentifierView.center = self.view.center
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
    
}
