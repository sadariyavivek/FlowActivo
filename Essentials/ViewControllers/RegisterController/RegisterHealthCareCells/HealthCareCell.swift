//
//  HealthCareCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class HealthCareCell: CoreTableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgView: CoreImageView!
    @IBOutlet weak var txtFirstName: AppTextField!
    @IBOutlet weak var txtLastName: AppTextField!
    @IBOutlet weak var txtUserName: AppTextField!
    @IBOutlet weak var txtPasswork: AppTextField!
    @IBOutlet weak var txtConfirmPassword: AppTextField!
    @IBOutlet weak var txtDesc: CoreTextView!
    @IBOutlet weak var btnContinue: CoreButton!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtCategory: CorePickerTextField!
    @IBOutlet weak var lblFirstName: CoreLabel!
    @IBOutlet weak var lblLastname: CoreLabel!
    @IBOutlet weak var lblUsername: CoreLabel!
    @IBOutlet weak var lblEmail: CoreLabel!
    @IBOutlet weak var lblPassword: CoreLabel!
    @IBOutlet weak var lblConfirmPass: CoreLabel!
    @IBOutlet weak var lblDescLine: UILabel!
    @IBOutlet weak var lblDesc: CoreLabel!
    @IBOutlet weak var btnPassword: CoreButton!
    @IBOutlet weak var btnConfirmPass: CoreButton!
    @IBOutlet weak var lblCategory: CoreLabel!
    @IBOutlet weak var lblCategoryMsg: CoreLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewWidth.constant = Constants.isIphone() ? 120 : 150
        imgViewHeight.constant = Constants.isIphone() ? 120 : 150
        imgView.cornerRadius = Double((imgViewHeight.constant / 2))
    }
}
