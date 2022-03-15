//
//  HistoryCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 06/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import FloatRatingView

class HistoryCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblName: CoreLabel!
    @IBOutlet weak var lblAddress: CoreLabel!
    @IBOutlet weak var lblDate: CoreLabel!
    @IBOutlet weak var lblDay: CoreLabel!
    @IBOutlet weak var lblTime: CoreLabel!
    @IBOutlet weak var btnChat: CoreButton!
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var btnStart: CoreButton!
    @IBOutlet weak var btnCancel: CoreButton!
    @IBOutlet weak var btnRate: CoreButton!
    @IBOutlet weak var backView: UIView!
    
    var history: AppointmentHistory? {
        didSet {
            lblName.text = history?.customer_name
            lblAddress.text = history?.address
            lblDate.text = history?.date
            lblDay.text = history?.day
            lblTime.text = history?.start_time
            rateView.rating = history?.rate?.toDouble ?? 0
            if UserDefaults.standard.role_id == 0 {
                if history?.rateandreviews_status == false && history?.appointment_status == 2 {
                    btnCancel.isHidden = true
                    btnStart.isHidden = true
                    btnRate.isHidden = false
                    btnRate.alpha = 1
                    btnRate.isUserInteractionEnabled = true
                } else if history?.rateandreviews_status ?? false && history?.appointment_status == 2 {
                    btnCancel.isHidden = true
                    btnStart.isHidden = true
                    btnRate.isHidden = true
                    btnRate.alpha = 0.5
                    btnRate.isUserInteractionEnabled = false
                } else if history?.appointment_status == 0 {
                    btnStart.isHidden = true
                    btnCancel.isHidden = false
                    btnRate.isHidden = true
                } else if history?.appointment_status == 3 {
                    btnCancel.isHidden = true
                    btnStart.isHidden = true
                    btnRate.isHidden = true
                }
            } else {
                if history?.appointment_status == 2 {
                    btnCancel.isHidden = true
                    btnStart.isHidden = true
                    btnRate.isHidden = true
                } else if history?.appointment_status == 3 {
                    btnCancel.isHidden = true
                    btnStart.isHidden = true
                    btnRate.isHidden = true
                } else if history?.appointment_status == 1 {
                    btnStart.setTitle("END APPOINTMENT", for: .normal)
                    btnCancel.isHidden = true
                    btnRate.isHidden = true
                }
            }            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.setShdowSpecificCorner(shadowColor: .gray, borderColor: .clear, radius: 0.3, opacity: 0.3, cornerRadius: [], offset: CGSize(0, 2))
    }
}
