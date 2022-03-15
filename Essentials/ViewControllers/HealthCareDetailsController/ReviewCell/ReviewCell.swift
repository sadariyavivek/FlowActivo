//
//  ReviewCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import FloatRatingView

class ReviewCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var floatView: FloatRatingView!
    @IBOutlet weak var lblName: CoreLabel!
    @IBOutlet weak var lblDate: CoreLabel!
    @IBOutlet weak var lblDesc: CoreLabel!
        
    //MARK:- Properties
    var reviews: Rateandreviews_data? {
        didSet {
            guard let reviews = reviews else { return  }
            lblName.text = reviews.name
            lblDate.text = reviews.date
            lblDesc.text = reviews.review
            floatView.rating = Double(integerLiteral: Int64(reviews.rate ?? "0") ?? 0)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
