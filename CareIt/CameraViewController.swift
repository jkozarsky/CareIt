//
//  CameraViewController.swift
//  CareIt
//
//  Created by William Londergan (student LM) on 2/11/19.
//  Copyright © 2019 Jason Kozarsky (student LM). All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let barcodeFrameView = UIView()
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var databaseRequest = DatabaseRequests(barcodeString: "")
    var popupView: UIView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInTrueDepthCamera, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        

        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        barcodeFrameView.layer.borderColor = UIColor.green.cgColor
        barcodeFrameView.layer.borderWidth = 2
        view.addSubview(barcodeFrameView)
        view.bringSubview(toFront: barcodeFrameView)
    }
    
    func showAllergyAlertView(_ request: DatabaseRequests) {
        let transparentView = UIView()
        view.addSubview(transparentView)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.heightAnchor.constraint(equalToConstant: view.bounds.height/2).isActive = true
        transparentView.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        transparentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        transparentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if let food = request.result {
            foodRequest(transparentView, food: food)
        } else {
            errorFoodRequest(transparentView, error: request.error!)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if databaseRequest.currentlyProcessing {
            return
        }
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            barcodeFrameView.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.ean13 {
            
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            barcodeFrameView.frame = barcodeObject!.bounds
            
            let loadingView = UIView()
            loadingView.backgroundColor = .black
            loadingView.alpha = 0.5
            let loadingText = UILabel()
            loadingText.text = "loading..."
            loadingText.font = UIFont(name: "helvetica neue", size: 50)
            loadingText.textColor = .white
            
            if let barcodeString = metadataObj.stringValue  {
                 self.databaseRequest = DatabaseRequests(barcodeString: String(barcodeString[barcodeString.index(after: barcodeString.startIndex)..<barcodeString.endIndex]))
                databaseRequest.request(beforeLoading: {
                    self.barcodeFrameView.frame = .zero
                    self.view.addSubview(loadingView)
                    loadingView.translatesAutoresizingMaskIntoConstraints = false
                    loadingView.heightAnchor.constraint(equalToConstant: view.bounds.height/5).isActive = true
                    loadingView.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
                    loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                    loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                    loadingView.addSubview(loadingText)
                    loadingText.translatesAutoresizingMaskIntoConstraints = false
                    loadingText.textAlignment = .center
                    loadingText.heightAnchor.constraint(equalTo: loadingView.heightAnchor).isActive = true
                    loadingText.widthAnchor.constraint(equalTo: loadingView.widthAnchor).isActive = true
                    loadingText.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
                    loadingText.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
                    
                    },
                                        afterLoading: {
                                            loadingView.removeFromSuperview()
                                            self.showAllergyAlertView(self.databaseRequest)
                                            
                    })
            }
        }
    }
    
    func errorFoodRequest(_ view: UIView, error: String?) {
        view.backgroundColor = .red
        print("error")
        
//        let errorBanner = UILabel()
//        errorBanner.bounds = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height * 3/4)
//        errorBanner.font = UIFont(name: "Helvetica Neue", size: 30)
//        errorBanner.textAlignment = .center
//        errorBanner.numberOfLines = 0
//        errorBanner.lineBreakMode = .byWordWrapping
//
//        view.addSubview(errorBanner)
        
//        if let error = error {
//            errorBanner.text = error
//        } else {
//            errorBanner.text = "An error occurred."
//        }
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.backgroundColor = .black

        dismissButton.setTitle("Done", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.layer.cornerRadius = 8
        dismissButton.layer.masksToBounds = true
        
        view.addSubview(dismissButton)
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        let errorBanner = UILabel()
        view.addSubview(errorBanner)
        errorBanner.translatesAutoresizingMaskIntoConstraints = false
        errorBanner.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        errorBanner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        errorBanner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorBanner.bottomAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: -10).isActive = true
        
        if let error = error {
            errorBanner.text = error
        } else {
            errorBanner.text = "An error occurred. Please try again."
        }
        
        errorBanner.font = UIFont(name: "Avenir Medium", size: 30)
        errorBanner.textColor = .white
        errorBanner.numberOfLines = 0
        errorBanner.lineBreakMode = .byWordWrapping
        errorBanner.textAlignment = .center
        
        self.popupView = view
        dismissButton.addTarget(self, action: #selector(doneButton(_:)), for: .touchUpInside)
    }
    
    func foodRequest(_ view: UIView, food: Food) {
        
        self.popupView = view
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.backgroundColor = .black
        
        dismissButton.setTitle("Done", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.layer.cornerRadius = 8
        dismissButton.layer.masksToBounds = true
        
        view.addSubview(dismissButton)
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        dismissButton.addTarget(self, action: #selector(doneButton(_:)), for: .touchUpInside)
        
        view.alpha = 1
        view.backgroundColor = .white //we should probably figure out what color this actually will be
        
        let foodTitle = UILabel()
        
        view.addSubview(foodTitle)
        
        foodTitle.translatesAutoresizingMaskIntoConstraints = false
        foodTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        foodTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        foodTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        foodTitle.contentMode = .center
        
        foodTitle.font = UIFont(name: "Helvetica Neue", size: 30)
        foodTitle.text = processTitle(food.desc.name)
        foodTitle.textAlignment = .center
        
        
        foodTitle.contentMode = .center
        
        if let allergies = userAllergic() {
            
            let warningLabel = UILabel()
            warningLabel.translatesAutoresizingMaskIntoConstraints = false
            warningLabel.text = "Unsafe to Eat 💀"
            warningLabel.font = UIFont(name: "Helvetica Neue", size: 30)
            warningLabel.backgroundColor = .red
            warningLabel.textColor = .white
            view.addSubview(warningLabel)
            warningLabel.topAnchor.constraint(equalTo: foodTitle.bottomAnchor, constant: 20).isActive = true
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let okayLabel = UILabel()
            okayLabel.translatesAutoresizingMaskIntoConstraints = false
            okayLabel.text = "Safe to Eat 🍴"
            okayLabel.font = UIFont(name: "Helvetica Neue", size: 30)
            okayLabel.backgroundColor = .green
            okayLabel.textColor = .white
            view.addSubview(okayLabel)
            okayLabel.topAnchor.constraint(equalTo: foodTitle.bottomAnchor, constant: 20).isActive = true
            okayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    @objc func doneButton(_ sender: Any) {
        self.popupView?.removeFromSuperview()
        self.popupView = nil
        databaseRequest.currentlyProcessing = false
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

func processTitle(_ title: String) -> String {
    //remove all UPC: stuff
    let separated = title.split(separator: " ")
    let filtered = separated.filter {arg in
        return Int64(arg) == nil && arg != "UPC:"
    }
    return filtered.joined(separator: " ").replacingOccurrences(of: ",", with: "")
}

func userAllergic() -> [String]? {
    if Double.random(in: 0...1) > 0.5{
        return nil
    } else {
        return ["sadness", "unhappiness", "tears"]
    }
}
