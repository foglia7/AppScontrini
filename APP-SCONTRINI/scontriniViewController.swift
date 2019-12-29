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
        
        
        print(scontriniEsatti)
        // Configure the cell...
       let scontrino = scontriniEsatti[indexPath.row]
         
       
        let imageUrlString = scontrino["URL"]!
             let imageUrl:URL = URL(string: imageUrlString)!
              /*
             // Start background thread so that image loading does not make app unresponsive
              DispatchQueue.global(qos: .userInitiated).async {
                 
                 let imageData:NSData = NSData(contentsOf: imageUrl)!
                let imageView = UIImageView(frame: CGRect(x:0, y:0, width:200, height:200))
                
                DispatchQueue.main.async {
                               let image = UIImage(data: imageData as Data)
                               imageView.image = image
                               imageView.contentMode = UIView.ContentMode.scaleAspectFit
                               self.view.addSubview(imageView)
                    
                }
                
                cell.scontrinoImageView = imageView
        }  */
        cell.scontrinoImageView.load(url: imageUrl)

        cell.cfLabel.text = scontrino["CF"]
    cell.dataLabel.text = scontrino["data"]
        cell.totaleLabel.text = scontrino["totale"]
        cell.detraibileLabel.text = scontrino["detraibile"]
        
      
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
        //cell.layer.shadowColor = UIColor.gray.cgColor
        //cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        //cell.layer.shadowRadius = 4.0
        //cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.backgroundColor = UIColor.init(red: 45, green: 133, blue: 65, alpha: 1.00).self
        
        
        return cell
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
 
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
