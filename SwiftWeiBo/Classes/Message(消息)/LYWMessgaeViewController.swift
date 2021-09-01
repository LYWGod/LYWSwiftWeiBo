//
//  LYWMessgaeViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit

class LYWMessgaeViewController: LYWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visiterView.setupVisitorInfo(tipLabMessage: "登录后，别人评论你的微博，给你发消息，都会在这里收到", iconName:"visitordiscover_image_message")
        navigationItem.title = "消息"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
