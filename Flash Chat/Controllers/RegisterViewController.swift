//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Юрий on 18.12.2023.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print(error)
            } else {
                self.performSegue(withIdentifier: "RegisterToChat", sender: self)
            }
        }
    }
    

}
