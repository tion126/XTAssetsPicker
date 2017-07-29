//
//  XTExtension.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 16/9/12.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import Foundation
import Photos


extension Bundle {
    
    class func XTAssetBundle() -> Bundle{
        
        let path = Bundle.main.path(forResource: "XTAssetsPicker", ofType: "bundle")
        
        let bundle = Bundle.init(path: path!)
        
        return bundle!
    }
}

extension PHAssetCollection {
    
    func count() -> NSInteger {
        
        let result = PHAsset.fetchAssets(in: self, options: nil)
        return result.count
    }
    
    func posterAsset() -> PHAsset {
        
        let resultsOptions = PHFetchOptions()
        resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(in: self, options: resultsOptions)
        
        return result.firstObject!
    }
}

extension UIViewController {
    
   public func presentAssetsPicker(configuration : XTAssetsConfiguration = XTAssetsConfiguration() ,delegate : XTAssetsPickerDelegate!) {
        
        authorize { (status) in
            
            guard  status == .authorized else{return}
            
            let manager = XTAssetsManager.sharedInstance
            manager.config = configuration
            manager.delegate = delegate
            
            let picker = UIStoryboard(name: "XTAssetsPicker", bundle: Bundle(for: XTAssetsManager.sharedInstance.classForCoder)).instantiateViewController(withIdentifier: "XTAssetsPicker") as! UINavigationController
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func authorize(result : @escaping (PHAuthorizationStatus) -> Swift.Void){
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            
            result(.authorized)
        case .notDetermined:
            // 请求授权
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
              
                result(status)
            })
        default: ()
            let alertController = UIAlertController(title: "访问相册受限",
                                                    message: "点击“设置”，允许访问您的相册",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title:  "取消", style: .cancel, handler:nil)
            
            let settingsAction = UIAlertAction(title: "设置", style: .default, handler: { (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if let url = url , UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        
            result(.restricted)
        }
    }
    
    func presentImagePicker(manager : XTAssetsManager){
        
        cameraAuthorize { (status) in
            
            guard  status == .authorized else{return}
            let picker        = XTImagePickerController()
            picker.delegate   = picker
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
    func cameraAuthorize(result : @escaping (AVAuthorizationStatus) -> Swift.Void) {
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            
            result(.authorized)
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (flag) in

                result(flag ? .authorized : .denied)
            })
            
        default: ()
        let alertController = UIAlertController(title: "访问相机受限",
                                                message: "点击“设置”，允许访问您的相机",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title:  "取消", style: .cancel, handler:nil)
        
        let settingsAction = UIAlertAction(title: "设置", style: .default, handler: { (action) -> Void in
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if let url = url , UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
        
        result(.denied)
        }
        
    }
}


extension IndexSet {
    
    func convertToIndexPaths(appendIndex : NSInteger = 0) -> [NSIndexPath] {
        
        var indexPaths = [NSIndexPath]()
        
        for index in self{
            
            indexPaths.append(NSIndexPath.init(item: index + appendIndex, section: 0))
        }
        
        return indexPaths
    }
}


extension UIImage {
    
    func cropPoster() -> UIImage {
        
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return maskedImage
    }

}






