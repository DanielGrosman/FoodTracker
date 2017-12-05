//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Daniel Grosman on 2017-12-04.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//
import Foundation
import UIKit
import KeychainSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let newUser = CloudTrackerAPI ()
        newUser.registerUser(username: usernameTextField.text!, password: passwordTextField.text!)
    }
}



