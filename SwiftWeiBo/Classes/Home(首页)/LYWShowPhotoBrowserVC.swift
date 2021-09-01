//
//  LYWShowPhotoBrowserVC.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/28.
//

import UIKit
import SnapKit
import SVProgressHUD
let photoBrowerCellID = "photoBrowerCell"

class LYWShowPhotoBrowserVC: UIViewController {

    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: LYWPhotoBrowseViewFlayout())
    
    private var saveBtn : UIButton = UIButton(bgColor: UIColor.lightGray, fontSize: 14, title: "保存")
    
    private var closeBtn : UIButton = UIButton(bgColor: UIColor.lightGray, fontSize: 14, title: "关闭")
    
    var indexPath : NSIndexPath

    var urls : [URL]
    
    init(indexPath:NSIndexPath,urls:[URL]) {
        
        self.indexPath = indexPath
        
        self.urls = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    
}

extension LYWShowPhotoBrowserVC {
    
    private func setupUI(){
        view.backgroundColor = .red
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        view.addSubview(closeBtn)
        collectionView.frame = view.bounds

        
        saveBtn.snp_makeConstraints { (make : ConstraintMaker) in
            make.right.equalTo(-40)
            make.bottom.equalTo(-30)
            make.size.equalTo(CGSize(width: 90, height: 30))
        }
        
        saveBtn.addTarget(self, action: #selector(LYWShowPhotoBrowserVC.saveBtnClick), for: .touchUpInside)
    
        closeBtn.snp_makeConstraints { (make : ConstraintMaker) in
            make.left.equalTo(20)
            make.size.equalTo(self.saveBtn.snp_size)
            make.bottom.equalTo(self.saveBtn.snp_bottom)
        }
        
        closeBtn.addTarget(self, action: #selector(LYWShowPhotoBrowserVC.closeBtnClick), for: .touchUpInside)
        
        collectionView.dataSource = self

        collectionView.register(LYWPhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowerCellID)
        
    }
    
}

extension LYWShowPhotoBrowserVC {
    @objc private func saveBtnClick() {
        
        let cell = collectionView.visibleCells.first as! LYWPhotoBrowserCell
        
        guard let picture = cell.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(picture, self, #selector(picture(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc private func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func picture(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

extension LYWShowPhotoBrowserVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowerCellID, for: indexPath) as! LYWPhotoBrowserCell
        
        cell.url = urls[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
}

extension LYWShowPhotoBrowserVC : LYWPhotoBrowserCellDelegate {
    func ImageClick() {
        closeBtnClick()
    }
}

extension LYWShowPhotoBrowserVC : LYWPhotoBrowserAnimatorDismissDelegate {
    func indexPathForDismiss() -> IndexPath {
        
        let cell  = collectionView.visibleCells.first
        
        return (collectionView.indexPath(for: cell!)! as NSIndexPath) as IndexPath
        
    }
    
    func dissmissImageView() -> UIImageView {
        let pictureImageView = UIImageView()
        
        let cell  = collectionView.visibleCells.first as! LYWPhotoBrowserCell
        
        pictureImageView.image = cell.imageView.image
        pictureImageView.frame = cell.imageView.frame
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.clipsToBounds = true
        
        return pictureImageView
    }
    
    
}

class LYWPhotoBrowseViewFlayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = (collectionView?.frame.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
