//
//  VisiterView.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit

let nibName : String = "VisiterView"

class VisiterView: UIView {

    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var registBtn: UIButton!
    
    class func visiterView() -> VisiterView {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as! VisiterView
    }

    func setupVisitorInfo(tipLabMessage:String,iconName:String) {
        iconImage.image = UIImage(named: iconName)
        tipLabel.text = tipLabMessage
        rotationView.isHidden = true
    }
    
    func addRotationAnimation() {
     let momAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
         momAnimation.fromValue = 0
        momAnimation.toValue = Double.pi * 2
        momAnimation.duration = 3
        momAnimation.repeatCount = MAXFLOAT//无限重复
        momAnimation.isRemovedOnCompletion = false
        rotationView.layer.add(momAnimation, forKey: nil)

    }
}
