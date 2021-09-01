//
//  UserAccount.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/20.
//

import UIKit

class LYWUserAccount: NSObject ,NSSecureCoding{

    static var supportsSecureCoding: Bool = true
    ///授权access_token
    @objc var access_token : String?
    ///用户UID
    @objc var uid : String?
    ///过期日期
    @objc var expires_in : TimeInterval = 0.0 {
        didSet{
            expires_date = NSDate(timeIntervalSinceNow:expires_in)
        }
    }
    
    ///额外添加的属性
    ///过期日期
    @objc var expires_date : NSDate = NSDate()
    /// 昵称
    @objc  var screen_name : String?
    /// 用户头像地址
    @objc var avatar_large : String?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","uid","expires_in"]).description
    }
    

    
    //解档
    required init(coder aDecoder:NSCoder){
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = (aDecoder.decodeObject(forKey: "expires_date") as? NSDate)!
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
}
