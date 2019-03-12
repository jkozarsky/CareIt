//
//  SignUpViewController.swift
//  CareIt
//
//  Created by Jason Kozarsky (student LM) on 1/4/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //Sign Up Button
    @IBAction func signUpButtonTouchedUp(_ sender: UIButton) {
        // code is the same as the firebase authentication project
        //
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil, error == nil{
                print("user created")
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print(error.debugDescription)
            }
        }
    }
    
    //Sets delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        emailTextField.delegate = self  
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()
    }
    
    //Allows user to move on after all fields are entered
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        }
        else{
            passwordTextField.resignFirstResponder()
            signUpButton.isEnabled = true
        }
        
        return true
    }
    

}
