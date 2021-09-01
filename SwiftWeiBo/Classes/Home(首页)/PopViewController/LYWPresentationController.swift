//
//  LYWPresentationController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/26.
//

import UIKit

class LYWPresentationController: UIPresentationController {

    private lazy var coverView : UIView = UIView()
    
    var presentedViewFrame : CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = presentedViewFrame
//        CGRect(x: 100, y: 85, width: 180, height: 250)
        setupCoverView()
    }
}

extension LYWPresentationController {
    private func setupCoverView(){
        
        containerView?.insertSubview(coverView, at: 0)
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.frame
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LYWPresentationController.tapClick))
        coverView.addGestureRecognizer(tap)
        
    }
}

extension LYWPresentationController {
    @objc func tapClick(){
        
        presentedViewController.dismiss(animated: true, completion: nil)
        
    }
}
