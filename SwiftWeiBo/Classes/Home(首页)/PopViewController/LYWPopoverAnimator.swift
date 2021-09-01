//
//  LYWPopoverAnimator.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/27.
//

import UIKit

class LYWPopoverAnimator: NSObject {
    var isPresend : Bool = false
    var presentedViewFrame : CGRect = CGRect.zero
    var callBack : ((_ presented : Bool)->())?
    
    init(callBack:@escaping (_ presented : Bool)->()){
        self.callBack = callBack
    }

}


extension LYWPopoverAnimator : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
       let presentation = LYWPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedViewFrame = presentedViewFrame
        return presentation
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresend = true
        callBack!(isPresend)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresend = false
        callBack!(isPresend)
        return self
    }
    
}

extension LYWPopoverAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresend ? presentedAnimation(transitionContext: transitionContext) : disMissAnimation(transitionContext: transitionContext)
   
    }
    
    func presentedAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        let presentedView = transitionContext.view(forKey: .to)!
        
        transitionContext.containerView.addSubview(presentedView)
        
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            presentedView.transform = .identity
        } completion: { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    func disMissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let dismissView = transitionContext.view(forKey: .from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
        } completion: { (_) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
