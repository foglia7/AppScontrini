//
//  ArchivioViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 16/12/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class ArchivioViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    let db = Firestore.firestore()
   var arrayAnni : [String] = []
   
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(arrayAnni)
        return arrayAnni.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = arrayAnni[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let vc = storyboard?.instantiateViewController(withIdentifier: "mesiViewController") as? mesiViewController
        
        let cell = tableView.cellForRow(at: indexPath)
        let cellText = cell!.textLabel?.text ?? "NON RILEVATO"
        
        
        vc?.titoloCella = cellText
        
        self.navigationController?.pushViewController(vc!, animated: true)
        }

//    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        anni()
        
        print(arrayAnni)
        // Do any additional setup after loading the view.
    }
    

    
func anni() {
        
        if let uid = Auth.auth().currentUser?.uid {
            let campo = self.db.collection("users").document(uid)
                          
                campo.collection("scontrini").getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                           
                       } else {
                           for document in querySnapshot!.documents {
        
                               let anno = (document.data()["anno"] ?? "nada") as! String
                            if !self.arrayAnni.contains(anno){
                                self.arrayAnni.append(anno)
                               }
                           }
                        print(self.arrayAnni)
                       }
                    self.myTableView.reloadData()
                    }
         
        }
    
}
}
