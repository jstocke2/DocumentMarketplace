//
//  CreateDocViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 6/29/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import iOSDropDown

class CreateDocViewController: UIViewController {
    @IBOutlet weak var TypeofDocumentText: UITextField!
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var VolumeText: UITextField!
    
    @IBOutlet weak var ListCountiesDropdown: DropDown!
    @IBOutlet weak var PageNumberText: UITextField!
    @IBOutlet weak var ParcelText: UITextField!
    @IBOutlet weak var AddressText: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var ErrorText: UILabel!
    
    var selectedCounty = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        let db = Firestore.firestore()
        
            // retrieve the counties and listen for changes
            
            db.collection("Counties").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let county = document.get("County") as! String
                    let state  = document.get("State")  as! String
                    let countyState = county + ", " + state
                    
                    self.ListCountiesDropdown.optionArray.append(countyState)
                    }
                }
            }
        
        ListCountiesDropdown.didSelect { (selectedCountyandState, index, id) in
            
            let selectedCountyArray = selectedCountyandState.split(separator: ",")
            self.selectedCounty = String(selectedCountyArray[0])
            
        }
    }
    
    func validateFields() -> String? {
    // check for required fields filled in
        if TypeofDocumentText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            NameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            Description.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            selectedCounty == ""
        {
            return "Please fill in all fields."
        }
            return nil
    }
    
    func showError(message:String)
    {
        ErrorText.text = message
        ErrorText.alpha = 1
    }
    
    func transistionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            showError(message: error!)
            
        }
        
        else{
            // create cleaned version of data
            let typeofDocument = TypeofDocumentText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = NameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let volume = VolumeText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pageNumber = PageNumberText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let parcel = ParcelText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let address = AddressText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let user = Auth.auth().currentUser
            
            let db = Firestore.firestore()
            
            db.collection("DocumentRequest").addDocument(data: ["TypeofDocument": typeofDocument, "name":name, "uid":user?.uid, "volume":volume,
                                                                "pagenumber":pageNumber, "parcel":parcel, "description": Description.text, "address":address, "County": selectedCounty, "pdfUploaded": "No"]){ (error) in
                    if error != nil {
                        self.showError(message: "Error saving Document Request.")
                    }
                }
            
            transistionToHome()
        
        }
    }
    
        
        func setUpElements(){
            //Hide the error Label
            ErrorText.alpha = 0
            
            // style elements
            
            Utilities.styleTextField(TypeofDocumentText)
            Utilities.styleTextField(NameText)
            Utilities.styleTextField(VolumeText)
            Utilities.styleTextField(PageNumberText)
            Utilities.styleTextField(ParcelText)
            Utilities.styleTextField(AddressText)
            Utilities.styleFilledButton(SubmitButton)
            
        }
    
    
    
    
    



}
