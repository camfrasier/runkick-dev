//
//  CameraVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/10/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC : UIViewController {
    
    
    lazy var shutterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCameraRing"), for: .normal)
        button.addTarget(self, action: #selector(handleShutterButton), for: .touchUpInside)
        button.tintColor = UIColor.walkzillaYellow()
        button.alpha = 1
        return button
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCameraRing"), for: .normal)
        button.addTarget(self, action: #selector(handleRecordButton), for: .touchUpInside)
        button.tintColor = UIColor.walkzillaRed()
        button.alpha = 1
        return button
    }()
    
    lazy var toolBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        view.isUserInteractionEnabled = true
        view.alpha = 0.35
        return view
    }()
    
    lazy var toggleViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaPhotoFlip"), for: .normal)
        button.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return button
    }()
    
    lazy var photoAlbumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaPhotoAlbum"), for: .normal)
        button.addTarget(self, action: #selector(handleSelectFromAlbum), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return button
    }()

    
    var captureSession = AVCaptureSession()
    
    // which camera input do we want to use
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    // output device
    var stillImageOutput: AVCaptureStillImageOutput?
    var stillImage: UIImage?
    
    // camera preview layer
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // double tap to switch from back to front facing camera
    var toggleCameraGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // this command allows us to take the full resolution of the camera that the device allows
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let devices = AVCaptureDevice.devices(for: AVMediaType.video) as! [AVCaptureDevice]
    
        // we look through the device like this
        for device in devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
                
            }
        }
        
        // default device (selfie view by default)
        currentDevice = frontFacingCamera
        
        // configure the session with the output for capturing our still image
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
                
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(stillImageOutput!)
            
            // set up a camera preview layer
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            view.layer.addSublayer(cameraPreviewLayer!)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer?.frame = view.layer.frame
            
            configureCameraViewComponents()
            
            configurNavigationButtons()
            
            captureSession.startRunning()
            
            // toggle the camera
            toggleCameraGestureRecognizer.numberOfTapsRequired = 2
            toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
            view.addGestureRecognizer(toggleCameraGestureRecognizer)
            
            
        } catch let error {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureCameraViewComponents() {
        
        let shutterDimension: CGFloat = 80
        view.addSubview(shutterButton)
        shutterButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: shutterDimension, height: shutterDimension)
        shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shutterButton.layer.cornerRadius = shutterDimension / 2
        
        
        let recordDimension: CGFloat = 40
        view.addSubview(recordButton)
        recordButton.anchor(top: nil, left: shutterButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 30, paddingRight: 0, width: recordDimension, height: recordDimension)
        recordButton.layer.cornerRadius = recordDimension / 2
    
        view.addSubview(toolBackgroundView)
        toolBackgroundView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 18, width: 45, height: 110)
        toolBackgroundView.layer.cornerRadius = 15
        
        view.addSubview(photoAlbumButton)
        photoAlbumButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 57, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 30, height: 30)
        
        view.addSubview(toggleViewButton)
        toggleViewButton.anchor(top: photoAlbumButton.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 32, height: 34)
    }
    
    @objc func handleShutterButton() {
        
    print("shutter button tapped")
           
        guard let videoConnection = stillImageOutput?.connection(with: AVMediaType.video) else { return }
        
        // capture a still image asynchronously
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataBuffer, error) in
            
            if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: imageDataBuffer!, previewPhotoSampleBuffer: imageDataBuffer!) {
                self.stillImage = UIImage(data: imageData)
                
               // let imageVC = ImageVC()
               // imageVC.image = self.stillImage
              
                let uploadPostVC = UploadPostVC()
                uploadPostVC.selectedImage = self.stillImage
                //uploadPostVC.selectedImage = self.header?.photoImageView.image // Using this to pull the instance of our header and use it for the share page.
                //uploadPostVC.modalPresentationStyle = .fullScreen
                uploadPostVC.uploadAction = UploadPostVC.UploadAction(index: 0)
                //self.present(uploadPostVC, animated: true, completion: nil)
                
                self.navigationController?.pushViewController(uploadPostVC, animated: true)
                
                //self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    @objc func handleRecordButton() {
        
        print("Press and hold record should be here")

    }
    
    @objc private func toggleCamera() {
        // start the configuration change
        captureSession.beginConfiguration()
        
        guard let newDevice = (currentDevice?.position == . back) ? frontFacingCamera : backFacingCamera else { return }
        
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch let error {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    /*
    @objc func handleCancel() {
        print("Cancel and go back!")
        dismiss(animated: true, completion: nil)
    }
    */
    @objc func handleSelectFromAlbum() {
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(selectImageVC, animated: true)
    }
    
    func configurNavigationButtons() {
        
         //navigationController?.navigationBar.isHidden = true
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        // add or remove nav bar bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 45, width: view.frame.width, height: 0.25))
        lineView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        navigationItem.title = ""
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(handleSelectFromAlbum))
    }
    
}

