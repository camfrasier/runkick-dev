//
//  CameraViewController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/24/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import UIKit
import Photos

class CameraViewController : UIViewController {
    
    lazy var shutterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCameraRing"), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoCapture), for: .touchUpInside)
        button.tintColor = UIColor.walkzillaYellow()
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
        button.addTarget(self, action: #selector(handleToggleCamera), for: .touchUpInside)
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
    
    lazy var flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "flashIconUnselected"), for: .normal)
        button.addTarget(self, action: #selector(handleflashToggle), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaPhotoFlip"), for: .normal)
        button.addTarget(self, action: #selector(handleToggleCamera), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return button
    }()
    
    lazy var camcorderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "videoCameraIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleCamcorder), for: .touchUpInside)
        button.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        return button
    }()
    
    lazy var videoShutterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walkzillaCameraRing"), for: .normal)
        button.tintColor = UIColor.rgb(red: 255, green: 0, blue: 0)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        button.addGestureRecognizer(longPressGestureRecognizer)
        return button
    }()
    
    
    
    var capturePreviewView = UIView()
    let cameraController = CameraController()
    var isCamcorderSet = false
    
    
    func configureCameraViewComponents() {
        
        view.addSubview(capturePreviewView)
        capturePreviewView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let shutterDimension: CGFloat = 80
        capturePreviewView.addSubview(shutterButton)
        shutterButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: shutterDimension, height: shutterDimension)
        shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shutterButton.layer.cornerRadius = shutterDimension / 2
        
        capturePreviewView.addSubview(videoShutterButton)
        videoShutterButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: shutterDimension, height: shutterDimension)
        videoShutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        videoShutterButton.layer.cornerRadius = shutterDimension / 2
    
        capturePreviewView.addSubview(toolBackgroundView)
        toolBackgroundView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 35, paddingLeft: 0, paddingBottom: 0, paddingRight: 18, width: 45, height: 170)
        toolBackgroundView.layer.cornerRadius = 15
        
        capturePreviewView.addSubview(photoAlbumButton)
        photoAlbumButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 57, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 30, height: 30)
        
        capturePreviewView.addSubview(toggleViewButton)
        toggleViewButton.anchor(top: photoAlbumButton.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 32, height: 34)
        
        capturePreviewView.addSubview(camcorderButton)
        camcorderButton.anchor(top: toggleViewButton.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 30, height: 28)
        
        capturePreviewView.addSubview(flashButton)
        flashButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 54, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 18, height: 30)
        


    }
    
    @objc func handleflashToggle() {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            flashButton.setImage(UIImage(named: "flashIconUnselected"), for: .normal)
            flashButton.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        }
     
        else {
            cameraController.flashMode = .on
            flashButton.setImage(UIImage(named: "flashIconSelected"), for: .normal)
            flashButton.tintColor = UIColor.walkzillaYellow()
        }
    }
    
    @objc func handleToggleCamera() {
        
        do {
              try cameraController.switchCameras()
          }
       
          catch {
              print(error)
          }
       
          switch cameraController.currentCameraPosition {
          case .some(.front):
            toggleViewButton.setImage(UIImage(named: "walkzillaPhotoFlip"), for: .normal)
            toggleViewButton.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
       
          case .some(.rear):
            toggleViewButton.setImage(UIImage(named: "walkzillaPhotoFlip"), for: .normal)
       
          case .none:
              return
          }
        
    }
    
    @objc func handlePhotoCapture() {
        
        
        cameraController.captureImage {(image, error) in
               guard let image = image else {
                   print(error ?? "Image capture error")
                   return
               }
               
            /*
               try? PHPhotoLibrary.shared().performChangesAndWait {
                   PHAssetChangeRequest.creationRequestForAsset(from: image)
               }
            */
            let uploadPostVC = UploadPostVC()
            uploadPostVC.selectedImage = image
            uploadPostVC.uploadAction = UploadPostVC.UploadAction(index: 0)
            
            self.navigationController?.pushViewController(uploadPostVC, animated: true)
           }
    }
    
    @objc func handleCamcorder() {
        
        if isCamcorderSet == false {
            shutterButton.isHidden = true
            videoShutterButton.isHidden = false
            isCamcorderSet = true
        } else {
            shutterButton.isHidden = false
            videoShutterButton.isHidden = true
            isCamcorderSet = false
        }
        
        
    }
    
    @objc func handleSelectFromAlbum() {
        let selectImageVC = SelectImageVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(selectImageVC, animated: true)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        
        if sender.state == .began {
            print("Long press did begin..")
            
            
            cameraController.recordVideo { (url, error) in
                
                
                guard let url = url else {
                    print(error ?? "issue recording video")
                    return
                }
                
                print("there is no issue recording and here is the url file \(url)")
                
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
                
            }
            
            
        } else if sender.state == .ended {
            print("Long press did end..")
            
            cameraController.stopRecording { error in
                print(error ?? "video capture error")
                return
            }
            
        }
    }
    
    @objc func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("We have an error saving your video \(error)")
        } else {
            print("Your video has been staved!")
        }
    }
  
    /*
    @objc func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("We have an error saving your video \(error)")
        } else {
            print("Your video has been staved!")
        }
    }
    */
}

extension CameraViewController {
   
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
         
        navigationController?.isNavigationBarHidden = true
        videoShutterButton.isHidden = true
        
         func configureCameraController() {
             cameraController.prepare {(error) in
                 if let error = error {
                     print(error)
                 }
  
                 try? self.cameraController.displayPreview(on: self.capturePreviewView)
             }
         }
        
         configureCameraViewComponents()
         configureCameraController()
     }

}
