//
//  XTCustomItems.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 16/9/12.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import Foundation
import UIKit


class XTTitleButton: UIButton {
    
    let config = XTAssetsManager.sharedInstance.config
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.adjustsImageWhenHighlighted = false
        self.setTitleColor(config?.titleColor, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labH = self.titleLabel?.frame.size.height
        let labW = self.titleLabel?.frame.size.width
        let labY = self.titleLabel?.frame.origin.y
        self.titleLabel?.frame = CGRect(x: 0, y: labY!, width: labW!, height: labH!)
        
        let imgW = self.imageView!.frame.size.width
        let imgH = self.imageView!.frame.size.height
        let imgY = self.imageView!.frame.origin.y
        self.imageView?.frame = CGRect(x: self.titleLabel!.frame.maxX + 3, y: imgY, width: imgW, height: imgH)
    }
    
}


class XTSelectButton: UIButton {
    
    let config = XTAssetsManager.sharedInstance.config

    override var isSelected: Bool{
        
        willSet{
            
            if newValue && !self.isSelected{
             
                let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
                popAnimation.duration = 0.4
                popAnimation.values = [
                    NSValue.init(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)),
                    NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
                    NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
                    NSValue.init(caTransform3D: CATransform3DIdentity)
                ]
                popAnimation.keyTimes = [0.0,0.33,0.66,1.0]
                popAnimation.timingFunctions = [
                    CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                ]
                self.imageView?.layer.add(popAnimation, forKey: nil)
            }
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setSelectedImage(color: config!.selectButtonColor)
    }
    
    func setSelectedImage(color : UIColor) {
        
        let slectedImage = self.imageView!.image!
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: slectedImage.size.width, height: slectedImage.size.height), false
            ,UIScreen.main.scale);
        let ctx = UIGraphicsGetCurrentContext();
        ctx!.addEllipse(in: CGRect.init(x: 1, y: 1, width: slectedImage.size.width - 2, height: slectedImage.size.height - 2));
        ctx!.setLineWidth(1);
        ctx?.setFillColor(color.cgColor)
        ctx?.drawPath(using: .fill)
        ctx!.strokePath();
        slectedImage.draw(at: CGPoint.zero)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.setImage(image, for: .selected)

    }
    
}


class XTBottomCountView: UIView {
    
    @IBOutlet weak var numberBackView : UIView!
    @IBOutlet weak var numberLab      : UILabel!
    @IBOutlet weak var completeButton : UIButton!
    dynamic var config : XTAssetsConfiguration? {
        
        willSet{
            
            self.numberBackView.backgroundColor = newValue?.selectButtonColor
            self.completeButton.setTitleColor(newValue?.selectButtonColor, for: .normal)
        }
    }
    
    func setCount(count : NSInteger) {
        
        guard count != NSInteger(self.numberLab.text!) else {return}
        
        if count <= 0{
            
            self.numberLab.isHidden       = true
            self.numberBackView.isHidden  = true
            self.completeButton.isEnabled = false
        }else{
            
            self.numberLab.isHidden       = false
            self.numberBackView.isHidden  = false
            self.completeButton.isEnabled = true
        }
        
        self.numberLab.text           = "\(count)"
        
        
        let popAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        popAnimation.duration = 0.4
        popAnimation.values = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue.init(caTransform3D: CATransform3DIdentity)
        ]
        popAnimation.keyTimes = [0.0,0.33,0.66,1.0]
        popAnimation.timingFunctions = [
            CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        ]
        
        self.numberBackView.layer.add(popAnimation, forKey: nil)
    }
}

