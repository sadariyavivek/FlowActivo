//
//  FilterCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 21/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class FilterCell: CoreTableViewCell {

    @IBOutlet weak var lblTitle: CoreLabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var lblCategory: CoreLabel!
    
    var recentSearch: RecentSearch? {
        didSet {
            lblTitle.text = recentSearch?.text
        }
    }
    
    var category: HealthCareCategory? {
        didSet {
            lblCategory.text = category?.type
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
           let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
           indicatorButton.setBackgroundImage(image, for: .normal)
           indicatorButton.tintColor = .black
        }
    }
}
extension UIView {
   var allSubviews: [UIView] {
      return subviews.flatMap { [$0] + $0.allSubviews }
   }
}
