//
//  SignUpViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 23/11/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        ErrorLabel.alpha=0
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&?]).*$")
        return passwordTest.evaluate(with: password)
    }
    
    
    func validateFields() -> String? {
        
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Controllo se la password è sicura
        // let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /* if isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure your password is at least more than 6 characters, with at least one capital, numeric or special character. "
        } */
    
        
        
        return nil
    }

    @IBAction func SignUpTapped(_ sender: Any) {
        // Controlla i campi
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
        }
        else {
            
            let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
                //Crea l'utente
                Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Controlla gli errori
                if err != nil {
                    
                    self.showError("Error creating user")
                    
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["firstname":firstName , "lastname": lastName , "uid" : result!.user.uid]) { (error) in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                        
                        
                    }
                    
                    self.transitionToHome()
                    
                }
            }
                   
            
            
            
            //Transizione alla home
            
            
            
            
        }
        
        
       
    }
    
    func showError(_ message:String) {
        
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
        
    }
    
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController)
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
