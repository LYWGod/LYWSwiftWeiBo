//
//  LYWNetworkingManager.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/25.
//

import AFNetworking

enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class LYWNetworkingManager : AFHTTPSessionManager {
    
    static let shareInstance : LYWNetworkingManager = {
        let baseUrl : NSURL = NSURL(string: "")!
        let manager = SwiftWeiBo.LYWNetworkingManager.init(baseURL: baseUrl as URL, sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer.acceptableContentTypes?.insert("text/json")
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.responseSerializer.acceptableContentTypes?.insert("text/JavaScript")
        return manager
    }()
    
}


extension LYWNetworkingManager {
    
    func request(type:RequestType,urlString:String,parame:Any?,finished:@escaping(_ result:Any?,_ error:Error?)->()) {
        
        let successCallBack = { (task:URLSessionDataTask, result:Any?) in finished(result,nil)}
        
        let failureCallBack = { (task:URLSessionDataTask?, error:Error) in finished(nil,error)}
        
        if type == .GET {
            get(urlString, parameters: parame, progress: nil, success: successCallBack, failure: failureCallBack)
        }else{
            post(urlString, parameters: parame, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}


extension LYWNetworkingManager {
    
    func requestAccesstoken(code:String,finished:@escaping(_ result:[String:AnyObject]?,_ error:Error?)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let parame = ["client_id" : appKey, "client_secret" : appSecret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        
        request(type: .POST, urlString: urlString, parame: parame) { (result:Any?, error:Error?) in
            finished(result as? [String : AnyObject],error)
        }
    }
    
    
    func requestAccountInfo(token:String,uid:String,finished:@escaping(_ result:[String:AnyObject]?,_ error:Error?)->()) {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parame = ["access_token" : token,"uid":uid]
     
        request(type: .GET, urlString: urlString, parame: parame) { (result:Any?, error:Error?) in
            finished(result as? [String : AnyObject],error)
        }
    }

    
    func requestList(since_id:Int,max_id:Int,finished:@escaping(_ result:[[String:AnyObject]]?,_ error : Error?)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parame = ["access_token" : (LYWUserAccountViewModel.shareIntance.account?.access_token)!,
                      "since_id" : "\(since_id)",
                      "max_id": "\(max_id)"]
        
        request(type: .GET, urlString: urlString, parame: parame) { (result :Any?, error:Error?) in
            
            guard let statusDict = result as? [String : AnyObject] else{ return
            }
            guard let statusArray = statusDict["statuses"] else { return }
            
            finished((statusArray as! [[String : AnyObject]]),error)
        }
                          
    }
    
}

