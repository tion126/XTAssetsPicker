//
//  XTAssetsPickerViewController.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 16/9/11.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import UIKit
import Photos

let kXTAssetsCell = "kXTAssetsCell"
let kXTCameraCell = "kXTCameraCell"


class XTAssetsPickerViewController: UIViewController {
    
    var manager : XTAssetsManager! = XTAssetsManager.sharedInstance
    @IBOutlet weak var titleButton   : XTTitleButton!
    @IBOutlet weak var snapView      : XTSnapView!
    @IBOutlet weak var bottomView    : XTBottomCountView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeItem     : UIBarButtonItem!
    let picker : UIViewController = UIStoryboard(name: "XTAssetsPicker", bundle: Bundle.init(for: XTAssetsManager.self)).instantiateViewController(withIdentifier: "XTAlbumViewController")
    lazy var transition : XTPreviewTransition = {
        return XTPreviewTransition()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    deinit {

        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        
        manager.reload()
        self.navigationController?.delegate = self
        self.collectionView.backgroundColor = self.manager.config?.gridViewBackgroundColor
        self.titleButton.setTitle(self.manager.collection!.localizedTitle, for: .normal)
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 54, 0)
        self.closeItem.tintColor = self.manager.config?.closeButtonColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAssets), name: NSNotification.Name(rawValue: kXTAssetReloadNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCount), name: NSNotification.Name(rawValue: kXTAssetRefreshStatusNotification), object: nil)
    }
    
    
    @IBAction func dismiss(_ sender: AnyObject) {
        
        self.navigationController?.dismiss(animated: true, completion: {
            
            self.manager.cancel()
        })
    }
    
    @IBAction func showAlbumView() {
        
        self.present(picker, animated: false, completion: nil)
    }
    
    func reloadAssets(notification : NSNotification){
        
        let ctx          = notification.object as! [String : AnyObject]
        let resetOffset  = ctx["resetOffset"] as! Bool
        let changes      = ctx["changes"] as? PHFetchResultChangeDetails
        
        self.titleButton.setTitle(self.manager.collection!.localizedTitle, for: .normal)
        
        if resetOffset {
            
            self.collectionView.contentOffset = CGPoint.init(x: 0, y: -64)
        }
        
        if changes == nil || !(changes?.hasIncrementalChanges)! || (changes?.hasMoves)! {
            
            self.collectionView.reloadSections(NSIndexSet.init(index: 0) as IndexSet)
            
        }else{
            
            
            let removePaths = changes?.removedIndexes?.convertToIndexPaths(appendIndex : 1)
            let changePaths = changes?.changedIndexes?.convertToIndexPaths(appendIndex : 1)
            var tree = false
            
            if removePaths != nil && changePaths != nil {
                
                let filteredArray = removePaths!.filter() { changePaths!.contains($0) }
                
                if filteredArray.count > 0{
                    
                    tree = true
                }
            }
        
            
            if let removePaths  = removePaths{
                
                let indexPath = removePaths.last
                
                if indexPath!.item >= self.manager.assets.count + 1 {
                    
                    tree = true
                }
            }
            
            guard !tree else {
                
                self.collectionView.reloadData()
                return
            }
            
            self.collectionView.performBatchUpdates({
                
                
                if changes?.removedIndexes != nil {
                    
                    self.collectionView.deleteItems(at: removePaths! as [IndexPath])
                }
                
                if changes?.insertedIndexes != nil {
                    
                    self.collectionView.insertItems(at: changes!.insertedIndexes!.convertToIndexPaths(appendIndex : 1) as [IndexPath])
                }
                
                if changes?.changedIndexes != nil {

                    self.collectionView.reloadItems(at: changes!.changedIndexes!.convertToIndexPaths(appendIndex : 1) as [IndexPath])
                }
                
            }, completion: { (complete) in
                
                
            })
        }
        
    }
    
    func refreshCount() {
        
        self.bottomView.setCount(count: self.manager.assetsCount())
    }
    
    @IBAction func selectComplete() {
        
        self.navigationController?.dismiss(animated: true, completion: {
            
            self.manager.selectComplete()
        })
    }
    
}


extension XTAssetsPickerViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return manager.assets!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kXTCameraCell, for: indexPath)
            return cell
        }else{
            
            let asset : PHAsset = manager.assets![indexPath.item - 1]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kXTAssetsCell, for: indexPath) as! XTAssetsCell
            cell.setAsset(asset: asset, targetSize: self.manager.assetThumbItemSize! , manager: self.manager)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return manager.assetThumbItemSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0{
            
            guard self.manager.selectedAssets.count < self.manager.config!.maxminumCount else {return}
            self.presentImagePicker(manager: self.manager)
        }else{
            
            self.manager.index = indexPath.item - 1
            let previewVC = UIStoryboard(name: "XTAssetsPicker", bundle: Bundle.init(for: XTAssetsManager.self)).instantiateViewController(withIdentifier: "XTPreviewViewController")
            self.navigationController?.show(previewVC, sender: nil)
        }
    }
}



extension XTAssetsPickerViewController : UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
            self.transition.operation = operation
            return self.transition
    }
}







