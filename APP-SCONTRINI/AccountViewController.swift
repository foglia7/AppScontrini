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
        
        
               
               /* if let idData = results[uid!] as? [String: Any] {
                       let nome = idData["firstname"] as? String ?? ""
                       let cognome = idData["lastname"] as? String ?? ""
                       
                    self.nomeLabel.text = "   " + nome
                    self.cognomeLabel.text = "   " + cognome
                    
                    print(nome)
                    print(cognome)
                    
                   } */
}
           
       

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
