//
//  ExpandAnimator.swift
//  CustomSegmentedSections
//
//  Created by vamsi krishna reddy kamjula on 10/19/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import Foundation
import UIKit

class ExpandAnimator: NSObject, UIViewControllerTransitioningDelegate {

    static var animator = ExpandAnimator()
    
    enum ExpandTransitionMode: Int {
        case Present, Dismiss
    }
    
    let presentDuration = 0.4
    let dismissDuration = 0.15
    
    var openingFrame: CGRect?
    var transitionMode: ExpandTransitionMode = .Present
    
    var topView: UIView!
    var bottomView: UIView!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (transitionMode == .Present) {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // From ViewController
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let fromViewFrame = fromViewController.view.frame
        
        // TO ViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        // Container View
        let containerView = transitionContext.containerView
        
        if (transitionMode == .Present) {
            // Get top view using resizableSnapshotviewFromRect
            topView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(openingFrame!.origin.y, 0, 0, 0))
            topView.frame = CGRect(x: 0, y: 0, width: fromViewFrame.width, height: openingFrame!.origin.y)
            
            // Add top view to container
            containerView.addSubview(topView)
            
            // Get bottom using resizableSnapshotviewFromRect
            bottomView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, fromViewFrame.height - openingFrame!.origin.y - openingFrame!.height, 0))
            bottomView.frame = CGRect(x: 0, y: openingFrame!.origin.y + openingFrame!.height, width: fromViewFrame.width, height: fromViewFrame.height - openingFrame!.origin.y - openingFrame!.height)
            
            // Add bottom view to container
            containerView.addSubview(bottomView)
            
            // Take a snapshot of the view controller and change its frame to opening frame
            let snapshotView = toViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
            snapshotView?.frame = openingFrame!
            containerView.addSubview(snapshotView!)
            
            toViewController.view.alpha = 0.0
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: presentDuration, animations: {
                self.topView.frame = CGRect(x: 0, y: -self.topView.frame.height, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewFrame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                
                // Expand snapshot view to fill entire frame
                snapshotView?.frame = toViewController.view.frame
            }, completion: { (finished) -> Void in
                
                // Remove snapshot view from container view
                snapshotView?.removeFromSuperview()
                
                // Make to view controller visible
                toViewController.view.alpha = 1.0
                
                // Complete transition
                transitionContext.completeTransition(finished)
            })
        } else {
            let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
            containerView.addSubview(snapshotView!)
            
            fromViewController.view.alpha = 0.0
            
            UIView.animate(withDuration: dismissDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewController.view.frame.height - self.bottomView.frame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                snapshotView?.frame = self.openingFrame!
            }, completion: { (finished) in
                
                // Remove snapshot view from container view
                snapshotView?.removeFromSuperview()
                
                // make from view controller visible
                fromViewController.view.alpha = 1.0
                
                // Complete transition
                transitionContext.completeTransition(finished)
            })
        }
    }
}
