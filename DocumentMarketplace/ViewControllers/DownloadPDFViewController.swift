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
    var documentRequestKeys = [String]()
    var fileNames = [String]()
    var filestoReqdict = [String:String]()
    var selectedUser:String = String()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadPDFTableView.dataSource = self
        DownloadPDFTableView.delegate = self
        
        let storage = Storage.storage()
                
                
                
                
                
                let storageReference = storage.reference().child(selectedUser)
                    //print("Key is:  " + key)
                    
                    storageReference.listAll { [weak self] result, error in
                      if let error = error {
                        print("Unable to list documents: \(error.localizedDescription)")
                        return
                      }
                      guard let self = self, let result = result else { return }
                      self.fileNames = result.items.map(\.name)
                      self.DownloadPDFTableView.reloadData()
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
        guard fileNames.indices.contains(indexPath.row),
              let vc = self.storyboard?.instantiateViewController(identifier: "BuyPDFVC") as? BuyPDFViewController else {
            return
        }
        //var count = indexPath.row - difference
        //vc?.key = documentRequestKeys[count]
        //vc?.key = filestoReqdict[fileNames[indexPath.row]]!
        vc.fileName = fileNames[indexPath.row]
        vc.selectedUser = selectedUser
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension DownloadPDFViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
}
