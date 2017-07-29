//
//  ViewController.swift
//  XTAssetsPicker
//
//  Created by jaye on 2017/4/15.
//  Copyright © 2017年 Jaye. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var datas : [PHAsset] = []
    
    @IBAction func show() {
        
        let config = XTAssetsConfiguration()
        config.maxminumCount = 5
        config.numberOfColum = 3
        self.presentAssetsPicker(configuration: config, delegate: self)
    }
    
}


extension ViewController : XTAssetsPickerDelegate {
    
    func didFinishPickingAssets(assets: [PHAsset]) {
        
        self.datas.append(contentsOf: assets)
        self.tableView.reloadData()
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

extension ViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DemoTableViewCell
        let asset = self.datas[indexPath.row]
        let date  = asset.creationDate
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell?.titleLab?.text = formatter.string(from: date!)
        
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width:  120, height: 120), contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                
                let crop                  = image?.cropPoster()
                cell?.imgView?.image    = crop
        })
        
        return cell!
    }
}


class DemoTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    
}

