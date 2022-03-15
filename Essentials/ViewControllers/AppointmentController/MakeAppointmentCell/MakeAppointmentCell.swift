//
//  MakeAppointmentCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 21/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class MakeAppointmentCell: CoreTableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var lblDate: CoreLabel!
    @IBOutlet weak var btnSubmit: CoreButton!
    @IBOutlet weak var txtComment: CoreTextView!
    @IBOutlet weak var lblAddrss: CoreLabel!
    @IBOutlet weak var lblTime: CoreLabel!
    @IBOutlet weak var lblError: CoreLabel!
    @IBOutlet weak var btnRequest: CoreButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
