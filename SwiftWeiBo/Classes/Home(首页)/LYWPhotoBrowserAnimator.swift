//
//  LYWPhotoBrowserAnimator.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/4/28.
//

import UIKit

protocol LYWPhotoBrowserAnimatorPresentedDelegate : NSObjectProtocol {
    func presentedImageView(indexPath:NSIndexPath) -> UIImageView
    func startRectForPresentedView(indexPath:NSIndexPath) -> CGRect
    func endRectForPresentedView(indexPath:NSIndexPath) -> CGRect
}

protocol LYWPhotoBrowserAnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDismiss() -> IndexPath
    func dissmissImageView() -> UIImageView
}

class LYWPhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    var indexPath : NSIndexPath?
    
    var presentedDelegate : LYWPhotoBrowserAnimatorPresentedDelegate?
    var dissmissDelegate : LYWPhotoBrowserAnimatorDismissDelegate?
}


extension LYWPhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension LYWPhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animateTransitionForPresented(transitionContext: transitionContext) :
            animateTransitionForDismiss(transitionContext: transitionContext) 
    }
    
    func animateTransitionForPresented(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let indexPath = indexPath else { return }
        guard let presentedDelegate = presentedDelegate else { return }
        guard let presentedView = transitionContext.view(forKey: .to) else { return }
        transitionContext.containerView.addSubview(presentedView)
        
        //通过代理拿到开始的尺寸 结束尺寸 做动画的图片
        let startRect = presentedDelegate.startRectForPresentedView(indexPath: indexPath)
        let endRect = presentedDelegate.endRectForPresentedView(indexPath: indexPath)
        let pictureImageView = presentedDelegate.presentedImageView(indexPath: indexPath)
        
        transitionContext.containerView.addSubview(pictureImageView)

        pictureImageView.frame = startRect
        
        presentedView.alpha = 0
        
        transitionContext.containerView.backgroundColor = UIColor.black
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            pictureImageView.frame = endRect
        } completion: { (_) in
            pictureImageView.removeFromSuperview()
            presentedView.alpha = 1
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    func animateTransitionForDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let dissmissView = transitionContext.view(forKey: .from) else { return }
        dissmissView.removeFromSuperview()
        
        guard let dissmissDelegate = dissmissDelegate else { return }
        guard let presentedDelegate = presentedDelegate else { return }

        let pictureImageView = dissmissDelegate.dissmissImageView()
        transitionContext.containerView.addSubview(pictureImageView)
        
        let indexPath = dissmissDelegate.indexPathForDismiss()
        
        let startRect = presentedDelegate.startRectForPresentedView(indexPath: indexPath as NSIndexPath)
    
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            pictureImageView.frame = startRect
        } completion: { (_) in
            pictureImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}
