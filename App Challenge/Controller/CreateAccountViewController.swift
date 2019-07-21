//
//  CreateAccountViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 19/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet var successfulCreateView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpMember(_ sender: Any) {
        self.view.addSubview(successfulCreateView)
        successfulCreateView.bounds = self.view.bounds
        successfulCreateView.center = self.view.center
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissCreateAccountView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
