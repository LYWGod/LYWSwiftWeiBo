//
//  LYWPictureCollectionView.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/23.
//

import UIKit
import Kingfisher
import SDWebImage

let LYWPictureCollectionViewCellID = "LYWPictureCollectionViewCell"

class LYWPictureCollectionView: UICollectionView {
    
    
    @objc var picUrls : [URL] = [URL](){
        didSet{
            reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(UINib(nibName: LYWPictureCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: LYWPictureCollectionViewCellID)
        dataSource = self
        delegate = self
    }

}


extension LYWPictureCollectionView:UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LYWPictureCollectionViewCellID, for: indexPath) as! LYWPictureCollectionViewCell
        
        cell.pictureImageView.kf.setImage(with:picUrls[indexPath.item], placeholder: UIImage(named: "empty_picture"), options: [], progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        let userInfo = [ShowPhotoBrowserIndexPathKey:indexPath,ShowPhotoBrowserUrlsKey:picUrls] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNotification), object: self, userInfo: userInfo)
    }
}


extension LYWPictureCollectionView : LYWPhotoBrowserAnimatorPresentedDelegate {
    func presentedImageView(indexPath: NSIndexPath) -> UIImageView {
        let pictureImage = UIImageView()
        let picUrl = picUrls[indexPath.item]
        let picture = SDImageCache.shared.imageFromCache(forKey: picUrl.absoluteString)
        pictureImage.image = picture
        pictureImage.contentMode = .scaleAspectFill
        pictureImage.clipsToBounds = true

        return pictureImage
    }
    
    func startRectForPresentedView(indexPath: NSIndexPath) -> CGRect {
        let cell = self.collectionView(self, cellForItemAt: indexPath as IndexPath)
        
        let startRect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return startRect
    }
    
    func endRectForPresentedView(indexPath: NSIndexPath) -> CGRect {
        let picUrl = picUrls[indexPath.item]
        let picture = SDImageCache.shared.imageFromCache(forKey: picUrl.absoluteString)
        guard let pictureImage = picture else { return CGRect.zero }
        let width = UIScreen.main.bounds.size.width
        let x : CGFloat = 0
        var y : CGFloat = 0
        let height : CGFloat =  width / (pictureImage.size.width)  * (pictureImage.size.height)
        if height > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        return CGRect(x: x, y: y, width: width, height: height)
    
    }

//    func isiPhoneX() ->Bool {
//        let screenHeight = UIScreen.main.nativeBounds.size.height;
//        if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
//            return true
//        }
//        return false
//    }
}

