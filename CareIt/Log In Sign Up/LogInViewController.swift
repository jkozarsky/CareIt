//
//  LogInViewController.swift
//  CareIt
//
//  Created by Jason Kozarsky (student LM) on 1/4/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {

    //variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    //Log In Button
    @IBAction func logInButtonTouchedUp(_ sender: UIButton) {
        
        // all code in this method is the same as the firebase
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error)
            in
            
            if error == nil && user != nil{
                //this uses the navication controller to go back to the launch screen,
                // which then automatically segues to the home screen
                self.navigationController?.popViewController(animated: true)
            }
            else{
                print(error!.localizedDescription)
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
    
    // switches which text field the curser is in when the user hits enter on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        }
        else if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
            logInButton.isEnabled = true
        }
        return true 
    }
    
    
//    CODE FOR HUGHES
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "MyWhateverScreen":
//            let destination = segue.destination as! LogInViewController
//        }
//    }

    
}
