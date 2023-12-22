//
//  LoginViewController.swift
//  Flash Chat
//
//  Created by Юрий on 18.12.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let self else { return }
            if let error {
                print(error)
            } else {
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
            }
        
        }
    }
    
}
