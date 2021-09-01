//
//  LYWUser.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/22.
//

import UIKit

class LYWUser: NSObject {
    ///用户头像
    @objc var profile_image_url : String?
    ///用户昵称
    @objc var screen_name : String?
    ///认证
    @objc var verified_type : Int = -1
    ///会员等级
    @objc var mbrank : Int = 0
    

    
    init(dict : [String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
