//
//  HomeViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 6/7/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var CreateDocumentRequestButton: UIButton!
    @IBOutlet weak var UploadDocumentRequestButton: UIButton!
    
    @IBOutlet weak var DownloadPDF: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadPDF.alpha = 0
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        
        db.collection("DocumentRequest").whereField("uid", isEqualTo: user?.uid).whereField("pdfUploaded", isEqualTo: "Yes").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            if (documents.count > 0){
                self.DownloadPDF.alpha = 1
            }
            
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
