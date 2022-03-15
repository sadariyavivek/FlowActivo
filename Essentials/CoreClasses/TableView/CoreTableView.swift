//
//  CoreTableView.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//


import UIKit

class CoreTableView: UITableView {

    //MARK: - Controls
    private let collectionRefreshControl = CoreRefreshControl()
    
    //MARK: - Properties
    var didPullToRefresh: ((_ control: UIRefreshControl)->Void)? {
        didSet {
            if didPullToRefresh != nil {
                refreshControl = collectionRefreshControl                
                collectionRefreshControl.pulledToRefresh = {
                    self.didPullToRefresh?(self.collectionRefreshControl)
                }
            }
        }
    }
    var blockForTouchesBegan: ((_ touches: Set<UITouch>, _ event: UIEvent?)->Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        blockForTouchesBegan?((touches), event)
    }
    //MARK: - Init Methods
    func commonInit() {
        collectionRefreshControl.tintColor = .malibu
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        tableFooterView = UIView()
        separatorStyle = .none
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
