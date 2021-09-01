//
//  LYWPhotoBrowserCell.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/28.
//

import UIKit
import SDWebImage

protocol LYWPhotoBrowserCellDelegate : NSObjectProtocol {
    func ImageClick()
}

class LYWPhotoBrowserCell: UICollectionViewCell {
    
    private lazy var scrollView : UIScrollView = UIScrollView()
    
    lazy var imageView : UIImageView = UIImageView()
    
    var delegate : LYWPhotoBrowserCellDelegate?
    
    var url : URL?{
        didSet{
            guard let url = url else { return }
            
            let pictureImage = SDImageCache.shared.imageFromDiskCache(forKey: url.absoluteString)

            let pictureImageX : CGFloat = 0
            let pictureImageW = UIScreen.main.bounds.size.width
            let pictureImageH = (UIScreen.main.bounds.size.width ) * (pictureImage?.size.height)! / (pictureImage?.size.width)!  
            var pictureImageY : CGFloat = 0
            if (pictureImage?.size.height)! >  UIScreen.main.bounds.size.width{
                pictureImageY = 0
            }else{
                pictureImageY = (UIScreen.main.bounds.size.width - (pictureImage?.size.height)!) * 0.5
            }
            
            imageView.frame = CGRect(x:pictureImageX, y:pictureImageY, width: pictureImageW, height: pictureImageH)
            
            imageView.sd_setImage(with: getBeMiddleUrl(url: url), placeholderImage: pictureImage, options: []) { (current, total, _ ) in
                
            } completed: { (_, _, _, _) in
                
            }

            scrollView.contentSize = CGSize(width: 0, height: pictureImageH)

        
        }
    }
    
    private func getBeMiddleUrl(url:URL) -> URL {
        let urlString = url.absoluteString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: urlString)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LYWPhotoBrowserCell {
    private func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
}

extension LYWPhotoBrowserCell {
    @objc func tapClick(){
        guard let delegate = delegate else { return }
        delegate.ImageClick()
    }
}

