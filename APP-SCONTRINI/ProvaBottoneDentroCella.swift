//
//  ProvaBottoneDentroCella.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 01/01/2020.
//  Copyright © 2020 Mhscio. All rights reserved.
//

import UIKit
import WebKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

private let reuseIdentifier = "CellDemoo"

class ProvaBottoneDentroCella: UICollectionViewController {
    var meseCella = ""
    var titoloCella = ""
    
    var scontriniEsatti : [[String : String]] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        scontriniGiusti()

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return scontriniEsatti.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProvettaCell
    
        // Configure the cell
        
        let scontrino = scontriniEsatti[indexPath.row]
        cell.cfLabel.text = scontrino["CF"]
        let data = scontrino["data"]
        let dataArr = data?.components(separatedBy: " ")
        cell.dataLabel.text = dataArr![0]
        cell.totaleLabel.text = scontrino["totale"]! + " € "
        cell.detraibileLabel.text = scontrino["detraibile"]! + " € "
        cell.buttonCella.tag = indexPath.row
        cell.esportaBottone.tag = indexPath.row
           
        let imageUrlString = scontrino["URL"]!
        let imageUrl:URL = URL(string: imageUrlString)!
        cell.immagininaScontrino.load(url: imageUrl)
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
    
        return cell
    }

    @IBAction func eliminaButton(_ sender: Any) {
        rimuoviScontrinoLocal(sender: sender as AnyObject)
        }
    
    @IBAction func dettagli(_ sender: AnyObject) {
        
        let scontrino = scontriniEsatti[sender.tag]
        let vc = storyboard?.instantiateViewController(withIdentifier: "webView") as? WebViewController
              //let cell = tableView.cellForRow(at: indexPath)
             // let cellText = cell!.textLabel?.text ?? "NON RILEVATO"
              
               //vc?.meseCella = arrayMesi[indexPath.row]
               vc?.scontrino = scontrino
              //vc?.titoloCella = titoloCella
              
              self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    
    
   
    func scontriniGiusti() {
            
        if let uid = Auth.auth().currentUser?.uid {
            let campo = self.db.collection("users").document(uid)
                          
            campo.collection("scontrini").whereField("anno", isEqualTo: titoloCella).whereField("mese", isEqualTo: meseCella).getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                           
                       } else {
                        
                           for document in querySnapshot!.documents {
                            self.scontriniEsatti.append(document.data() as! [String : String])
                           }
                        print(self.scontriniEsatti)
                       }
                    self.collectionView.reloadData()
                }
        }
    }
    
    func rimuoviScontrinoLocal(sender : AnyObject){
        
        let refreshAlert = UIAlertController(title: "Elimina", message: "Cancellare lo scontrino?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
             let uid = Auth.auth().currentUser!.uid
            let scontrino = self.scontriniEsatti[sender.tag]
             let imageUrlString = scontrino["URL"]!
            print(imageUrlString)
            print(String(imageUrlString.hashValue))
            self.remove(uid: uid, URL: imageUrlString)
            self.scontriniEsatti.remove(at: sender.tag)
            self.collectionView.reloadData()
          }))

        refreshAlert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func remove(uid: String , URL : String) {
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid{
            let campo = db.collection("users").document(uid)
            let hashScontrino = String(strHash(URL))
            campo.collection("scontrini").document(hashScontrino).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    
    
    func strHash(_ str: String) -> UInt64 {
        var result = UInt64 (5381)
        let buf = [UInt8](str.utf8)
        for b in buf {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
        }
        return result
    }

    func imageTags(filenames: [String]) -> [String] {

        let tags = filenames.map { "<img src=\"\($0)\">" }

        return tags
    }


    func generateHTMLString(imageTags: [String], baseURL: String) -> String {

        // Example: just using the first element in the array
        var string = "<!DOCTYPE html><head><base href=\"\(baseURL)\"></head>\n<html>\n<body>\n"
        string = string + "\t<h2>PDF Document With Image</h2>\n"
        string = string + "\t\(imageTags[0])\n"
        string = string + "</body>\n</html>\n"

        return string
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
