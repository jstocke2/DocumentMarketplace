//
//  DropdownTableViewCell.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/3/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown

class DropdownTableViewCell: UITableViewCell {
    @IBOutlet weak var CountiesListDropdown: DropDown!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let db = Firestore.firestore()
        
        // get the counties and state from firebase and populate dropdown
        db.collection("Counties").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                
                let county = document.get("County") as! String
                let state  = document.get("State")  as! String
                let countyState = county + ", " + state
                
                self.CountiesListDropdown.optionArray.append(countyState)
                }
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
