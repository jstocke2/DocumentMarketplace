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
        
        let storage = Storage.storage()
                
                
                
                
                
                let storageReference = storage.reference().child("DocumentRequests/" + selectedDocKey + "/")
                    
                    storageReference.listAll { [weak self] result, error in
                      if let error = error {
                        print("Unable to list users: \(error.localizedDescription)")
                        return
                      }
                      guard let self = self, let result = result else { return }
                      self.users.removeAll(keepingCapacity: true)
                      for prefix in result.prefixes {
                        // The prefixes under storageReference.
                        // You may call listAll(completion:) recursively on them.
                        print("prefix is " + prefix.fullPath)
                        self.users.append(prefix.fullPath)
                      }
                      self.totalUsers = self.users.count
                        self.ListUsersTableView.reloadData()
                
                }
            
           
        }
        
}

extension ListUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard users.indices.contains(indexPath.row),
              let vc = storyboard?.instantiateViewController(identifier: "DownloadPDFViewController") as? DownloadPDFViewController else {
            return
        }
        selectedUser = users[indexPath.row]
        vc.selectedUser = selectedUser
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension ListUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalUsers
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].split(separator: "/").last.map(String.init) ?? users[indexPath.row]
        return cell
    }
}
    

    


