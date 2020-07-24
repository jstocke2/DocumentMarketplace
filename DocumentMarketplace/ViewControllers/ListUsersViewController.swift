//
//  ListUsersViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/20/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ListUsersViewController: UIViewController {

    @IBOutlet weak var ListUsersTableView: UITableView!
    var totalUsers = 0
    var selectedUser:String = String()
    var selectedDocKey:String = String()
    var users = [String]()
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        ListUsersTableView.register(ListDocsTableViewCell.nib(), forCellReuseIdentifier: ListDocsTableViewCell.identifier)
        
        ListUsersTableView.dataSource = self
        ListUsersTableView.delegate = self
        
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        let storage = Storage.storage()
                
                
                
                
                
                let storageReference = storage.reference().child("DocumentRequests/" + selectedDocKey + "/")
                    
                    storageReference.listAll { (result, error) in
                      if let error = error {
                        print(error)
                      }
                      for prefix in result.prefixes {
                        // The prefixes under storageReference.
                        // You may call listAll(completion:) recursively on them.
                        print("prefix is " + prefix.fullPath)
                        self.totalUsers = result.prefixes.count
                        self.users.append(prefix.fullPath)
                      }
                      for item in result.items {
                        // The items under storageReference.
                        self.totalUsers =  result.items.count
                        print("User is:  " + item.name)
                      }
                        self.ListUsersTableView.reloadData()
                        self.ListUsersTableView.endUpdates()
                
                }
            
           
        }
        
}

extension ListUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "DownloadPDFViewController") as?
            DownloadPDFViewController
        vc?.selectedUser = selectedUser
        
        
        navigationController?.pushViewController(vc!, animated: true)
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
        
    }
}


extension ListUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalUsers
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "User" + String(counter)
        counter+=1
        return cell
    }
}
    

    


