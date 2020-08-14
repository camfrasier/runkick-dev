//
//  ImageVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/11/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class ImageVC : UIViewController
{
    lazy var saveImage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Image", for: .normal)
        button.addTarget(self, action: #selector(handleSaveImage), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        button.alpha = 1
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Start Pedometer", for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        button.alpha = 1
        return button
    }()
    
    var image: UIImage?
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageViewComponents()
        
        imageView?.image = image

    }
    
    func configureImageViewComponents() {
        
        view.addSubview(saveImage)
        saveImage.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 60, paddingBottom: 50, paddingRight: 0, width: 60, height: 60)
        //saveImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveImage.layer.cornerRadius = 60 / 2
        
        
        view.addSubview(closeButton)
        closeButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 60, width: 60, height: 60)
        //closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeButton.layer.cornerRadius = 60 / 2
        
    }

    @objc func handleCloseButton() {
        print("handle close or dismiss")
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleSaveImage() {
        
        print("save current image")
        guard let imageToSave = image else {
            return
        }
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            dismiss(animated: false, completion: nil)
    }
}

