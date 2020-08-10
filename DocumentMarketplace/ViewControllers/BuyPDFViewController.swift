//
//  BuyPDFViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/11/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import PDFKit
import FirebaseStorage
import FirebaseFirestore

class BuyPDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    var fileName = String()
    var key = String()
    var document = PDFDocument()
    var selectedUser:String = String()

    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var BuyPDFButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a reference with an initial file path and name
        // Create a reference to the file you want to download
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        let docRef = storageRef.child(selectedUser + "/" + fileName)

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        docRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            // Data for "images/island.jpg" is returned
            guard var watermarkDocument = PDFDocument(data: data!)else{
                print("Unable to Create Watermarked PDF")
                return
            }
            self.document = PDFDocument(data:data!)!
            
            for i in 0 ..< watermarkDocument.pageCount {
                // `page` is of the type `PDFPage`.
                let page = watermarkDocument.page(at: 0)!
                // Extract the crop box of the PDF. We need this to create an appropriate graphics context.
                let bounds = page.bounds(for: .cropBox)

                // Set up a `UIGraphicsImageRenderer` to handle creation of a watermarked image.
                let renderer = UIGraphicsImageRenderer(bounds: bounds, format: UIGraphicsImageRendererFormat.default())

                // Call the `image(actions:)` method of `UIGraphicsImageRenderer`. This method takes a block in which
                // you can do any drawing you want and get a `UIImage` with the result.
                var image = renderer.image { (context) in
                    // We transform the CTM to match the PDF's coordinate system, but only long enough to draw the page.
                    context.cgContext.saveGState()
                    

                    context.cgContext.translateBy(x: 0, y: bounds.height)
                    context.cgContext.concatenate(CGAffineTransform.init(scaleX: 1, y: -1))
                    page.draw(with: .cropBox, to: context.cgContext)

                    context.cgContext.restoreGState()

                    context.cgContext.translateBy(x: 50, y: 0)
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 50),
                        .foregroundColor: UIColor.red.withAlphaComponent(0.5)
                    ]
                    
                    let text = "Sample Document! Sample Document! Sample Document! Sample Document! Sample Document! Sample Document! Sample Document! Sample Document!"
                        // Draw the text with the attributes from above.
                        text.draw(with: bounds, options: .usesLineFragmentOrigin, attributes: attributes, context: NSStringDrawingContext())
                    }

                    // Create a new `PDFPage` with the image that was generated above.
                    let newPage = PDFPage(image: image)!
                    image = UIImage()
                    // The annotations need to be transferred from the old page to the new one.
                    for annotation in page.annotations {
                        newPage.addAnnotation(annotation)
                    }
                

                    // Insert the new page at index 0.
                    watermarkDocument.insert(newPage, at: i)
                    // Remove the page at index 1. This is the page that was at index 0 but got moved.
                    watermarkDocument.removePage(at: i + 1)
            }
            
            
            
            self.pdfView.document = watermarkDocument
            self.pdfView.displayMode = .singlePageContinuous
            self.pdfView.autoScales = true
            self.pdfView.displayDirection = .vertical
            
          }
        }
    }
    
    @IBAction func BuyPDFButtonTapped(_ sender: Any) {
        let vc = CheckoutViewController()
        self.view.window?.rootViewController = vc
        
        
        //let activityViewController = UIActivityViewController(activityItems: ["Downloaded Document", document.dataRepresentation()], applicationActivities: nil)
        //present(activityViewController, animated: true)
        
    }
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func deleteDocument(){
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        db.collection("DocumentRequest").document(key).delete() { err in
            if let err = err {
                print("Error removing documentRequest with Key \(self.key): \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        // Create a reference to the file to delete
        let pdfRef = storageRef.child("DocumentRequests/" + key + "/" + fileName)
        // Delete the file
        pdfRef.delete { error in
          if let error = error {
             print("Error Deleting \(self.fileName) Error: \(error)")
          } else {
            print("FileName \(self.fileName) Deleted Successfully")
          }
        }
    }
    
    
}
