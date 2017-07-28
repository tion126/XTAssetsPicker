//
//  XTImagePickerController.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 2016/9/22.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import UIKit
import Photos

class XTImagePickerController: UIImagePickerController {

    var manager : XTAssetsManager! = XTAssetsManager.sharedInstance
}

extension XTImagePickerController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, self, #selector(imageDidFinishSaving), nil)
        
        self.dismiss(animated: true, completion: nil)
    }

    func imageDidFinishSaving(image : UIImage ,error : NSError,contextInfo : UnsafeMutableRawPointer?) {
        
        let userLibrary = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
        let resultsOptions = PHFetchOptions()
        resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let asset = PHAsset.fetchAssets(in: userLibrary.firstObject! , options: resultsOptions).firstObject! 
        self.manager?.selectedAssets.add(asset)
        self.manager?.loadAssets(collection: userLibrary.firstObject!)
    }
    
}


