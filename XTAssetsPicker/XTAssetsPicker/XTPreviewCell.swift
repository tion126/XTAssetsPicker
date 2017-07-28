//
//  XTPreviewCell.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 2016/9/20.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol XTPreviewCellDeleagte : class {
    
    func singleTapImageView()
}

class XTPreviewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var contentScrollView : UIScrollView!
    @IBOutlet weak var imageView         : UIImageView!
    @IBOutlet weak var imageViewH        : NSLayoutConstraint!
    
    let targetSize                       : CGSize = CGSize.init(width: SCREEN_WIDTH * UIScreen.main.scale, height: SCREEN_HEIGHT * UIScreen.main.scale)
    
    var asset : PHAsset?{
        
        didSet{
            
            self.contentScrollView.zoomScale = 1.0
            
            PHImageManager.default().requestImage(for: asset!, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                
                self.imageView.image     = image
               // let imageViewH           = image!.size.height / image!.size.width * SCREEN_WIDTH
               //self.imageViewH.constant = imageViewH
            })
        }
    }
    
    
    weak var delegate : XTPreviewCellDeleagte?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap) )
        singleTap.numberOfTapsRequired = 1
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap) )
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        self.contentScrollView.addGestureRecognizer(singleTap)
        self.contentScrollView.addGestureRecognizer(doubleTap)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}

extension XTPreviewCell : UIScrollViewDelegate{
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }
    
    
    func handleSingleTap(tap : UITapGestureRecognizer){
        self.delegate?.singleTapImageView()
    }
     
    func handleDoubleTap(tap : UITapGestureRecognizer){
        
        let touchPoint = tap.location(in: self.contentView)
        
        if self.contentScrollView.zoomScale == self.contentScrollView.maximumZoomScale {
            
            self.contentScrollView.setZoomScale(self.contentScrollView.minimumZoomScale, animated: true)
        }else{
            self.contentScrollView.zoom(to: CGRect.init(origin: touchPoint, size: CGSize.init(width: 1, height: 1)), animated: true)
        }
    }
    
}
