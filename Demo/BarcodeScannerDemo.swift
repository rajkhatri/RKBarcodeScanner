//
//  BarcodeScannerDemo.swift
//  BarcodeScanner
//
//  Created by Raj Khatri on 2016-01-03.
//  Copyright © 2016 Raj Khatri. All rights reserved.
//

import UIKit

class BarcodeScannerDemo : BarcodeScannerViewController {
    
    /**
     *  Add Custom code here to customize the look and feel of your barcode scanner.
     * You can add custom overlays, either here, or when initializing the ViewController.
     * You **SHOULD** override the two functions that are below
     */
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add back button to overlay
        let backButton = UIButton(type: .System)
        backButton.frame = CGRectMake(0, 0, 60, 60)
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: .TouchUpInside)
        
        if self.customOverlayView == nil {
            self.customOverlayView = UIView(frame: self.view.frame)
            self.customOverlayView?.addSubview(backButton)
        }
        
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Not required to call super
    override func barcodeScannerIsReady() {
        print("barcode scanner is ready")
    }
    
    // Function that will return the scanned value
    override func barcodeScannerScannedValue(value: String) {
        print("scanned barcode value: \(value)")
        // Do something with the scanned value
        // startCamera() if you want to activate the camera again
        super.barcodeScannerScannedValue(value) // Do not call this if you don't want the UIAlertView
    }
    
}