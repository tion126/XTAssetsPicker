//
//  XTPreviewViewController.swift
//  XTAssetsPickerDemo
//
//  Created by jaye on 2016/9/20.
//  Copyright © 2016年 Jaye. All rights reserved.
//

import UIKit
import Photos

let kXTPreviewCell = "kXTPreviewCell"

class XTPreviewViewController: UIViewController {

    var manager : XTAssetsManager! = XTAssetsManager.sharedInstance
    var shouldScroll : Bool = true
    @IBOutlet weak var bottomView    : XTBottomCountView!
    @IBOutlet weak var selectButton  : XTSelectButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeItem     : UIBarButtonItem!
    override var prefersStatusBarHidden: Bool {
        get{
            
            return self.navigationController!.isToolbarHidden
        }
    }
    lazy var transition : XTPreviewTransition = {
        
        return XTPreviewTransition()
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor   = manager.config?.previewBackgroundColor_Normal
        self.closeItem.tintColor = self.manager.config?.closeButtonColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAssets), name: NSNotification.Name(rawValue: kXTAssetReloadNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCount), name: NSNotification.Name(rawValue: kXTAssetRefreshStatusNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshCount()
        
        if shouldScroll{
            self.collectionView.scrollToItem(at: NSIndexPath.init(item: self.manager.index!, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
            scrollViewDidScroll(self.collectionView)
            shouldScroll = false
        }
    }

    @IBAction func pop() {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAsset(_ button: UIButton) {
        
        if button.isSelected {
            
            self.manager.deselectAsset(asset : manager.assets[manager.index!])
            button.isSelected = false
        }else{
            
            button.isSelected = self.manager.selectAsset(asset : manager.assets[manager.index!])
        }
    }
    
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        

    }
    
    
    @IBAction func selectComplete() {
        
        self.navigationController?.dismiss(animated: true, completion: {
            
            self.manager.selectComplete()
        })
    }
    
    func refreshCount() {
        
        self.bottomView.setCount(count: self.manager.assetsCount())
    }
    
    func reloadAssets(notification : NSNotification){
        
        let ctx          = notification.object as! [String : AnyObject]
        let changes      = ctx["changes"] as? PHFetchResultChangeDetails
        
        
        if changes == nil || !(changes?.hasIncrementalChanges)! || (changes?.hasMoves)! || changes?.changedIndexes != nil{
            
            self.collectionView.reloadSections(NSIndexSet.init(index: 0) as IndexSet)
            
        }else{
            
            let removePaths = changes?.removedIndexes?.convertToIndexPaths()
            let changePaths = changes?.changedIndexes?.convertToIndexPaths()
            var tree = false
            
            if removePaths != nil && changePaths != nil {
                
                let filteredArray = removePaths!.filter() { changePaths!.contains($0) }
                
                if filteredArray.count > 0{
                    
                    tree = true
                }
            }
            
            
            if let removePaths  = removePaths{
                
                let indexPath = removePaths.last
                
                if indexPath!.item >= self.manager.assets.count {
                    
                    tree = true
                }
            }
            
            guard !tree else {
                
                self.collectionView.reloadData()
                return
            }
            
            self.collectionView.performBatchUpdates({
                
                
                if changes?.removedIndexes != nil {
                    
                    self.collectionView.deleteItems(at: changes!.removedIndexes!.convertToIndexPaths() as [IndexPath])
                }
                
                if changes?.insertedIndexes != nil {
                    
                    self.collectionView.insertItems(at: changes!.insertedIndexes!.convertToIndexPaths() as [IndexPath])
                }
                
                if changes?.changedIndexes != nil {
                    
                    self.collectionView.reloadItems(at: changes!.changedIndexes!.convertToIndexPaths() as [IndexPath])
                }
                
                }, completion: { (complete) in
                    
                    
            })
        }
        
    }
}


extension XTPreviewViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return manager.assets!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kXTPreviewCell, for: indexPath) as! XTPreviewCell
        cell.asset    = self.manager.assets[indexPath.item]
        cell.delegate = self
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: SCREEN_WIDTH + 20, height: SCREEN_HEIGHT)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.manager.index = NSInteger(scrollView.contentOffset.x / (SCREEN_WIDTH + 20))
        self.selectButton.isSelected = manager.containsAsset(asset: manager.assets[manager.index!])
    }
}

extension XTPreviewViewController : XTPreviewCellDeleagte{
    
    func singleTapImageView() {

        
        self.navigationController?.setToolbarHidden(!self.navigationController!.isToolbarHidden, animated: true)
        self.navigationController?.setNavigationBarHidden(!self.navigationController!.isNavigationBarHidden, animated: true)
        
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = self.navigationController!.isNavigationBarHidden ? self.manager.config?.previewBackgroundColor_Selected : self.manager.config?.previewBackgroundColor_Normal
        }
    }
    
    
}


extension XTPreviewViewController : UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.transition.operation = .push
        return self.transition
    }
}


