//
//  NotificationCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 10/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class NotificationCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblDesc: CoreLabel!
    @IBOutlet weak var lblTitle: CoreLabel!
    @IBOutlet weak var lblDate: CoreLabel!
    @IBOutlet weak var backView: UIView!
    
    var notifi: NotificationModal? {
        didSet {
            lblTitle.text = notifi?.title
            lblDesc.text = notifi?.message
            lblDate.text = notifi?.created_at
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.setShdowSpecificCorner(shadowColor: .gray, borderColor: .clear, radius: 0.3, opacity: 0.3, cornerRadius: [], offset: CGSize(0, 1))
    }
}
