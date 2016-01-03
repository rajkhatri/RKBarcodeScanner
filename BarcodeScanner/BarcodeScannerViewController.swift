//
//  BarcodeScannerViewController.swift
//  BarcodeScanner
//
//  Created by Raj Khatri on 2016-01-02.
//  Copyright © 2016 Raj Khatri. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // AV Properties
    private var session:AVCaptureSession!
    private var camera:AVCaptureDevice!
    private var deviceInput:AVCaptureDeviceInput!
    private var output:AVCaptureMetadataOutput!
    private var previewLayer:AVCaptureVideoPreviewLayer!
    
    // Custom UI
    
    // Add any other custom overlay view on top. Use this view to modify dynamic content.
    var customOverlayView:UIView?
    
    // Highlight Barcode Region
    private var highlightView:UIView?
    var shouldShowBarcodeRegion:Bool = false
    var highlightColor:UIColor = UIColor.blackColor() // Should change
    var highlightWidth:CGFloat = 3.0
    
    // Flags (Can be set by user)
    var shouldAskForPermissions:Bool = true
    var shouldPauseAfterScannedItem:Bool = true
    
    // Barcode Types (only some added) Set this to change.
    var barcodeTypes:[NSString] = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeQRCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAskForPermissions {
            CameraPermissions.sharedInstance.cameraViewController = self
            CameraPermissions.sharedInstance.checkCameraPermissions({ () -> () in
                self.initCustomUI()
                self.initCamera()
            })
        }
        else {
            initCustomUI()
            initCamera()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if session != nil && session.running {
            session.stopRunning()
            session = nil
        }
    }
    
    // MARK: Camera Initialization
    private func initCamera() {
        
        session = AVCaptureSession()
        camera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            try deviceInput = AVCaptureDeviceInput(device: camera)
        }
        catch {
            print("Error trying to use camera: \(error)")
        }
        
        guard deviceInput != nil else {
            print("Cannot attach input to session")
            return
        }
        
        session.addInput(deviceInput)
        
        output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = UIScreen.mainScreen().bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        addCustomUItoView()
        
        // To determine when exactly the camera is ready to "start". Used if you want to show indication when camera has begun.
        session.addObserver(self, forKeyPath: "running", options: NSKeyValueObservingOptions.New, context: nil)
        
        session.startRunning()
    }
    
    // MARK: Custom UI
    private func initCustomUI() {
        
        if shouldShowBarcodeRegion {
            highlightView = UIView()
            highlightView?.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin];
            highlightView?.layer.borderColor = highlightColor.CGColor
            highlightView?.layer.borderWidth = highlightWidth
        }
    }
    
    private func addCustomUItoView() {
        if shouldShowBarcodeRegion && highlightView != nil {
            self.view.addSubview(highlightView!)
            self.view.bringSubviewToFront(highlightView!)
        }
        
        guard customOverlayView != nil else { return }
        
        self.view.addSubview(customOverlayView!)
        self.view.bringSubviewToFront(customOverlayView!)
    }
    
    // MARK: Camera Functions
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightRect = CGRectZero
        
        for data in metadataObjects {
            guard let metaData = data as? AVMetadataObject else { continue }
            var detectionString:String?
            
            for type in barcodeTypes {
                if type == metaData.type {
                    guard let barcodeObject = previewLayer.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject else { continue }
                    highlightRect = barcodeObject.bounds
                    detectionString = (metaData as! AVMetadataMachineReadableCodeObject).stringValue
                    break
                }
            }
            
            guard detectionString != nil else { continue }
            
            if shouldPauseAfterScannedItem {
                session.stopRunning()
            }
            
            barcodeScannerScannedValue(detectionString!)
            
            guard highlightView != nil else { continue }
            highlightView?.frame = highlightRect
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard object as? AVCaptureSession != nil else { return }
        
        if session.running {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("barcodeScannerIsReady"), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: Overridable Functions
    
    func barcodeScannerIsReady() {
    }
    
    func barcodeScannerScannedValue(value:String) {
        let vc = UIAlertController(title: value, message: nil, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.startCamera()
        }
        vc.addAction(okButton)
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: Helper Functions
    
    func startCamera() {
        if highlightView != nil {
            highlightView?.frame = CGRectZero
        }
        guard session != nil else {
            print("Initialize Camera before calling this function")
            return
        }
        session.startRunning()
    }
    
    func stopCamera() {
        guard session != nil else { return }
        session.stopRunning()
    }
}