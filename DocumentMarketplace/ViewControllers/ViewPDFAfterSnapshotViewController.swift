//
//  ViewPDFAfterSnapshotViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/10/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import PDFKit
import FirebaseStorage
import FirebaseFirestore

class ViewPDFAfterSnapshotViewController: UIViewController {
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var confirmUploadButton: UIButton!
    
    @IBOutlet weak var confirmUploadButtonCamera: UIButton!
    @IBOutlet weak var CancelUploadButton: UIButton!
    
    var images = [UIImage]()
    var selectedDocKey = String()
    let pdfDocument = PDFDocument()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let images = CameraViewController.images
        // convert to PDF
        
        for i in 0 ..< images.count {
            let image = images[i]
              let pdfPage = PDFPage(image: image)
              pdfDocument.insert(pdfPage!, at: i)
        }
        
        pdfView.document = pdfDocument
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        
        
        //view.addSubview(pdfView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelUploadButtonTapped(_ sender: Any) {
        transistionToHome()
        
    }
    @IBAction func confirmUploadButtonTapped(_ sender: Any) {
        let uuid = UUID().uuidString
        // Create a root reference
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // File located on disk
        let pdfData = pdfDocument.dataRepresentation()
        
        // Create a reference to the file you want to upload
        let pdfRef = storageRef.child("DocumentRequests/" + selectedDocKey + "/" + uuid + ".pdf")
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = pdfRef.putData(pdfData!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          pdfRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        
        let db = Firestore.firestore()
        db.collection("DocumentRequest").document(selectedDocKey).updateData(["pdfUploaded": "Yes"])
        
        transistionToHome()
        
        

        
    }
    
    func transitionToCamera(){
        let cameraViewController = storyboard?.instantiateViewController(identifier: "CameraViewController") as? CameraViewController
        
        
        view.window?.rootViewController = cameraViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func confirmButtonCameraTapped(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("DocumentRequest/").document(selectedDocKey).updateData(["pdfUploaded":"Yes"])
        transitionToCamera()
    }
    func transistionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
