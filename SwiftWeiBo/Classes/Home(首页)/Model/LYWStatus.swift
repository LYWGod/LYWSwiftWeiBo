//
//  LYWStatus.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/22.
//

import UIKit

class LYWStatus: NSObject {
    ///创建时间
    @objc var created_at : String?
    ///来源
    @objc var source : String?
    ///正文
    @objc var text : String?
    ///微博mid
    @objc var mid : Int = 0
    ///配图
    @objc var pic_urls : [[String:String]]?
    ///用户
    @objc var user : LYWUser?
    
    @objc var retweeted_status : LYWStatus?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
        //用户模型
        if let userDict = dict["user"] as? [String : Any] {
            user = LYWUser(dict: userDict)
        }
        // 转发微博
        if let retweeted_statusDict = dict["retweeted_status"] as? [String : AnyObject]{
            retweeted_status = LYWStatus(dict: retweeted_statusDict)
        }
    
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    
}
