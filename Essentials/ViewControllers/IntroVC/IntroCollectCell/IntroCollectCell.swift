//
//  IntroCollectCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class IntroCollectCell: CoreCollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var lblDesc: CoreLabel!
    @IBOutlet weak var lblDetails: CoreLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

}
