//
//  LYWStatusViewModel.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/22.
//

import UIKit

class LYWStatusViewModel: NSObject {

    @objc var status : LYWStatus?

    ///来源
    @objc var sourceText : String?
    ///时间
    @objc var creatTime : String?
    ///认证
    @objc var verifiedImage : UIImage?
    ///VIP
    @objc var vipImage : UIImage?
    ///头像URL
    @objc var profile_image_url : URL?
    ///昵称
    @objc var screen_name : String?
    ///配图
    @objc var picUrls : [URL] = [URL]()
    ///cell高度
    @objc var cellHeight : CGFloat = 0.0
    
    init(status:LYWStatus){
        super.init()
        self.status = status
        //处理来源
        if let source = status.source, source != "" {
            let startIndex = (source as NSString).range(of: ">").location + 1
            let endIndex = (source as NSString).range(of: "</").location
            self.sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: endIndex - startIndex))
        }
        //时间
        if let created_at = status.created_at {
            self.creatTime = NSDate.creatDateString(dateStr: created_at)
        }
        
        
        //认证
        let verified_type = status.user?.verified_type ?? -1
        
        switch verified_type {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        //VIP
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        //头像
        let profile_image_url = status.user?.profile_image_url ?? ""
        self.profile_image_url = URL(string: profile_image_url)
        //昵称
        let screen_name = status.user?.screen_name ?? ""
        self.screen_name = screen_name

        //配图  (如果原创微博没有图片，则去转发微博里面取图片)
        let picUrls = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picUrls = picUrls {
            for urlDict in picUrls {
                guard let urlString = urlDict["thumbnail_pic"] else {
                    continue
                }
                guard let url = URL(string: urlString) else {
                    continue
                }
                self.picUrls.append(url)
            }
        }
        
        
    }
}
