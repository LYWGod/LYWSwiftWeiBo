//
//  LYWBaseViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit

class LYWBaseViewController: UITableViewController {

    lazy var visiterView = VisiterView.visiterView()
    
    var isLogined : Bool = LYWUserAccountViewModel.shareIntance.isLogined
    
    
    override func loadView() {
        
        isLogined ? super.loadView() : setupVisiterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


extension LYWBaseViewController {
    
    private func setupVisiterView() {
        view = visiterView
        setupNavBarItem()
        visiterView.loginBtn.addTarget(self, action: #selector(loginBtnItemClick), for: .touchUpInside)
        visiterView.registBtn.addTarget(self, action: #selector(registBtnItemClick), for: .touchUpInside)

    }
    
    private func setupNavBarItem () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registBtnItemClick))
    }
}

extension LYWBaseViewController {
    @objc private func loginBtnItemClick () {
        print("登录")
        let oauthVc = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func registBtnItemClick () {
        print("注册")
    }
}
