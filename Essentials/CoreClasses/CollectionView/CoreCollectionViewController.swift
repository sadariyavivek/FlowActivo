//
//  CoreCollectionViewController.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreCollectionViewController: UICollectionViewController {

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var navigationBarTintColor: UIColor = .blue {
        didSet {
            self.navigationController?.navigationBar.barTintColor = navigationBarTintColor
        }
    }
    var navigationTintColor: UIColor = .blue {
        didSet {
            self.navigationController?.navigationBar.tintColor = navigationTintColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
