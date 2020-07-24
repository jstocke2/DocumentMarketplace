//
//  DownloadPDFViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/11/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class DownloadPDFViewController: UIViewController {

    @IBOutlet weak var DownloadPDFTableView: UITableView!
    var documentRequestKeys = [String()]
    var fileNames = [String]()
    var filestoReqdict = [String:String]()
    var selectedUser:String = String()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentRequestKeys.remove(at: 0)
        
        DownloadPDFTableView.dataSource = self
        DownloadPDFTableView.delegate = self
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        let storage = Storage.storage()
                
                
                
                
                
                let storageReference = storage.reference().child(selectedUser)
                    //print("Key is:  " + key)
                    
                    storageReference.listAll { (result, error) in
                      if let error = error {
                        print(error)
                      }
                      for prefix in result.prefixes {
                        // The prefixes under storageReference.
                        // You may call listAll(completion:) recursively on them.
                      }
                      for item in result.items {
                        // The items under storageReference.
                        //self.difference = result.items.count - documents
                        self.fileNames.append(item.name)
                        print("DocName is:  " + item.name)
                      }
                        
                        self.DownloadPDFTableView.reloadData()
                        self.DownloadPDFTableView.endUpdates()
                }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DownloadPDFViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "BuyPDFVC") as?
        BuyPDFViewController
        //var count = indexPath.row - difference
        //vc?.key = documentRequestKeys[count]
        //vc?.key = filestoReqdict[fileNames[indexPath.row]]!
        vc?.fileName = fileNames[indexPath.row]
        vc?.selectedUser = selectedUser
        navigationController?.pushViewController(vc!, animated: true)
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
}


extension DownloadPDFViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Document" + String(counter)
        counter+=1
        return cell
    }
}
