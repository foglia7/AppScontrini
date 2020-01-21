//
//  PhotoViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 26/11/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import TesseractOCR
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var formCF: UITextField!
    
    @IBOutlet weak var textParsato: UILabel!
    
    @IBOutlet weak var formTotale: UITextField!
    
    @IBOutlet weak var formDetraibile: UITextField!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
     
    var imagePicker : UIImagePickerController?
   
    @IBAction func postImage(_ sender: Any) {
        
        if (formCF.text!.isEmpty) || (formTotale.text!.isEmpty) && (formDetraibile.text!.isEmpty){
             self.showToast(message: "Riempire tutti i campi")
        }else {
        
        guard let image = imageView.image, let data = image.jpegData(compressionQuality: 1.0) else {
            
            print("errore errore errore!")
            return
        }
        
        let stringa = self.datePicker.date.description
                                                       
                                             let dateFormatterGet = DateFormatter()
                                             dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss '+0000'"

                                             let dateFormatterYear = DateFormatter()
                                             dateFormatterYear.dateFormat = "yyyy"

                                             let dateFormatterMonth = DateFormatter()
                                             dateFormatterMonth.dateFormat = "MM"

                                             let dateFormatterDay = DateFormatter()
                                             dateFormatterDay.dateFormat = "dd"
                               
                                           var anno = " "
                                           var mese = " "
                                           var giorno = " "

                                             if let date = dateFormatterGet.date(from: stringa) {
                                                 anno = dateFormatterYear.string(from: date)
                                                 mese = dateFormatterMonth.string(from: date)
                                                 giorno = dateFormatterDay.string(from: date)
                                             } else {
                                                print("There was an error decoding the string")
                                             }
        
        let imageName = UUID().uuidString
        var urlScontrino = " "
       
        let imageReference = Storage.storage().reference().child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if err != nil {
                print("errore errore errore!")
                return
            }
            imageReference.downloadURL { (url, err) in
                if err != nil {
                    print("errore errore errore!")
                    return
                }
                
                guard let url = url else {
                    print("errore errore errore!")
                    return
                }
                
                urlScontrino = url.absoluteString
                let hashScontrino = String(self.strHash(urlScontrino))
                print(urlScontrino)
                print(String(self.strHash(urlScontrino)))
                print("questo è l'url: \(urlScontrino)")
                
                let db = Firestore.firestore()
                if let uid = Auth.auth().currentUser?.uid {
                        
                    let campo = db.collection("users").document(uid)
                                      
                             campo.collection("scontrini").document(hashScontrino).setData([
                                 "URL": urlScontrino ,
                                 "data": self.datePicker.date.description,
                                 "detraibile": self.formDetraibile.text ?? " ",
                                 "totale" : self.formTotale.text ?? "  ",
                                 "CF" : self.formCF.text ?? "  ",
                                 "anno" : anno,
                                 "mese" : mese,
                                 "giorno" : giorno
                                 
                             ]) { err in
                                 if let err = err {
                                     print("Error writing document: \(err)")
                                 } else {
                                     print("Document successfully written!")
                                    self.showToast(message: "Documento Aggiunto!")
                                    self.resetView()
                                
                               }
                             }

                     }
            }
            
    }
        }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
       
     
                  }
        
    
    
    @IBAction func selectPhotoTapped(_ sender: Any) {
        if imagePicker != nil {
        imagePicker!.sourceType = .photoLibrary
        present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        if imagePicker != nil {
        imagePicker!.sourceType = .camera
        present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             
             let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                 imageView.image = image
                 print("Ho cambiato le immagini")
       
            if let tesseract = G8Tesseract(language: "ita"){
                tesseract.delegate = self
                tesseract.image = image
                tesseract.recognize()
                
            let testoScontrino = tesseract.recognizedText
                
                print(testoScontrino!)
           
                trovaTotale(testo: testoScontrino ?? "TOTALE non trovato ")
                trovaDetraibile(testo: testoScontrino ?? "DETRAIBILE non trovato")
                //trovaData(testo: testoScontrino ?? "DATA NON TROVATA")
                //trovaCf(testo: testoScontrino ?? "CF NON TROVATO" )
                
                let data = matches(for: "\\b(?:20)?(\\d\\d)[-./](0?[1-9]|1[0-2])[-./](3[0-1]|[1-2][0-9]|0?[1-9])\\b", in: testoScontrino ?? "data")
                setData(testo: data)
                
                print(data)
                
                
                
                let cf = matches(for: "\\b(?:[A-Z][AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}(?:[\\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[15MR][\\dLMNP-V]|[26NS][0-8LMNP-U])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM]|[AC-EHLMPR-T][26NS][9V])|(?:[02468LNQSU][048LQU]|[13579MPRTV][26NS])B[26NS][9V])(?:[A-MZ][1-9MNP-V][\\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]\\b", in: testoScontrino ?? "cf non trovato")
                setCf(testo: cf)
                
                print(cf)
                
        
        }
                 dismiss(animated: true, completion: nil)
         }
    
    func trovaTotale(testo: String) {
        
        let arrayTesto = testo.components(separatedBy: "\n")
        
        for index in arrayTesto {
            
            if (index.contains("TOTALE")) || (index.contains("IMPORTO")) || (index.contains("TOT.")){
                
                let tot = matches(for: "[-+]?[0-9]*\\.?[0-9]+", in: index )
                let totfinale = tot.joined()
                
                print("questo è il totale rilevato : \(tot) ")
                formTotale.text = totfinale
                }
        }
}
    
    func trovaDetraibile(testo: String) {
         
            let arrayTesto = testo.components(separatedBy: "\n")
            
            print(arrayTesto)
            
            for index in arrayTesto {
                
                if (index.contains("detraibile")) || (index.contains("Medicinali")){
                    
                    let detra = matches(for: "[-+]?[0-9]*\\.?[0-9]+", in: index )
                                   let detrafinale = detra.joined()
                                   
                                   print("questo è il totale rilevato : \(detra) ")
                                   formTotale.text = detrafinale
      
                           
                }
            }
    }
    
    func setCf (testo:[String]){
         
        let cf = testo
        print(cf)
        let joined = cf.joined(separator: " ")
        
        formCF.text = joined
        
        }


    func setData(testo:[String]) {
        
        let data = testo
        let array = data
        let joined = array.joined(separator: " ")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        if let startDate = formatter.date(from: joined) {
            //print(startDate)
            datePicker.date = startDate
        }
        }
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-self.view.frame.size.width/4, y: self.view.frame.size.height-210, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        // toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func resetView(){
        self.formCF.text = nil
        self.formTotale.text = nil
        self.formDetraibile.text = nil
        let yourImage: UIImage = UIImage(named: "bill")!
        self.imageView.image = yourImage
        self.datePicker.date = Date()
    }
    func strHash(_ str: String) -> UInt64 {
           var result = UInt64 (5381)
           let buf = [UInt8](str.utf8)
           for b in buf {
               result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
           }
           return result
       }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
  
    
}
  
