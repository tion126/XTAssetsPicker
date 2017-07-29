//
//  XTAssetsManager.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 16/9/13.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import UIKit
import Photos

@objc public protocol XTAssetsPickerDelegate : class {

    @objc optional func didFinishPickingAssets(assets : NSMutableArray)
    @objc optional func didExceedMaximumNumberOfSelection(asset : PHAsset)
    @objc optional func didCancel()
}

class XTAssetsManager: NSObject {

    var collections    : [PHAssetCollection] = []
    var collection     : PHAssetCollection!
    var assets         : PHFetchResult<PHAsset>!
    var index          : NSInteger?
    var selectedAssets : NSMutableArray = []
    let cachingManager : PHCachingImageManager = PHCachingImageManager()
    var assetThumbSize       : CGSize?
    var assetPreviewSize     : CGSize?
    var assetThumbItemSize   : CGSize?
    var assetPreviewItemSize : CGSize! = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    weak var delegate        : XTAssetsPickerDelegate?
    
    var config : XTAssetsConfiguration?{
        
        didSet{
            let scale = UIScreen.main.scale
            let width = (SCREEN_WIDTH - CGFloat((config!.numberOfColum - 1) * 2)) / CGFloat(config!.numberOfColum)
            assetThumbItemSize = CGSize.init(width: width, height: width)
            assetThumbSize     = CGSize.init(width: width * scale, height: width * scale)
            assetPreviewSize   = CGSize.init(width: SCREEN_WIDTH * scale, height: SCREEN_HEIGHT * scale)
        }
    }
    
    static let sharedInstance = XTAssetsManager()
    
    
    private override init(){
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit{
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func reload() {
        
        loadAlbums()
        loadAssets(collection: collections.first!)
    }
    
    func loadAlbums(){
        
        collections.removeAll()
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        func collectionAdd(_ result : PHFetchResult<AnyObject>){
            
            for index in 0..<result.count {
                
                guard result[index].count() > 0 else{continue}
                collections.append(result[index] as! PHAssetCollection)
            }
        }
        
        collectionAdd(smartAlbums as! PHFetchResult<AnyObject>)
        collectionAdd(userAlbums  as! PHFetchResult<AnyObject>)
        
        self.collections.sort { (item1, item2) -> Bool in
            return item1.count() > item2.count()
        }
    }
    
    func loadAssets(collection : PHAssetCollection){
        
        guard collections.count > 0 else {return}
        guard collection.localIdentifier != self.collection?.localIdentifier else {return}
        
        self.collection = collection
        let resultsOptions = PHFetchOptions()
        resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let predicate = "mediaType = \(PHAssetMediaType.image.rawValue)"
        resultsOptions.predicate = NSPredicate(format: predicate)
        
        assets = PHAsset.fetchAssets(in: collection , options: resultsOptions)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kXTAssetReloadNotification), object: ["resetOffset" : true])
    }
 
    func containsAsset(asset : PHAsset) -> Bool {
        
        let predicate      = NSPredicate.init(format: "SELF.localIdentifier == %@",asset.localIdentifier )
        let filtered       = self.selectedAssets.filtered(using: predicate)
        
       return  !filtered.isEmpty
    }
    
    func assetsCount() -> NSInteger {
        
        return selectedAssets.count
    }
    
    func selectAsset(asset : PHAsset) -> Bool {
        
        let flag = self.selectedAssets.count < self.config!.maxminumCount
        if flag {
            self.selectedAssets.add(asset)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kXTAssetRefreshStatusNotification), object: nil)
        }else{
            self.delegate?.didExceedMaximumNumberOfSelection?(asset: asset)
        }
        return flag
    }
    
    func deselectAsset(asset : PHAsset) {
        
        self.selectedAssets.remove(asset)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kXTAssetRefreshStatusNotification), object: nil)
    }
    
    func selectComplete() {
        
        self.delegate?.didFinishPickingAssets?(assets: self.selectedAssets)
        self.selectedAssets.removeAllObjects()
    }
    
    func cancel() {
        
        self.delegate?.didCancel?()
        self.selectedAssets.removeAllObjects()
    }
}



extension XTAssetsManager : PHPhotoLibraryChangeObserver{
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
       
        DispatchQueue.main.async {
            
            self.loadAlbums()
            guard let changes = changeInstance.changeDetails(for:self.assets) else { return }
            self.selectedAssets.removeObjects(in: changes.removedObjects)
            self.assets = changes.fetchResultAfterChanges
            NotificationCenter.default.post(name: Notification.Name(rawValue: kXTAssetRefreshStatusNotification), object: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kXTAssetReloadNotification), object: ["resetOffset" : false , "changes" : changes])
            
        }
        
    }
}
