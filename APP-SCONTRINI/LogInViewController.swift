//
//  LogInViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 23/11/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements(){
        
        errorLabel.alpha = 0
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
    @IBAction func loginTapped(_ sender: Any) {
        
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                   
            errorLabel.text = "Fill the fields please"
            errorLabel.alpha = 1
            
        }
        
        
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                
                self.errorLabel.text =  error!.localizedDescription
                self.errorLabel.alpha = 1
                
            }
            else {
                
                let homeViewController =
                    self.storyboard?
                .instantiateViewController(identifier:
                    Constants.Storyboard.homeViewController)
                        
                self.view.window?.rootViewController =  homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
