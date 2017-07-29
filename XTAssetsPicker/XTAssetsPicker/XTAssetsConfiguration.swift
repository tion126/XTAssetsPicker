//
//  XTAssetsConfiguration.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 16/9/12.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import Foundation
import UIKit

public class XTAssetsConfiguration: NSObject {

    /**
     * number of item in each row
     */
    public var numberOfColum : NSInteger = 4
    /**
     * maxminum number of photo
     */
    public var maxminumCount : NSInteger = 5
    /**
     * show camera
     */
    
    //UI
    
    public var selectButtonColor : UIColor = UIColor.init(red: 104/255, green: 173/255, blue: 204/255, alpha: 1)
    
    public var closeButtonColor  : UIColor = UIColor.black
    
    public var gridViewBackgroundColor : UIColor = UIColor.white
    
    public var titleColor                      : UIColor  = UIColor.black
    
    public var previewBackgroundColor_Normal   : UIColor  = UIColor.white
    
    public var previewBackgroundColor_Selected : UIColor  = UIColor.black
    
 
}
