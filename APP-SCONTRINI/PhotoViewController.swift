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
                print("errore errore errore 1!")
                print(err.debugDescription)
                return
            }
            imageReference.downloadURL { (url, err) in
                if err != nil {
                    print("errore errore errore 2!")
                    return
                }
                
                guard let url = url else {
                    print("errore errore errore 3!")
                    return
                }
                
                urlScontrino = url.absoluteString
                print("questo è l'url: \(urlScontrino)")
                
                let db = Firestore.firestore()
                
              
                
                
                           
                     if let uid = Auth.auth().currentUser?.uid {
                        
                        
                       
                         
                         let campo = db.collection("users").document(uid)
                                      
                             campo.collection("scontrini").document(imageName).setData([
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
       
        //imagePicker?.allowsEditing = true
       
     
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
                
                let data = matches(for: "\\b(?:20)?(\\d\\d)[-./](0?[1-9]|1[0-2])[-./](3[0-1]|[1-2][0-9]|0?[1-9])\\b", in: testoScontrino ?? "zio")
                setData(testo: data)
                
                print(data)
                
                let cf = matches(for: "\\b(?:[A-Z][AEIOU][AEIOUX]|[B-DF-HJ-NP-TV-Z]{2}[A-Z]){2}(?:[\\dLMNP-V]{2}(?:[A-EHLMPR-T](?:[04LQ][1-9MNP-V]|[15MR][\\dLMNP-V]|[26NS][0-8LMNP-U])|[DHPS][37PT][0L]|[ACELMRT][37PT][01LM]|[AC-EHLMPR-T][26NS][9V])|(?:[02468LNQSU][048LQU]|[13579MPRTV][26NS])B[26NS][9V])(?:[A-MZ][1-9MNP-V][\\dLMNP-V]{2}|[A-M][0L](?:[1-9MNP-V][\\dLMNP-V]|[0L][1-9MNP-V]))[A-Z]\\b", in: testoScontrino ?? "cf non trovato")
                setCf(testo: cf)
                
                print(cf)
                
        
        }
                 dismiss(animated: true, completion: nil)
         }
    
    func trovaTotale(testo: String) {
        var count = 0
        var totale : [Int] = [00,00]
        
        let arrayTesto = testo.components(separatedBy: "\n")
        
        //print(arrayTesto)
        
        for index in arrayTesto {
            
            if (index.contains("TOTALE")) || (index.contains("IMPORTO")) || (index.contains("TOT.")){
                
                let string = index
                let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
                for item in stringArray {
                    if let number = Int(item) {
                        while count < 1 {
                        totale[count] = number
                        print("number: \(number)")
                            count = count + 1
                            
                        }
                        
                    }
                }
                
              
                count = 0
                       
            }
            
            let stringArray2 = totale.map { String($0) }
            let string2 = stringArray2.joined(separator: ".")
                             
                          formTotale.text = string2
                          
        }
        //INSERIRE VALORE IN TEXT FIELD
}
    
        func trovaDetraibile(testo: String) {
            var count = 0
            var totale : [Int] = [00,00]
            
            let arrayTesto = testo.components(separatedBy: "\n")
            
            print(arrayTesto)
            
            for index in arrayTesto {
                
                if (index.contains("detraibile")) || (index.contains("Medicinali")){
                    
                    let string = index
                    let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
                    for item in stringArray {
                        if let number = Int(item) {
                            
                            totale[count] = number
                            print("number: \(number)")
                            count = count + 1
                            
                        }
                    }
                    
                count = 0
                           
                }
                
                let stringArray2 = totale.map { String($0) }
                let string2 = stringArray2.joined(separator: ".")
                                 
            formDetraibile.text = string2
                              
            }
            //INSERIRE VALORE IN TEXT FIELD
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
    
  
 
    
}

  
