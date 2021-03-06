# RKBarcodeScanner
Simple Barcode Scanner with the ability to customize the overlays of the camera view. 

A Simple iOS Barcode Scanner using the native AVFoundation with the ability to customize
anything you want. There are certain properties that allow for access to structured
control of the scanner, as well as functions that act as notifiers for certain events.

## Installation

Coming Soon to Cocoapods

## Usage

In order to use this, you should subclass `BarcodeScannerViewController`. The camera is
added to the sublayer of the view.

In order to receive events, you can override `barcodeScannerIsReady()` and 
`barcodeScannerScannedValue(String)` which can be both useful

Other helper functions such as `startCamera()` and `stopCamera()` are useful to manually
control the usage of the camera and efficiency of your app.

You can also add custom user interface elements on top of the camera by creating a view
and setting the `customOverlayView` property.
	
	// This will add the 'backButton' on top of the camera
	self.customOverlayView = UIView(frame: self.view.frame)
	self.customOverlayView?.addSubview(backButton)

Note that the customization flags must be set before the viewDidAppear (on the initialization)
of the view controller, and the custom UI property can be set inside the viewDidLoad

This project also allows the user to manually ask for camera permissions (at your own time)
before displaying the native camera access alert by setting `shouldAskForPermissions` to false

    let barcodeScanner = BarcodeScannerDemo()

	// Set some properties available to customize
	barcodeScanner.shouldAskForPermissions = true // Automatically will ask for camera permissions
	barcodeScanner.shouldShowBarcodeRegion = true // Will show a green rectagle over scanned area
	barcodeScanner.highlightColor = .greenColor()
	barcodeScanner.shouldPauseAfterScannedItem = true // Will pause the camera after barcode has been scanned

You can download and see the Demo for usages.

## Notes
Requires iOS 8 or greater. Written in Swift 2.0