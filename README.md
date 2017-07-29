XTAssetsPicker
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/tion126/XTAssetsPicker/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/XTAssetsPicker.svg?style=flat)](http://cocoapods.org/pods/XTAssetsPicker)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/XTAssetsPicker.svg?style=flat)](http://cocoadocs.org/docsets/XTAssetsPicker)&nbsp;


Usage
==============

### Simple Usage
```swift

    func show() {
        
        let config = XTAssetsConfiguration()
        config.maxminumCount = 5
        config.numberOfColum = 3
        self.presentAssetsPicker(configuration: config, delegate: self)
    }
    
    func didFinishPickingAssets(assets: [PHAsset]) {
        
        self.datas.append(contentsOf: assets)
        self.tableView.reloadData()
    }

```

Installation
==============

### CocoaPods

1. Add `pod 'XTAssetsPicker'` to your Podfile.
2. Run `pod install` or `pod update`.
3. import XTAssetsPicker.

![gif](https://raw.githubusercontent.com/tion126/XTAssetsPicker/master/Untitled1.gif)
