//
//  MainViewController.swift
//  BarcodeScanner
//
//  Created by Raj Khatri on 2016-01-03.
//  Copyright © 2016 Raj Khatri. All rights reserved.
//

import UIKit

class MainViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteColor()

        let scanBarcodeButton = UIButton(type: UIButtonType.System)
        scanBarcodeButton.setTitle("Scan Barcode", forState: UIControlState.Normal)
        scanBarcodeButton.frame = CGRectMake(CGRectGetMidX(view.frame) - 200, CGRectGetHeight(view.frame)/2 - 100, 400, 60)
        scanBarcodeButton.addTarget(self, action: "scanPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(scanBarcodeButton)
    }
    
    func scanPressed() {
        // Add Custom UI and Code to BarcodeScannerDemo class if you want
        let barcodeScanner = BarcodeScannerDemo()
        // Set some properties available to customize
        barcodeScanner.shouldAskForPermissions = true
        barcodeScanner.shouldShowBarcodeRegion = true
        barcodeScanner.highlightColor = .greenColor()
        barcodeScanner.shouldPauseAfterScannedItem = true
        
        self.navigationController?.pushViewController(barcodeScanner, animated: true)
    }

}
