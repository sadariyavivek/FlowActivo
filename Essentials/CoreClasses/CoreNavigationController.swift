//
//  CoreNavigationController.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//


import UIKit

class CoreNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    var navigationBarTintColor: UIColor = .blue {
        didSet {
            navigationBar.barTintColor = navigationBarTintColor
        }
    }
    var navigationTintColor: UIColor = .blue {
        didSet {
            navigationBar.tintColor = navigationTintColor
        }
    }
    
    var navigationBarTitleColor: UIColor = .white {
        didSet {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navigationBarTitleColor]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {   
        if fromVC is SideMenuVC {
            if operation == .pop {
                return FadePopAnimator(type: .navigation, duration: 0.3)
            }
        }
        return nil
    }
}

open class FadePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public enum TransitionType {
        case navigation
        case modal
    }

    let type: TransitionType
    let duration: TimeInterval

    public init(type: TransitionType, duration: TimeInterval = 0.25) {
        self.type = type
        self.duration = duration
        super.init()
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            return
        }

        if self.type == .navigation, let toViewController = transitionContext.viewController(forKey: .to) {
            
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension UINavigationController {

    func removeAnyViewControllers(ofKind kind: AnyClass) {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }

    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}
