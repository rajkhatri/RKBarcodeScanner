//
//  CameraPermissions.swift
//  BarcodeScanner
//
//  Created by Raj Khatri on 2016-01-02.
//  Copyright © 2016 Raj Khatri. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPermissions : NSObject {
    
    static let sharedInstance = CameraPermissions()
    
    // Should be set to top most VC before checkCameraPermissions are called. Used only for Alert display.
    var cameraViewController:UIViewController?
    
    private var cameraPermissionsClosure:(()->())?
    
    func checkCameraPermissions(completion:(()->())) {
        
        cameraPermissionsClosure = completion
        
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch authStatus {
            
            case .Authorized:
                cameraPermissionsClosure!()
                break
            case .Denied:
                showAlert("Denied")
                break
            case .Restricted:
                showAlert("Restricted")
                break
            case .NotDetermined:
                askForPermissions()
                break
        }
    }
    
    private func askForPermissions() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) -> Void in
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    guard self.cameraPermissionsClosure != nil else { return }
                    self.cameraPermissionsClosure!()
                })
            }
            else {
                let error = "Camera Permissions Denied. Please enable in settings."
                print(error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showAlert(error)
                })
            }
        }
    }
    
    private func showAlert(type:String? = "") {
        let vc = UIAlertController(title: "Error: Cannot display camera because of issue:", message: type, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            self.cameraViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.addAction(okButton)
        
        guard cameraViewController != nil else { return }
        cameraViewController?.presentViewController(vc, animated: true, completion: nil)
    }
}