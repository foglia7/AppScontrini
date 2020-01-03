//
//  ProvaBottoneDentroCella.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 01/01/2020.
//  Copyright © 2020 Mhscio. All rights reserved.
//

import UIKit
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


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
        print("sei proprio scemo")
        rimuoviScontrinoLocal(sender: sender as AnyObject)
        
    }
    
    @IBAction func esportaButton(_ sender: Any) {
        esportaPDF(sender: sender as AnyObject)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
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
            print("eeskhlsaoi asdop jefnoa sapodie fejiwp aèpw kvlmsddwio awij f")
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
    
    func esportaPDF(sender : AnyObject){
         // 1. Create a print formatter
        //let uid = Auth.auth().currentUser!.uid
        let scontrino = scontriniEsatti[sender.tag]
        //let imageUrlString = scontrino["URL"]!
        let imageUrlString = "https://1.bp.blogspot.com/--M8WrSToFoo/VTVRut6u-2I/AAAAAAAAB8o/dVHTtpXitSs/s1600/URL.png"
        let imageArr = imageUrlString.components(separatedBy: " ")
        print(imageArr)
       // let imageUrlString = "https://1.bp.blogspot.com/--M8WrSToFoo/VTVRut6u-2I/AAAAAAAAB8o/dVHTtpXitSs/s1600/URL.png"
        //print (imageUrlString)
        let data = scontrino["data"]!
        let totale = scontrino["totale"]!
        let detraibile = scontrino["detraibile"]!
        let url = "IMMAGINE SCONTRINO"
        var html = "<html><head><title>Page Title</title><h1>Scontrino ID : 231893409324802</h1></head><body><img src='\(imageUrlString)' alt='\(url)' height='400px' width='500px'><article><h1>DATI SCONTRINO</h1><p><b>LINK : </b>\(imageUrlString) </p><p><b>DATA : </b>\(data) </p><p><b>CF : </b> cf scontrino </p><p><b>TOTALE : </b> \(totale) </p><p><b>DETRAIBILE : </b> \(detraibile) </p></article></body></html>" // create some text as the body of the PDF with html.
        let imgTag = imageTags(filenames: imageArr)
        let htmlImg = generateHTMLString(imageTags: imgTag, baseURL: imageUrlString)
        
        html = html + htmlImg
        
        // let formatter  = UIViewPrintFormatter()
        // createPDF(html: htmlImg, formmatter: formatter, filename: "scontrino")
        
        

           let fmt = UIMarkupTextPrintFormatter(markupText: html)

           // 2. Assign print formatter to UIPrintPageRenderer

           let render = UIPrintPageRenderer()
           render.addPrintFormatter(fmt, startingAtPageAt: 0)

           // 3. Assign paperRect and printableRect

           let page = CGRect(x: 10, y: 10, width: 595.2, height: 841.8) // A4, 72 dpi, x and y are horizontal and vertical margins
           let printable = page.insetBy(dx: 0, dy: 0)

           render.setValue(NSValue(cgRect: page), forKey: "paperRect")
           render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

           // 4. Create PDF context and draw

           let pdfData = NSMutableData()
           UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

           for i in 1...render.numberOfPages {

               UIGraphicsBeginPDFPage();
               let bounds = UIGraphicsGetPDFContextBounds()
               render.drawPage(at: i - 1, in: bounds)
           }

           UIGraphicsEndPDFContext();

           // 5. Save PDF file

       // let path = "\(NSTemporaryDirectory())\(title).pdf"
        //   pdfData.write(toFile: path, atomically: true)
          let activityViewController = UIActivityViewController(activityItems: ["Name To Present to User", pdfData], applicationActivities: nil)
          present(activityViewController, animated: true, completion: nil)
        
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


    func createPDF(html: String, formmatter: UIViewPrintFormatter, filename: String){
        // From: https://gist.github.com/nyg/b8cd742250826cb1471f

        print("createPDF: \(html)")

        // 2. Assign print formatter to UIPrintPageRenderer
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(formmatter, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)

        for i in 1...render.numberOfPages {

            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Save PDF file
        /*
        let path = "\(NSTemporaryDirectory())\(filename).pdf"
        pdfData.write(toFile: path, atomically: true)
        print("open \(path)")
*/
        let activityViewController = UIActivityViewController(activityItems: ["Name To Present to User", pdfData], applicationActivities: nil)
          present(activityViewController, animated: true, completion: nil)
        
    }
}
