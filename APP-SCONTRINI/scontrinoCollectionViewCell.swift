//
//  scontrinoCollectionViewCell.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 21/12/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class scontrinoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scontrinoImageView: UIImageView!
    
    @IBOutlet weak var cfLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var totaleLabel: UILabel!
    @IBOutlet weak var detraibileLabel: UILabel!
    @IBOutlet weak var eliminaBottone: UIButton!
    
    @IBAction func minchia(_ sender: Any) {
        print("sicuro????")
        //rimuoviScontrino()
    }
    
}
