//
//  LoadingView.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingView: NSObject {
    
    class func  showLoading() {
        let activityData = ActivityData(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: .ballSpinFadeLoader, color: .malibu, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
       
    class func hideLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
