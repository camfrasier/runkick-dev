//
//  CustomImageView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/3/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImageUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        // Set image to nil everytime this function is called
        self.image = nil
        // Set lastImgUrlUsedToLoadImage
        lastImageUrlUsedToLoadImage = urlString
        
        // Check if image exists in cache.
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        // Url for image location
        guard let url = URL(string: urlString) else { return }
        
        // Fetch contents of Url.
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle our error
            if let error = error {
                print("Failed to load image with error", error.localizedDescription)
            }
            
            if self.lastImageUrlUsedToLoadImage != url.absoluteString { // Must use self because we are within a completion block.
                
                // Also if the last image url is being used then return
                return
            }
            
            // Image data.
            guard let imageData = data else { return }
            
            // Set image using image data.
            let photoImage = UIImage(data: imageData)
            
            // Create key and value for image cache.
            imageCache[url.absoluteString] = photoImage
            
            // Set our image.
            DispatchQueue.main.async {
                self.image = photoImage
                
                //print("This is the phot heigjt \(photoImage?.size.height)")
            }
            }.resume()
    }
}
