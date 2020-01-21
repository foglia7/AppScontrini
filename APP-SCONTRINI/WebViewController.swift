//
//  WebViewController.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 06/01/2020.
//  Copyright © 2020 Mhscio. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var scontrino:[String : String] = [" " : " "]
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func salvaButton(_ sender: Any) {
        var image :UIImage?
        
               let currentLayer = UIApplication.shared.keyWindow!.layer
               let currentScale = UIScreen.main.scale
               UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
               guard let currentContext = UIGraphicsGetCurrentContext() else {return}
               currentLayer.render(in: currentContext)
               image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               guard let img = image else { return }
               UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        
                showToast(message: "Immagine salvata in Foto")
               //esportaPDF(sender: sender as AnyObject)
}
    override func viewDidLoad() {
        super.viewDidLoad()
            print(scontrino)
            dispScontrino()
        // Do any additional setup after loading the view.
    }
    
    func dispScontrino(){
        let imageUrlString = scontrino["URL"]!
        var data = scontrino["data"]!
        let dataArr = data.components(separatedBy: " ")
        data = dataArr[0]
        let totale = scontrino["totale"]!
        let detraibile = scontrino["detraibile"]!
        let cf = scontrino["CF"]!
        let url = imageUrlString
        
        let html = "<html style='font-family:verdana;'><head><title>Page Title</title><h1><font size=10% >Scontrino ID : 231893409324802</font></h1></head><body><p style='text-align:center;'><img src='\(imageUrlString)' alt='\(url)' height='900px' width='800px' object-fit: contain></p><article><h1><p style='text-align:center;'><font size=10% >DATI SCONTRINO</p></h1><p><b>DATA : </b>\(data) </p><p><b>CF : </b> \(cf)</p><p><b>TOTALE : </b> \(totale) € </p><p><b>DETRAIBILE : </b> \(detraibile) € </p></font></article></body></html>"
        
     
        webView.loadHTMLString(html, baseURL: nil )
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


}
