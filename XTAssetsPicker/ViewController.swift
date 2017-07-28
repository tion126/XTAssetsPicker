//
//  ViewController.swift
//  XTAssetsPicker
//
//  Created by jaye on 2017/4/15.
//  Copyright © 2017年 Jaye. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,XTAssetsPickerDelegate {
    
    @IBAction func show() {
        
        let config = XTAssetsConfiguration()
        config.maxminumCount = 5
        config.numberOfColum = 4
        self.presentAssetsPicker(configuration: config, delegate: self)
    }

    func didFinishPickingAssets(assets : NSMutableArray){
        
        let alert = UIAlertController.init(title: "finish", message: nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction.init(title: "sure", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didCancel() {
        
        let alert = UIAlertController.init(title: "cancel", message: nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction.init(title: "sure", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didExceedMaximumNumberOfSelection(asset: PHAsset) {
        
        let alert = UIAlertController.init(title: "Exceed", message: nil, preferredStyle:.alert)
        alert.addAction(UIAlertAction.init(title: "sure", style: .default, handler: nil))
        self.presentedViewController?.present(alert, animated: true, completion: nil)
    }

}

