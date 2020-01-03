//
//  mesiViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 19/12/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class mesiViewController: UIViewController,  UITableViewDataSource , UITableViewDelegate {
    
    var titoloCella:String = " "
    
    
    @IBOutlet weak var myTableView: UITableView!
    
     let db = Firestore.firestore()
       
    var arrayMesi : [String] = []
       
      
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           print(arrayMesi)
            return arrayMesi.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            
            cell.textLabel?.text = intToMonth(meseNumero: arrayMesi[indexPath.row])
            
            return cell
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       //let vc = storyboard?.instantiateViewController(withIdentifier: "scontriniViewController") as? scontriniViewController
       let vc = storyboard?.instantiateViewController(withIdentifier: "nonNeHoIdea") as? ProvaBottoneDentroCella
       //let cell = tableView.cellForRow(at: indexPath)
      // let cellText = cell!.textLabel?.text ?? "NON RILEVATO"
       
        //vc?.meseCella = arrayMesi[indexPath.row]
        vc?.meseCella = arrayMesi[indexPath.row]
       vc?.titoloCella = titoloCella
       
       self.navigationController?.pushViewController(vc!, animated: true)
       }

    
        /*
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
            let vc = storyboard?.instantiateViewController(withIdentifier: "mesiViewController") as? mesiViewController
            
            let cell = tableView.cellForRow(at: indexPath)
            let cellText = cell!.textLabel?.text ?? "NON RILEVATO"
            
            vc?.titoloCella = cellText
            
            self.navigationController?.pushViewController(vc!, animated: true)
            }
*/
    //    @IBOutlet weak var myTableView: UITableView!
        
        
        override func viewDidLoad() {
           super.viewDidLoad()
            mesi()
            
            print(arrayMesi)
            print(titoloCella)
            // Do any additional setup after loading the view.
        }
        

        
    func mesi() {
            
            if let uid = Auth.auth().currentUser?.uid {
                let campo = self.db.collection("users").document(uid)
                              
                campo.collection("scontrini").whereField("anno", isEqualTo: titoloCella).getDocuments() { (querySnapshot, err) in
                           if let err = err {
                               print("Error getting documents: \(err)")
                               
                           } else {
                               for document in querySnapshot!.documents {
            
                                   let mese = (document.data()["mese"] ?? "nada") as! String
                                if !self.arrayMesi.contains(mese){
                                    self.arrayMesi.append(mese)
                                   }
                               }
                            print(self.arrayMesi)
                           }
                        self.myTableView.reloadData()
                        }
             
            }
        
    }
    
    func intToMonth(meseNumero : String ) -> String {
        
        
        let a:Int? = Int(meseNumero)
        
        let mesi = ["Default ", "Gennaio","Febbraio", "Marzo" , "Aprile", "Maggio", "Giugno", "Luglio", "Agosto","Settembre","Ottobre","Novembre","Dicembre"]
        return mesi[a ?? 0]
        
    }
    
    

}
