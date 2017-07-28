//
//  XTPreviewTransition.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 2016/9/20.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import Foundation
import UIKit
import Photos

class XTPreviewTransition : NSObject {
    
    var operation : UINavigationControllerOperation?
    
    
}

extension XTPreviewTransition : UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if operation == .push {
            
            pushAnimation(transitionContext: transitionContext)
        }else if operation == .pop{
            
            popAnimation(transitionContext: transitionContext)
        }
    }
    
    
    //push animation
    func pushAnimation(transitionContext : UIViewControllerContextTransitioning) {
        
        let toVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! XTPreviewViewController
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)as! XTAssetsPickerViewController
        let containerView = transitionContext.containerView
        
        let assetCell   = fromVC.collectionView.cellForItem(at: NSIndexPath.init(item: fromVC.manager.index! + 1, section: 0) as IndexPath)
        let snapFromFrame = assetCell?.convert(assetCell!.bounds, to: containerView)
        var snapToFrame : CGRect = CGRect.zero
        let asset = fromVC.manager.assets[fromVC.manager.index!]
        let targetSize = CGSize.init(width: SCREEN_WIDTH * UIScreen.main.scale, height: SCREEN_HEIGHT * UIScreen.main.scale)
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            
            fromVC.snapView.image = image
            
            let imageViewHeight  = image!.size.height / image!.size.width * SCREEN_WIDTH
            
            if imageViewHeight > SCREEN_HEIGHT {
                
                let imageViewWidth  = image!.size.width / image!.size.height * SCREEN_HEIGHT
                snapToFrame = CGRect.init(x: 0, y: 0, width: imageViewWidth, height: SCREEN_HEIGHT)

            }else{
                
                snapToFrame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: imageViewHeight)
            }

            
        })
        
        fromVC.snapView.frame = snapFromFrame!
        fromVC.view.frame = containerView.frame
        fromVC.snapView.isHidden = false
        toVC.view.frame = containerView.frame
        toVC.view.alpha = 0
        toVC.collectionView.isHidden = true
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(0)), animations: {
            
            fromVC.snapView.frame  = snapToFrame
            fromVC.snapView.center = containerView.center
            fromVC.collectionView.alpha  = 0
            fromVC.titleButton.alpha     = 0
            }) { (finished) in
            toVC.view.alpha = 1
            fromVC.titleButton.alpha     = 1
            toVC.collectionView.isHidden = false
            fromVC.collectionView.alpha  = 1
            fromVC.snapView.isHidden     = true
            transitionContext.completeTransition(true)
        }
        
    }
    
    func popAnimation(transitionContext : UIViewControllerContextTransitioning) {
        
        
        let toVC    = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! XTAssetsPickerViewController
        let fromVC  = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)as! XTPreviewViewController
        let containerView = transitionContext.containerView
        let manager : XTAssetsManager! = fromVC.manager
        toVC.collectionView.scrollToItem(at: NSIndexPath.init(item:manager.index! + 1, section: 0) as IndexPath, at: .centeredVertically, animated: false)
        toVC.collectionView.layoutIfNeeded()
        
        let assetCell     = toVC.collectionView.cellForItem(at: NSIndexPath.init(item:manager.index! + 1, section: 0) as IndexPath)
        var snapFromFrame = CGRect.zero
        let snapToFrame   = assetCell?.convert(assetCell!.bounds, to: containerView)
        let asset = manager.assets[manager.index!]
        let targetSize = CGSize.init(width: SCREEN_WIDTH * UIScreen.main.scale, height: SCREEN_HEIGHT * UIScreen.main.scale)
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            
            toVC.snapView.image = image
            
            let imageViewHeight  = image!.size.height / image!.size.width * SCREEN_WIDTH
            
            if imageViewHeight > SCREEN_HEIGHT {
                
                let imageViewWidth  = image!.size.width / image!.size.height * SCREEN_HEIGHT
                snapFromFrame = CGRect.init(x: 0, y: 0, width: imageViewWidth, height: SCREEN_HEIGHT)
                
            }else{
                
                snapFromFrame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: imageViewHeight)
            }
        })
        
        toVC.snapView.frame  = snapFromFrame
        toVC.snapView.isHidden = false
        toVC.snapView.center = containerView.center
        assetCell?.isHidden  = true
        toVC.view.frame      = containerView.frame
        toVC.collectionView.alpha = 0
        toVC.titleButton.alpha    = 0
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(0)), animations: {
            
            toVC.snapView.frame  = snapToFrame!
            fromVC.collectionView.alpha = 0
            toVC.collectionView.alpha   = 1
            toVC.titleButton.alpha      = 1
        }) { (finished) in
            assetCell?.isHidden = false
            toVC.collectionView.isHidden = false
            toVC.snapView.isHidden     = true
            transitionContext.completeTransition(true)
        }

    }
    
}


class XTSnapView: UIImageView {
    
    
}





