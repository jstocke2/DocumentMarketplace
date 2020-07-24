//
//  ListDownloadedDocReqsViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/21/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class ListDownloadedDocReqsViewController: UIViewController {
    @IBOutlet weak var ListDocReqsTableView: UITableView!
    
    
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
        
        
        ListDocReqsTableView.register(ListDocsTableViewCell.nib(), forCellReuseIdentifier: ListDocsTableViewCell.identifier)
        
        ListDocReqsTableView.dataSource = self
        ListDocReqsTableView.delegate = self
        
        
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        
        
        db.collection("DocumentRequest").whereField("uid", isEqualTo: user?.uid).getDocuments{(snapshot, error) in
            if error != nil{
                print(error)
            }
            else{
                
                self.numberofDocReq = snapshot?.documents.count ?? 0
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
                self.ListDocReqsTableView.reloadData()
                self.ListDocReqsTableView.endUpdates()
            }
            
            
            
        }
        
        
        
        
        
    }
    
    

}



extension ListDownloadedDocReqsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDocKey = docKeys[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "ListUsersViewController") as?
            ListUsersViewController
        vc?.selectedDocKey = selectedDocKey
        
        
        navigationController?.pushViewController(vc!, animated: true)
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
}


extension ListDownloadedDocReqsViewController: UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberofDocReq
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = ListDocReqsTableView.dequeueReusableCell(withIdentifier: "ListDocsTableViewCell", for: indexPath) as! ListDocsTableViewCell
        
        customCell.configure(with: docReqs[indexPath.row].typeOfDocument, addressValue: docReqs[indexPath.row].address, nameValue: docReqs[indexPath.row].name, pageNumberValue: docReqs[indexPath.row].pageNumber, parcelValue: docReqs[indexPath.row].Parcel, volumeValue: docReqs[indexPath.row].Volume, descriptionValue: docReqs[indexPath.row].Description)
        
        //numberofDocReq = 0
        
        return customCell
    }
}

