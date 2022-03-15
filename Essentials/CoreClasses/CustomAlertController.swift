//
//  CustomAlertController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 25/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CustomAlertController: UIAlertController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    class func showAlertWithOk(forTitle title: String, message: String,sender: UIViewController, okTitle: String = "OK".localized, okCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (okAlertAction) in
            if okCompletion != nil {
                okCompletion!()
            }
        }
        alertController.addAction(okAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithOkCancel(forTitle title: String, message: String,sender: UIViewController, okTitle: String = "OK".localized, cancelTitle: String = "Cancel".localized, okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .destructive) { (okAlertAction) in
            if okCompletion != nil {
                okCompletion!()
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            if cancelCompletion != nil {
                cancelCompletion!()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithYesNo(forTitle title: String, message: String,sender: UIViewController, okTitle: String = "Yes".localized, cancelTitle: String = "No".localized, okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .destructive) { (okAlertAction) in
            if okCompletion != nil {
                okCompletion!()
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            if cancelCompletion != nil {
                cancelCompletion!()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithCustomTitle(forTitle title: String, message: String,sender: UIViewController, okTitle: String , cancelTitle: String , okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .destructive) { (okAlertAction) in
            if okCompletion != nil {
                okCompletion!()
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            if cancelCompletion != nil {
                cancelCompletion!()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        sender.present(alertController, animated: true, completion: nil)
    }
 
    class func showActionSheet(forTitle title: String, message: String, sender: UIViewController, withActionTitles actionTitles: [String], isCancellable: Bool = true, completion: ((_ selectedTitleIndex: Int) -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, singleTitle) in actionTitles.enumerated() {
            let action = UIAlertAction(title: singleTitle, style: .default, handler: { (action) in
                if completion != nil {
                    completion!(index)
                }
            })
            alertController.addAction(action)
        }
        if isCancellable {
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender.view
            popoverController.sourceRect = CGRect(x: sender.view.bounds.midX, y: sender.view.bounds.minX + 260, width: 0, height: 0)
        }
        sender.present(alertController, animated: true, completion: nil)
    }
}
