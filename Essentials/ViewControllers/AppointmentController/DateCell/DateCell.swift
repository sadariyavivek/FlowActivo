//
//  DateCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class DateCell: CoreCollectionViewCell {

    @IBOutlet weak var lblMonth: CoreLabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblDayName: CoreLabel!
    @IBOutlet weak var lblDate: CoreLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
