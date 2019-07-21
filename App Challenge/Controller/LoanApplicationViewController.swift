//
//  LoanApplicationViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class LoanApplicationViewController: UIViewController {

    @IBOutlet var successfulApplicationView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func applyLoan(_ sender: Any) {
        self.view.addSubview(successfulApplicationView)
        successfulApplicationView.bounds = self.view.bounds
        successfulApplicationView.center = self.view.center
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "successfulLoan"), object: nil)
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissLoanApplicationView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
