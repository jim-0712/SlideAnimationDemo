//
//  Animator.swift
//  Slide
//
//  Created by JimFu on 2022/1/4.
//

import UIKit
import Foundation

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}

final class ImageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval
    var image: UIImage
    var type: PresentationType
    var originalView: UIView
    var destView: UIView
    
    init(duration: TimeInterval, image: UIImage, type: PresentationType, originView: UIView, destView: UIView) {
        self.duration = duration
        self.image = image
        self.type = type
        self.originalView = originView
        self.destView = destView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
              let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                  transitionContext.completeTransition(false)
                  return }
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        //開始做動畫
        guard let imageScreenShot = originalView.snapshotView(afterScreenUpdates: true) else { return }

        toVC.view.alpha = type.isPresenting ? 0 : 1
        
        [imageScreenShot].forEach({ containerView.addSubview($0)})
        let imageRect = originalView.convert(originalView.bounds, to: toVC.view)
        [imageScreenShot].forEach({ $0.frame = imageRect })
        
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       options: .curveLinear) {
            imageScreenShot.frame = self.destView.convert(self.destView.bounds, to: toVC.view)
            
        } completion: { _ in
            
            imageScreenShot.removeFromSuperview()
            toVC.view.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
}
