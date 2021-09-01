//
//  LYWMainViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit

class LYWMainViewController: UITabBarController {

    
    private lazy var composeBtn : UIButton = UIButton(bgImageName: "tabbar_compose_button", ImageName: "tabbar_compose_icon_add")
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupComposeBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

extension LYWMainViewController {
    
    private func setupComposeBtn() {
        
        composeBtn.center = CGPoint(x: tabBar.frame.size.width * 0.5, y: tabBar.frame.size.height * 0.5)
        
        tabBar.addSubview(self.composeBtn)
        
        composeBtn.addTarget(self, action:#selector(compostBtnClick), for: .touchUpInside)
        
    }
    
}

extension LYWMainViewController {
    @objc private func compostBtnClick (){
        
        let composeVc = LYWComposeViewController()
        
        let nav = UINavigationController(rootViewController: composeVc)
        
        nav.modalPresentationStyle = .fullScreen
    
        present(nav, animated: true, completion: nil)
    }
}
