//
//  AccountViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 25/11/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AccountViewController: UIViewController {

  
    @IBOutlet weak var nomeLabel: UILabel!
    
    @IBOutlet weak var cognomeLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
      
        let email = Auth.auth().currentUser?.email
        let uid = Auth.auth().currentUser?.uid
        
        emailLabel.text = "   " + email!
   
      
        
        let docRef = db.collection("users").document(uid!)
    

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let nome = document.get("firstname") as! String
                let cognome = document.get("lastname") as! String
                
                
                self.nomeLabel.text = "   " +  nome
                
                self.cognomeLabel.text = "   " + cognome
                print("HO STAMPATO NOME E COGNOME")
            } else {
                print("Document does not exist")
            }
        }
        
        
            
}


    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let homeController = storyboard?.instantiateViewController(withIdentifier: "loginPage")
            print("#### HO ISTANZIATO IL CONTROLLER ####")
            _ = UIApplication.shared.delegate as! AppDelegate
            print("#### HO ISTANZIATO L'APP DELEGATE ####")
            
            view.window?.rootViewController = homeController
            print("#### HO ISTANZIATO IL ROOT VIEW CONTROLLER ####")
        } catch {
            print("#### ERROR ####")
        }
    }

}
