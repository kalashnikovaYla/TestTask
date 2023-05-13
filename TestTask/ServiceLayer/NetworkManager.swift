//
//  NetworkManager.swift
//  TestTask
//
//  Created by sss on 12.05.2023.
//

import UIKit
import SDWebImage

final class NetworkManager {
    
    var imageCache = SDImageCache(namespace: "thumbnails")
    
    /// Load data from text file
    func loadDataFromTextFile(string: String, completion: @escaping ([URL]?) -> Void) {
        
        if let url = URL(string: string) {
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, _ , error) in
                guard let self = self else {return }
                
                if error != nil {
                    completion(nil)
                    return
                }
                
                if let data = data {
                    let urlsArray = createUrlsArray(data: data)
                    completion(urlsArray)
                }
            }.resume()
        }
    }
    
    private func createUrlsArray(data: Data) -> [URL] {
        var urlsArray: [URL] = []
        
        if let contents = String(data: data, encoding: .utf8) {
            let urls = contents.components(separatedBy: .newlines)
            for urlString in urls {
                
                if self.isValidURL(string: urlString),
                    self.isValidURLForLoadImage(string: urlString),
                    let url = URL(string: urlString) {
                    urlsArray.append(url)
                }
            }
        }
        return urlsArray
    }

    ///URL validation
    private func isValidURL(string: String) -> Bool {
        if let url = URL(string: string) {
            return url.scheme != nil && url.host() != nil
        }
        return false
    }
    
    ///Validation of URL for image upload
    private func isValidURLForLoadImage(string: String) -> Bool {
        if string.contains("image") || string.contains("jpg") || string.contains("png") {
            return true
        }
        return false
    }
    
    ///Load image
    func loadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = imageCache.imageFromCache(forKey: url.absoluteString) {
            completion(cachedImage)
        } else {
            let originalImageUrl = url
            
            SDWebImageManager.shared.loadImage(with: originalImageUrl,
                                               options: .highPriority,
                                               progress: nil,
                                               completed: { [weak self] image, _, _, _, _, _ in
                
                guard let self = self, let image = image else {
                    completion(nil)
                    return
                }
                
                let targetSize = CGSize(width: 100, height: 100)
                let resizedImage = image.sd_resizedImage(with: targetSize, scaleMode: .aspectFill)
                self.imageCache.store(resizedImage, forKey: url.absoluteString, completion: nil)
                
                completion(resizedImage)
            })
        }
    }
}
