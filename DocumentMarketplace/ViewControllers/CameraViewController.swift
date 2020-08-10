//
//  CameraViewController.swift
//  DocumentMarketplace
//
//  Created by Jake Stocker on 7/9/20.
//  Copyright © 2020 Jake Stocker. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate  {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var images = [UIImage]()
    var selectedDocKey:String?
    var convimages = [UIImage]()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePhotoButton.backgroundColor = .blue
        cancelButton.backgroundColor = .gray
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.color = .gray
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
            view.addSubview(self.activityIndicator)
        previewView.addSubview(self.activityIndicator)
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //loadingIndicator.alpha = 0
        //previewView.addSubview(loadingIndicator)
        startCamera()
        }
    
    func showActivityIndicatory(uiView: UIView) {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func startCamera() {
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            cameraOutput = AVCapturePhotoOutput()

            if let device = AVCaptureDevice.default(for: .video),
               let input = try? AVCaptureDeviceInput(device: device) {
                if (captureSession.canAddInput(input)) {
                    captureSession.addInput(input)
                    if (captureSession.canAddOutput(cameraOutput)) {
                        captureSession.addOutput(cameraOutput)
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        previewLayer.frame = previewView.bounds
                        previewView.layer.addSublayer(previewLayer)
                        captureSession.startRunning()
                    }
                } else {
                    print("issue here : captureSesssion.canAddInput")
                }
            } else {
                print("some problem here")
            }
        }
    
    
    
    func transistionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

    
    @IBAction func didTakePhoto(_ sender: Any) {

        let settings = AVCapturePhotoSettings()
                let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
                let previewFormat = [
                    kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                    kCVPixelBufferWidthKey as String: 160,
                    kCVPixelBufferHeightKey as String: 160
                ]
                settings.previewPhotoFormat = previewFormat
        
                cameraOutput.capturePhoto(with: settings, delegate: self)
        if (images.count == 10){
            transistionToPDFView()
        }
    }
    
    func transistionToPDFView(){
        
        for image in images{
            //var convimage = image.resizedTo1MB()!
            var convimage = image.jpeg(.medium)
            guard var convUIimage = UIImage(data: convimage!) else {
                print("Failed to convert image")
                return }
            //images.removeFirst()
            convimages.append(convUIimage)
            
        }
        
        let vc = storyboard?.instantiateViewController(identifier: "ViewPDFVC") as?
            ViewPDFAfterSnapshotViewController
        vc?.images = convimages
        vc?.selectedDocKey = selectedDocKey!
        
        
        navigationController?.pushViewController(vc!, animated: true)
        
        //let pdfViewController = storyboard?.instantiateViewController(identifier: "ViewPDFVC") as?
        //ViewPDFAfterSnapshotViewController
        
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
    }
        
    @IBAction func cancelPressed(_ sender: Any) {
        //loadingIndicator.alpha = 1
        stopSession()
        previewView.layer.removeFromSuperlayer()
        previewView.layer.removeAllAnimations()
        //loadingIndicator.startAnimating()
        //showActivityIndicatory(uiView: previewView)
        activityIndicator.startAnimating()
        
        transistionToPDFView()
    }
}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        if let error = error {
            print("error occured : \(error.localizedDescription)")
        }

        if let dataImage = photo.fileDataRepresentation() {
            print(UIImage(data: dataImage)?.size as Any)

            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            var image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
            /**
               save image in array / do whatever you want to do with the image here
            */
            self.images.append(image)

        } else {
            print("AVCapturePhotoCapture failed")
        }
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
func resized(withPercentage percentage: CGFloat) -> UIImage? {
    let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: canvasSize))
    return UIGraphicsGetImageFromCurrentImageContext()
}

func resizedTo1MB() -> UIImage? {
    guard let imageData = self.pngData() else { return nil }

    var resizingImage = self
    var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB

    while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
        guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
              let imageData = resizedImage.pngData()
            else { return nil }

        resizingImage = resizedImage
        imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
    }

    return resizingImage
}
}
