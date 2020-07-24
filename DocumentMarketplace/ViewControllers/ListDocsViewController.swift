//
//  ListDocsViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 6/8/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import iOSDropDown
import Firebase
import FirebaseFirestore

class ListDocsViewController: UIViewController  {
    
    @IBOutlet weak var ListCountiesDropdown: DropDown!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    

    @IBOutlet var ListCountiesTableView: UITableView!
    var docReqs = [docRequest]()
    var numberofDocReq = 0
    var docKeys = [String]()
    var selectedDocKey = String()
    
    struct docRequest {
        var typeOfDocument:String
        var address:String
        var name:String
        var pageNumber:String
        var Parcel:String
        var Volume:String
        var Description:String
        
        init() {
            typeOfDocument = "No Data"
            address = "No Data"
            name = "No Data"
            pageNumber = "No Data"
            Parcel = "No Data"
            Volume = "No Data"
            Description = "No Data"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListCountiesTableView.register(ListDocsTableViewCell.nib(), forCellReuseIdentifier: ListDocsTableViewCell.identifier)
        
        ListCountiesTableView.dataSource = self
        ListCountiesTableView.delegate = self
        
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
            
            var selectedCountyArray = selectedCountyandState.split(separator: ",")
            var selectedCounty = selectedCountyArray[0]
            db.collection("DocumentRequest").whereField("County", isEqualTo: selectedCounty).getDocuments{(snapshot, error) in
                if error != nil{
                    print(error)
                }
                else{
                    
                    self.numberofDocReq = snapshot?.documents.count ?? 0
                    self.docReqs.removeAll(keepingCapacity: false)
                    for document in (snapshot?.documents)!{
                        var currentDocReq = docRequest()
                        self.docKeys.append(document.documentID)
                        
                        if let documentType = document.data()["typeofDocument"] as? String{
                            print(documentType)
                            currentDocReq.typeOfDocument = documentType
                        }
                        
                        if let address = document.data()["address"] as? String{
                            print(address)
                            currentDocReq.address = address
                        }
                        if let name = document.data()["name"] as? String{
                            print(name)
                            currentDocReq.name = name
                        }
                        if let pageNumber = document.data()["pagenumber"] as? String{
                            print(pageNumber)
                            currentDocReq.pageNumber = pageNumber
                        }
                        if let parcel = document.data()["parcel"] as? String{
                            print(parcel)
                            currentDocReq.Parcel = parcel
                        }
                        if let volume = document.data()["volume"] as? String{
                            print(volume)
                            currentDocReq.Volume = volume
                        }
                        if let description = document.data()["description"] as? String{
                            print(description)
                            currentDocReq.Description = description
                        }
                        self.docReqs.append(currentDocReq)
                        
                    }
                    self.ListCountiesTableView.reloadData()
                    self.ListCountiesTableView.endUpdates()
                }
                
                
                
            }
            
            
            
            
            
            //[ListDocsViewController.tableView reloadData]
            
            
        }
        
        
        
        
            
        

    }
    
}



extension ListDocsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDocKey = docKeys[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "CameraViewController") as?
            CameraViewController
        vc?.selectedDocKey = selectedDocKey
        
        
        navigationController?.pushViewController(vc!, animated: true)
        print(selectedDocKey)
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
        //transistionToCamera()
    }
}


extension ListDocsViewController: UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberofDocReq
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = ListCountiesTableView.dequeueReusableCell(withIdentifier: "ListDocsTableViewCell", for: indexPath) as! ListDocsTableViewCell
        
        customCell.configure(with: docReqs[indexPath.row].typeOfDocument, addressValue: docReqs[indexPath.row].address, nameValue: docReqs[indexPath.row].name, pageNumberValue: docReqs[indexPath.row].pageNumber, parcelValue: docReqs[indexPath.row].Parcel, volumeValue: docReqs[indexPath.row].Volume, descriptionValue: docReqs[indexPath.row].Description)
        
        //numberofDocReq = 0
        
        
        return customCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCounties", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
}


