//
//  LYWComposeViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit

class LYWComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBarItem()
        
        view.backgroundColor = UIColor.red

    }
    
}

extension LYWComposeViewController {
    
    private func setupNavBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(rightBarButtionItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftBarButtionItemClick))

    }
}

extension LYWComposeViewController {
    @objc private func rightBarButtionItemClick(){
        print("发送")
    }
    
    @objc private func leftBarButtionItemClick(){
        dismiss(animated: true, completion: nil)
    }
}
