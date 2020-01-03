//
//  scontriniViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 19/12/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class scontriniViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    let db = Firestore.firestore()
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var meseCella:String = " "   //mese scelto
    var titoloCella:String = " " //anno scelto
    
    var scontriniEsatti : [[String : String]] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return scontriniEsatti.count
        
    }
    
   
    
   
    
func collectionView (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scontrinoCella", for: indexPath) as! scontrinoCollectionViewCell
        
    
        //print(scontriniEsatti)
        // Configure the cell...
       let scontrino = scontriniEsatti[indexPath.row]
         
       
        let imageUrlString = scontrino["URL"]!
             let imageUrl:URL = URL(string: imageUrlString)!
           
    cell.scontrinoImageView.load(url: imageUrl)
    
    cell.cfLabel.text = scontrino["CF"]
    //cell.dataLabel.text = scontrino["data"]
    let data = scontrino["data"]
    let dataArr = data?.components(separatedBy: " ")
    cell.dataLabel.text = dataArr![0]
    cell.totaleLabel.text = scontrino["totale"]! + " € "
    cell.detraibileLabel.text = scontrino["detraibile"]! + " € "
        
      
        // Effetto ombra come App Store
        // The subview inside the collection view cell
        
        cell.layer.cornerRadius = 20.0
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7
        //This create the shadows effects
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.backgroundColor = UIColor.init(red: 173, green: 173, blue: 173, alpha: 1.00).self
    
    cell.contentView.isUserInteractionEnabled = true
    
        //add action to the edit button
        //cell.deleteButton.tag = indexPath.row
    //cell.deleteButton.addTarget(self, action: #selector(rimuoviScontrino), for: .touchUpInside)
    
    //cell.eliminaBottone.isEnabled = true
    //cell.eliminaBottone.isUserInteractionEnabled = true
    //cell.eliminaBottone.adjustsImageWhenHighlighted = true
    //cell.eliminaBottone.tag = indexPath.row
    //cell.eliminaBottone.addTarget(self, action: #selector(self.selectRadiostation(_:)), for: .touchUpInside)
    //cell.eliminaBottone.addTarget(self, action: Selector(selectRadiostation(sender: cell.eliminaBottone)), for: .touchUpInside)
        return cell
    
    
    }
    
    
    func selectRadiostation(sender: UIButton)
    {
        
        print("play")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scontriniGiusti()
        // Do any additional setup after loading the view.
    }
    
    	
    
       
    func scontriniGiusti() {
            
            if let uid = Auth.auth().currentUser?.uid {
                let campo = self.db.collection("users").document(uid)
                              
                campo.collection("scontrini").whereField("anno", isEqualTo: titoloCella).whereField("mese", isEqualTo: meseCella).getDocuments() { (querySnapshot, err) in
                           if let err = err {
                               print("Error getting documents: \(err)")
                               
                           } else {
                            
                               for document in querySnapshot!.documents {
                          /*
                                let scontrino = document.data()
                                    self.scontriniEsatti.append(scontrino)
                            */
                                self.scontriniEsatti.append(document.data() as! [String : String])
                               }
                            print(self.scontriniEsatti)
                           }
                        self.myCollectionView.reloadData()
                        }
             
            }
        
    }
 

    @IBAction func asdfdsdfssfd(_ sender: Any) {
        print("impossibile")
    }
}


extension UIImageView{
      func load(url: URL) {
          DispatchQueue.global().async { [weak self] in
              if let data = try? Data(contentsOf: url) {
                  if let image = UIImage(data: data){
                      DispatchQueue.main.async {
                          self?.image = image
                      }
                  }
              }
          }
      }
  }

func remove(uid: String , URL : String) {

    let db = Firestore.firestore()
    if let uid = Auth.auth().currentUser?.uid{
        let campo = db.collection("users").document(uid)
        let hashScontrino = String(URL.hashValue)
        

        campo.collection("scontrini").document(hashScontrino).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
    }
}

func rimuoviScontrino(sender : AnyObject){
    print("eeskhlsaoi asdop jefnoa sapodie fejiwp aèpw kvlmsddwio awij f")
    let uid = Auth.auth().currentUser?.uid
    //let scontrino = scontriniEsatti[sender.tag]
    //let imageUrlString = scontrino["URL"]!
   //remove(uid: uid ?? "uid non trovato", URL: imageUrlString)
   //scontriniEsatti.remove(at: indexPath.row)
   //print("Nuova lista \(scontriniEsatti)")
   //self.myCollectionView.reloadData()
}




