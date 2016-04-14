//
//  MRPhotosHelper.swift
//  MeMeApp
//
//  Created by Marcin Lament on 07/04/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import UIKit
import Photos

class MRPhotosHelper {
    
    var manager = PHImageManager.defaultManager()
    
    func saveImageAsAsset(image: UIImage, completion: (localIdentifier:String?) -> Void) {
        
        var imageIdentifier: String?
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            let changeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let placeHolder = changeRequest.placeholderForCreatedAsset
            imageIdentifier = placeHolder!.localIdentifier
            }, completionHandler: { (success, error) -> Void in
                if success {
                    completion(localIdentifier: imageIdentifier)
                } else {
                    completion(localIdentifier: nil)
                }
        })
    }
    
    func retrieveImageWithIdentifer(meme:MeMe, completion: (meme:MeMe?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers([meme.imageLocalIdentifier], options: fetchOptions)
        
        if fetchResults.count > 0 {
            if let imageAsset = fetchResults.objectAtIndex(0) as? PHAsset {
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .HighQualityFormat
                manager.requestImageForAsset(imageAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
                    meme.memedImage = image
                    completion(meme: meme)
                })
            } else {
                completion(meme: meme)
            }
        } else {
            completion(meme: meme)
        }
    }
    
//    func retrieveImageWithIdentifer(memes: [MeMe], completion: (memes: [MeMe]) -> Void) {
//        
//        var localIdentifiers = [String]()
//        for meme:MeMe in memes {
//            localIdentifiers.append(meme.imageLocalIdentifier)
//        }
//        
//        print("localIdentifiers: " + String(localIdentifiers.count))
//        
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
//        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers(localIdentifiers, options: fetchOptions)
//        
//        print("fetchResults: " + String(fetchResults.count))
//        for index in 0...fetchResults.count - 1 {
//            if let imageAsset = fetchResults.objectAtIndex(index) as? PHAsset {
//                let requestOptions = PHImageRequestOptions()
//                requestOptions.deliveryMode = .HighQualityFormat
//                manager.requestImageForAsset(imageAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
//                    print("loaded image")
////                    completion(image: image)
//                })
//            } else {
////                completion(image: nil)
//            }
//        }
//        print("finished")
//        completion(memes: memes)
//    }
}
