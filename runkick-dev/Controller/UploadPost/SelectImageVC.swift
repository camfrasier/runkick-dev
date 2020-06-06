//
//  SelectImageVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Photos
import Firebase

private let reuseidentifier = "SelectPhotoCell"
private let headerIdentifier = "SelectPhotoHeader"


class SelectImageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var header: SelectPhotoHeader?
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        // Register cell clases
        collectionView?.register(SelectPhotoCell.self, forCellWithReuseIdentifier: reuseidentifier)
        collectionView?.register(SelectPhotoHeader.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        configurNavigationButtons()
        collectionView?.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)
        
        fetchPhotos()

    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    

    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPhotoHeader
        
        self.header = header
        
        if let selectedImage = self.selectedImage {
            // Index of our selected image.
            if let index = self.images.firstIndex(of: selectedImage) {
            
            // Asset associated with selected image.
            let selectedAssets = self.assets[index]
            
            // Adjusting the resolution of the photos to good.
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 650, height: 650)  // originally this was set to 600. may need to change back
            
                // Request image.
                imageManager.requestImage(for: selectedAssets, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                
                    header.photoImageView.image = image
                    
                })
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath) as! SelectPhotoCell
        
        cell.photoImageView.image = images[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = images[indexPath.row]
        self.collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        print("Cancel and go back!")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        DataService.instance.REF_USERS.child(currentUid).child("isStoreadmin").observe(.value) { (snapshot) in
            let isStoreadmin = snapshot.value as! Bool
                    
            print(snapshot.value as! Bool)
                    
            if isStoreadmin == true {
                
                let uploadStorePostVC = UploadStorePostVC()
                uploadStorePostVC.selectedImage = self.header?.photoImageView.image // Using this to pull the instance of our header and use it for the share page.
                uploadStorePostVC.uploadAction = UploadStorePostVC.UploadAction(index: 0)
                self.navigationController?.pushViewController(uploadStorePostVC, animated: true)
                
            } else {
                
                let uploadPostVC = UploadPostVC()
                uploadPostVC.selectedImage = self.header?.photoImageView.image // Using this to pull the instance of our header and use it for the share page.
                uploadPostVC.uploadAction = UploadPostVC.UploadAction(index: 0)
                self.navigationController?.pushViewController(uploadPostVC, animated: true)
            }
        }
    }
    
    func configurNavigationButtons() {

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func getAssetFetchOptions() -> PHFetchOptions {
        
        let options = PHFetchOptions()
        
        // Setting fetch limit.
        options.fetchLimit = 50
        
        // Sort photos by date.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        // Set sort desriptor for options.
        options.sortDescriptors = [sortDescriptor]
        
        // Return our options.
        return options
        
    }
    
    func fetchPhotos () {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        print("Function running")
        
        // Fetch our images on background thread.
        DispatchQueue.global(qos: .background).async {
            
            // Where we enumerate options
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                print("Count is \(count)")
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // Request image representation for specified asset.
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image { // If image exists do this.
                        
                        // Append image to data source.
                        self.images.append(image)
                        
                        // Append asset to data source.
                        self.assets.append(asset)
                        
                        // Set selected image.
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        // Reload collectionView with images, once count has completed.
                        if count == allPhotos.count - 1 {
                            
                            // Reload collection view on main thread.
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                        }
                    }
                })
            })
        }
    }
}
