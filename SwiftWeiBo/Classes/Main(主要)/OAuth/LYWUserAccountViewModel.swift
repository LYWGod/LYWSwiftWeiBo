//
//  LYWUserAccountViewModel.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/21.
//

import UIKit

class LYWUserAccountViewModel {

    static let shareIntance : LYWUserAccountViewModel = LYWUserAccountViewModel()
   
    //用户信息模型
    var account : LYWUserAccount?
    
    var acccountPath : String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (path as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogined : Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else { return false }
        
        return expiresDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    
    init() {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: acccountPath))
            account = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! LYWUserAccount)
        } catch let error {
            print(error)
        }

    }
    
}
