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
        db.collection("Counties").getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                print("Error getting counties: \(error.localizedDescription)")
                return
            }

            guard let self = self else { return }
            self.CountiesListDropdown.optionArray = querySnapshot?.documents.compactMap { document in
                guard let county = document.get("County") as? String,
                      let state = document.get("State") as? String else {
                    return nil
                }
                return "\(county), \(state)"
            } ?? []
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
