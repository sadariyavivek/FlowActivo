//
//  ProviderProfileCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class ProviderProfileCell: CoreTableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgView: CoreImageView!
    @IBOutlet weak var txtFirstName: AppTextField!
    @IBOutlet weak var txtLastName: AppTextField!
    @IBOutlet weak var txtUserName: AppTextField!
    @IBOutlet weak var txtDesc: CoreTextView!
    @IBOutlet weak var btnContinue: CoreButton!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtCategory: CorePickerTextField!
    @IBOutlet weak var lblFirstName: CoreLabel!
    @IBOutlet weak var lblLastname: CoreLabel!
    @IBOutlet weak var lblDescLine: UILabel!
    @IBOutlet weak var lblDesc: CoreLabel!
    @IBOutlet weak var lblCategory: CoreLabel!
    @IBOutlet weak var lblCategoryMsg: CoreLabel!
    
    var user: UserData? {
        didSet {
            txtFirstName.text = user?.firstname
            txtLastName.text = user?.lastname
            txtUserName.text = user?.username
            txtEmail.text = user?.email
            txtCategory.text = user?.healthcarecategory
            txtDesc.text = user?.service_description
            let urlString = user?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewWidth.constant = Constants.isIphone() ? 120 : 150
        imgViewHeight.constant = Constants.isIphone() ? 120 : 150
        imgView.cornerRadius = Double((imgViewHeight.constant / 2))
    }
}
