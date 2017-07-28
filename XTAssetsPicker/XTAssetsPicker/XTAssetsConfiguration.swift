//
//  XTAssetsConfiguration.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 16/9/12.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import Foundation
import UIKit

class XTAssetsConfiguration: NSObject {

    /**
     * number of item in each row
     */
    var numberOfColum : NSInteger = 4
    /**
     * maxminum number of photo
     */
    var maxminumCount : NSInteger = 5
    /**
     * show camera
     */
    
    //UI
    
    var selectButtonColor : UIColor = UIColor.init(red: 104/255, green: 173/255, blue: 204/255, alpha: 1)
    
    var closeButtonColor  : UIColor = UIColor.black
    
    var gridViewBackgroundColor : UIColor = UIColor.white
    
    var titleColor                      : UIColor  = UIColor.black
    
    var previewBackgroundColor_Normal   : UIColor  = UIColor.white
    
    var previewBackgroundColor_Selected : UIColor  = UIColor.black
    
 
}
