//
//  XTAlbumViewController.swift
//  XTAssetsPickerDemo
//
//  Created by tion126 on 16/9/24.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import UIKit
import Photos

let kXTAlbumTableViewCell = "kXTAlbumTableViewCell"

class XTAlbumViewController: UIViewController {

    var datas : [String : XTAlbumTableViewCellEntity] = [:]
    var manager  : XTAssetsManager! = XTAssetsManager.sharedInstance
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topConstraint.constant = (-SCREEN_HEIGHT) * 0.6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadPosterImage()
    }

    
    func loadPosterImage() -> Void {
        
        for index in 0..<self.manager.collections.count{
            
            let asset    = self.manager.collections[index].posterAsset()
            let entity   = XTAlbumTableViewCellEntity()
            entity.count = self.manager.collections[index].count()
            entity.title = self.manager.collections[index].localizedTitle
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width:  120, height: 120), contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                
                let value = info?["PHImageResultIsDegradedKey"] as! Bool
                
                if !value {
                    
                    let crop        = image?.cropPoster()
                    entity.image    = crop
                    self.datas["\(index)"] = entity
                }
            })
        }
        
    }
    
    func showTableView() -> Void {
        
        topConstraint.constant = 0;
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
        }
    }

    
    @IBAction func dismissVC() {
        
        topConstraint.constant = SCREEN_HEIGHT * 0.6;
        
        UIView.animate(withDuration: 0.3, animations: {
                
            self.view.layoutIfNeeded()
        }) { (finish) in
            
            self.dismiss(animated: false, completion:nil)
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dismissVC()
    }
    
}


extension XTAlbumViewController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.manager.collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: kXTAlbumTableViewCell) as! XTAlbumTableViewCell
        cell.alpha = 1.0
        let entity = self.datas["\(indexPath.row)"]
        
        guard self.check(entity: entity) else {
            
            let asset = self.manager.collections[indexPath.row].posterAsset()
            let entity1   = XTAlbumTableViewCellEntity()
            entity1.count = self.manager.collections[indexPath.row].count()
            entity1.title = self.manager.collections[indexPath.row].localizedTitle
            
            cell.titleLab.text = entity1.title
            cell.countLab.text = "\(entity1.count ?? 0)"
            
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width:  120, height: 120), contentMode: .aspectFill, options: nil, resultHandler: { (image, info ) in
                
                let value = info?["PHImageResultIsDegradedKey"] as! Bool
                
                if !value {
                    
                    let crop = image?.cropPoster()
                    cell.imgView.image = crop
                    entity1.image      = crop
                    self.datas["\(indexPath.row)"] = entity1
                }
            })
            
            return cell
        }
        
        cell.titleLab.text = entity!.title
        cell.countLab.text = "\(entity!.count ?? 0)"
        cell.imgView.image = entity!.image
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismissVC()
        manager!.loadAssets(collection: manager!.collections[indexPath.row])
    }
    
    
    func check(entity : XTAlbumTableViewCellEntity?) -> Bool {
        
        return !(entity == nil || entity!.image == nil || entity!.count == nil || entity!.title == nil)
    }

}


class XTAlbumTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var countLab: UILabel!

}


class XTAlbumTableViewCellEntity : NSObject{
    
    open var image : UIImage?
    open var count : NSInteger?
    open var title : String?
    
}




