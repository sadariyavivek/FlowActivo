//
//  CoreRefreshControl.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreRefreshControl: UIRefreshControl {

    var pulledToRefresh: voidCompletion!
    
    func commonInit() {
        addTarget(self, action: #selector(refreshStart), for: .valueChanged)
        self.tintColor = .white
    }
    
    @objc private func refreshStart() {
        pulledToRefresh()
    }
    
    //MARK: - Init Methods
    override init() {
        super.init()
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}
