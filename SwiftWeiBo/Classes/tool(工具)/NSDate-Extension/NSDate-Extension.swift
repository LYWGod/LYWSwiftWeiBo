//
//  NSDate-Extension.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/22.
//

import Foundation

extension NSDate {
    class func creatDateString(dateStr:String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        
        guard let creatDate = fmt.date(from: dateStr) else { return "" }
        
        let nowDate = NSDate()
        
        let InterVal = nowDate.timeIntervalSince(creatDate)
        
        if InterVal < 60 { return "刚刚" }

        if InterVal < (60 * 60) { return "\(Int(InterVal) / 60)分钟前" }
        
        if InterVal < (60 * 60 * 24)  { return "\(Int(InterVal) / (60 * 60))小时前" }
            
        let calendar = NSCalendar.current
 
        if calendar.isDateInYesterday(creatDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let time = fmt.string(from: creatDate)
            return time
        }

        
        let gap = calendar.dateComponents([Calendar.Component.year], from: creatDate, to: nowDate as Date)
    
        if gap.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.string(from: creatDate)
        }
    
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        return fmt.string(from: creatDate)
        
    }
}
