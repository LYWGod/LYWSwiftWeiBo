//
//  LYWWelcomeViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/21.
//

import UIKit
import Kingfisher

class LYWWelcomeViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var bottomLayoutCOnstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subTitleLab: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        iconImageView.layer.cornerRadius = 60
        iconImageView.layer.masksToBounds = true
        
        subTitleLab.text = LYWUserAccountViewModel.shareIntance.account?.screen_name
        
        guard let iconUrlString = LYWUserAccountViewModel.shareIntance.account?.avatar_large else { return  }
        
        let url = URL(string: iconUrlString)
        
        iconImageView.kf.setImage(with: url, placeholder: UIImage(named: "avatar_default_big"), options: [], progressBlock: nil, completionHandler: nil)
        
        //修改头像底部的约束
        bottomLayoutCOnstraint.constant = UIScreen.main.bounds.size.height - 350
        
        //设置上下弹动头像动画
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: []) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }


}
