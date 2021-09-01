//
//  UIButton-Extension.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit


extension UIButton {
    convenience init(bgImageName:String,ImageName:String) {
        self.init()
        setImage(UIImage(named: ImageName), for: .normal)
        setImage(UIImage(named: ImageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor:UIColor,fontSize:CGFloat,title:String) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
