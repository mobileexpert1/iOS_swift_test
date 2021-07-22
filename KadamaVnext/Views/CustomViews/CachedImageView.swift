//
//  CachedImageView.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import UIKit
import Foundation

//let imageCache = NSCache<NSString, UIImage>()

class CachedImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        
        if let savedImage = getSavedImage(named: imageUrlString) {
            self.image = savedImage
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                if !(self.saveImage(data: data, url: urlString)){
                    print("error in saving in documents directory")
                }
            })
            
        }).resume()
        
        // NSCache implementation , Issue with limited memory
        
//        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
//            self.image = imageFromCache
//            return
//        }
//
//        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                return
//            }
//            DispatchQueue.main.async(execute: {
//                let imageToCache = UIImage(data: data!)
//                if self.imageUrlString == urlString {
//                    self.image = imageToCache
//                }
//                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
//            })
//
//        }).resume()
    }
    
    
    func saveImage(data: Data?,url:String) -> Bool {
        guard let data = data else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent((url as NSString).lastPathComponent)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String?) -> UIImage? {
        guard let url = named else {
            return nil
        }
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent((url as NSString).lastPathComponent).path)
        }
        return nil
    }
    
}
