//
//  MemberLoginViewController.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 18/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class MemberLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginMember(_ sender: Any) {
        performSegue(withIdentifier: "proceedLoanApplicationPage", sender: nil)
    }
    
    @IBAction func signUpMember(_ sender: Any) {
        performSegue(withIdentifier: "showSignUpPage", sender: nil)
    }
    
    @IBAction func dismissMemberLoginView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
