//
//  XTAssetsPickerCell.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 2016/9/18.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

protocol XTAssetsCellDelegate : class {
    
    
}

class XTAssetsCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var backImageView : UIImageView!
    var manager  : XTAssetsManager!  = XTAssetsManager.sharedInstance
    var delegate : XTAssetsCellDelegate?
    var asset    : PHAsset?
    
    
    func setAsset(asset : PHAsset ,targetSize : CGSize ,manager : XTAssetsManager) {
    
        self.asset   = asset
        self.manager = manager
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            self.backImageView.image = image
        })
        self.selectedButton.isSelected = self.manager.containsAsset(asset: asset)
    }
    
    @IBAction func assetSelected() {
        
        if self.selectedButton.isSelected {
            
            self.manager.deselectAsset(asset : self.asset!)
            self.selectedButton.isSelected = false
        }else{
            
            self.selectedButton.isSelected = self.manager.selectAsset(asset : self.asset!)
        }
        
    }
    
}



class XTCameraCell: UICollectionViewCell {
    
    var session      : AVCaptureSession?
    var videoInput   : AVCaptureDeviceInput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSession()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
    func initSession() {
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetLow
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{try device?.lockForConfiguration()}catch{}
        device?.unlockForConfiguration()
        
       // if let _ = device?.isFlashModeSupported(.off) {
            
         //   device?.flashMode = .off
        //}

        do{try videoInput = AVCaptureDeviceInput(device: device)}catch{}
        if session!.canAddInput(videoInput){session?.addInput(videoInput)}
        
        previewLayer = AVCaptureVideoPreviewLayer(session : session)
        previewLayer?.videoGravity = "AVLayerVideoGravityResizeAspectFill"
        previewLayer?.frame = bounds
        contentView.layer.masksToBounds = true
        contentView.layer.insertSublayer(previewLayer!, below: blurView.layer)
        
        session?.startRunning()
        
    }
    
}
