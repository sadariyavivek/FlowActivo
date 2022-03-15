//
//  LoadMoreCollectionReusableView.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class LoadMoreCollectionReusableView: CoreCollectionReusableView {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
}
