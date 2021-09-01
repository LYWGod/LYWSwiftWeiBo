//
//  OAuthViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/19.
//

import UIKit
import WebKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wkWebView.navigationDelegate = self
        
        setupNavBarItem()
        
        loadPage()
    }

}

extension OAuthViewController {
    private func setupNavBarItem() {
        title = "登录页面"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftBarButtonItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(rightBarButtionItemClick))
    }
    
    private func loadPage() {

        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL(string: urlString) else { return }
                    
        let request = URLRequest(url: url)
      
        wkWebView.load(request)
    }
}


extension OAuthViewController {
    @objc private func leftBarButtonItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func rightBarButtionItemClick() {
        print("填充")
//        let jsCode = "document.getElementById('userId').value='18365409623';document.getElementById('passwd').value='LYW201314lyw';"
        
//        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}




extension OAuthViewController : WKNavigationDelegate,WKUIDelegate {

    // 在发送请求之前，决定是否跳转 -> 默认允许
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow, preferences)
            return
        }

        let urlString = url.absoluteString

        guard urlString.contains("code=") else {
            decisionHandler(.allow, preferences)
            return
        }

        print("请求结果：\(urlString)")
        //请求结果：https://www.jianshu.com/u/0158007b8d17?code=7b38c35b1f269b3479d002652178f270

        let codeString = urlString.components(separatedBy: "code=").last

        loadAccessToken(code: codeString!)

        decisionHandler(.allow, preferences)
    }

}

extension OAuthViewController {
    
    func loadAccessToken(code:String) {

        LYWNetworkingManager.shareInstance.requestAccesstoken(code: code) { (result:[String : AnyObject]?, error:Error?) in
            
            if error != nil{
                print(error as Any)
                return
            }
            
            print(result as Any)
            //结果：Optional(["isRealName": true, "access_token": 2.00JmuLGEPd41CCa25a14d380eB2B5C, "uid": 3756029201, "expires_in": 157679999, "remind_in": 157679999])
        
            guard let accountDict = result else { return }
            
            let account = LYWUserAccount(dict: accountDict)
            ///请求用户信息
            self.loadAccountInfo(useAccount: account)
            
        }
    
    }
    
    func loadAccountInfo(useAccount:LYWUserAccount) {
        
        guard let token = useAccount.access_token else { return }
        
        guard let uid = useAccount.uid else { return }
        
        LYWNetworkingManager.shareInstance.requestAccountInfo(token:token,uid:uid) { (result:[String : AnyObject]?, error:Error?) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            print(result as Any)//头像
            
            guard let useInfoDict = result else { return }
            //昵称
            useAccount.screen_name = (useInfoDict["name"] as! String)
            //头像
            useAccount.avatar_large = (useInfoDict["avatar_large"] as! String)
        
            let archiverPath = LYWUserAccountViewModel.shareIntance.acccountPath
            print("路径：\(archiverPath)")
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: useAccount, requiringSecureCoding: true)
                try data.write(to: URL(fileURLWithPath: archiverPath))
            } catch (let err) {
                print(err)
            }

            LYWUserAccountViewModel.shareIntance.account = useAccount
            
            self.dismiss(animated: true) {
                UIApplication.shared.keyWindow?.rootViewController = LYWWelcomeViewController()
            }
        }
    }
    
}

