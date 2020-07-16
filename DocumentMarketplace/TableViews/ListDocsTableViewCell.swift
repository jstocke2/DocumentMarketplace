//
//  ListDocsTableViewCell.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/6/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit

class ListDocsTableViewCell: UITableViewCell {

    @IBOutlet weak var TypeofDocValue: UILabel!
    
    @IBOutlet weak var AddressValue: UILabel!
    
    @IBOutlet weak var NameValue: UILabel!
    
    @IBOutlet weak var PageNumberValue: UILabel!
    
    @IBOutlet weak var ParcelValue: UILabel!
    @IBOutlet weak var VolumeValue: UILabel!
    
    @IBOutlet weak var DescriptionValue: UILabel!
    
    
    
    
    
    static let identifier = "ListDocsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ListDocsTableViewCell", bundle: nil)
    }
    
    public func configure(with  typeOfDocumentValue:String, addressValue:String, nameValue:String, pageNumberValue:String, parcelValue:String, volumeValue:String, descriptionValue:String){
        TypeofDocValue.text = typeOfDocumentValue
        AddressValue.text = addressValue
        NameValue.text = nameValue
        PageNumberValue.text = pageNumberValue
        ParcelValue.text = parcelValue
        VolumeValue.text = volumeValue
        DescriptionValue.text = descriptionValue
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
