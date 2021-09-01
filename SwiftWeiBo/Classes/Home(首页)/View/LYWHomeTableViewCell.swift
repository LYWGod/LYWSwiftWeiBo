//
//  LYWHomeTableViewCell.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/22.
//

import UIKit
import Kingfisher
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class LYWHomeTableViewCell: UITableViewCell {
    ///来源
    @IBOutlet weak var sourceLabel: UILabel!
    ///时间
    @IBOutlet weak var timeLab: UILabel!
    ///昵称
    @IBOutlet weak var nickNameLab: UILabel!
    ///头像
    @IBOutlet weak var iconImgeView: UIImageView!
    ///正文
    @IBOutlet weak var textLab: UILabel!
    ///vip
    @IBOutlet weak var avatarVipImageView: UIImageView!
    ///会员登记
    @IBOutlet weak var commonImageView: UIImageView!
    ///collectionView
    @IBOutlet weak var collectionView: LYWPictureCollectionView!
    ///collectionView宽度
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint!
    ///collectionView高度
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    ///转发微博正文
    @IBOutlet weak var retweetLabel: UILabel!
    ///转发微博背景
    @IBOutlet weak var retweetBgView: UIView!
    ///collectionView的底部约束
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    ///转发微博的顶部约束
    @IBOutlet weak var retweetLabelTopConstraint: NSLayoutConstraint!
    ///底部工具栏
    @IBOutlet weak var bottomToolView: UIView!
    
    var statusViewModel : LYWStatusViewModel?{
        didSet{
            guard let statusViewModel = statusViewModel else { return }
            //来源
            if let sourceText = statusViewModel.sourceText {
                self.sourceLabel.text = "来自" + sourceText
            }else{
                self.sourceLabel.text = nil
            }
            
            //正文
            self.textLab.text = statusViewModel.status?.text
            //时间
            self.timeLab.text = statusViewModel.creatTime
            //昵称
            self.nickNameLab.text = statusViewModel.screen_name
            //认证
            self.commonImageView.image = statusViewModel.verifiedImage
            //VIP
            self.avatarVipImageView.image = statusViewModel.vipImage
            //头像
            self.iconImgeView.kf.setImage(with: statusViewModel.profile_image_url, placeholder: UIImage(named: "avatar_default_small"), options: [], progressBlock: nil, completionHandler: nil)
            //昵称颜色
            self.nickNameLab.textColor = statusViewModel.vipImage == nil ? UIColor.orange : UIColor.black
            //collectionView的尺寸
            let collectionViewSize = setupCollectionViewSize(count: statusViewModel.picUrls.count)
            self.collectionViewWidthConstraint.constant = collectionViewSize.width
            self.collectionViewHeightConstraint.constant = collectionViewSize.height

            collectionView.picUrls = statusViewModel.picUrls //给collectionView图片
            
            //转发微博
            if statusViewModel.status?.retweeted_status != nil ,let screenName =  statusViewModel.status?.user?.screen_name{
                self.retweetLabel.text = "@\(screenName)" + (statusViewModel.status?.retweeted_status?.text)!
                self.retweetBgView.isHidden = false
                self.retweetLabelTopConstraint.constant = 15
            }else{
                self.retweetLabel.text = nil
                self.retweetBgView.isHidden = true
                self.retweetLabelTopConstraint.constant = 0
            }
            
            //强制布局
            layoutIfNeeded()
            //计算cell高度
            if statusViewModel.cellHeight == 0 {
                let cellHeight = bottomToolView.frame.maxY
                statusViewModel.cellHeight = cellHeight
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImgeView.layer.cornerRadius = 20
        iconImgeView.layer.masksToBounds = true
        selectionStyle = .none
    }
    
}

extension LYWHomeTableViewCell {
    private func setupCollectionViewSize(count:Int) -> CGSize {
        if count == 0 {
            collectionViewBottomConstraint.constant = 0
            return CGSize.zero
        }
    
        collectionViewBottomConstraint.constant = 10
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //1张配图
        if count == 1 {

            let urlString = statusViewModel?.picUrls.last?.absoluteString
                
            guard let url = urlString else {
                return CGSize.zero
            }
        
            guard let image = SDImageCache.shared.imageFromCache(forKey: url) else {
                return CGSize.zero
            }
 
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
            
        }
        
        //图片的宽高
        let imageWH = (UIScreen.main.bounds.size.width - 2 * edgeMargin - 2 * itemMargin)/3
        
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        
        //四张配图
        if count == 4 {
            let pictureWH = imageWH * 2 + itemMargin
            return CGSize(width: pictureWH, height: pictureWH)
        }
        //其他张配图
        let row = CGFloat((count - 1) / 3 + 1)
        let pictureH = row * imageWH + (row - 1) * itemMargin
        let pictureW = UIScreen.main.bounds.size.width - 2 * edgeMargin
        return CGSize(width: pictureW, height: pictureH)
    }
}
