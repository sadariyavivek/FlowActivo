//
//  CustomerProfileCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 07/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CustomerProfileCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: CoreImageView!
    @IBOutlet weak var txtLastName: AppTextField!
    @IBOutlet weak var txtFirstName: AppTextField!
    @IBOutlet weak var txtUserName: AppTextField!
    @IBOutlet weak var txtCountry: CorePickerTextField!
    @IBOutlet weak var txtState: CorePickerTextField!
    @IBOutlet weak var txtZipcode: AppTextField!
    @IBOutlet weak var btnCreateProfile: CoreButton!
    @IBOutlet weak var txtCity: CorePickerTextField!
    @IBOutlet weak var txtPhone: AppTextField!
    @IBOutlet weak var txtaddress: AppTextField!
    @IBOutlet weak var lblfirstName: CoreLabel!
    @IBOutlet weak var lblLastname: CoreLabel!
    @IBOutlet weak var lblusername: CoreLabel!
    @IBOutlet weak var lblAddress: CoreLabel!
    @IBOutlet weak var lblZipCode: CoreLabel!
    @IBOutlet weak var lblPhone: CoreLabel!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var lblEmail: CoreLabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCityMsg: CoreLabel!
    @IBOutlet weak var lblStateMsg: CoreLabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCountyMsg: CoreLabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    var user: UserData? {
        didSet {
            txtFirstName.text = user?.firstname
            txtLastName.text = user?.lastname
            txtUserName.text = user?.username
            txtEmail.text = user?.email
            txtaddress.text = user?.address
            txtPhone.text = user?.phone?.formattedNumber()
            txtZipcode.text = user?.zipcode
            txtCountry.text = user?.country
            txtState.text = user?.state
            txtCity.text = user?.city
            let urlString = user?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imgProfile.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewWidth.constant = Constants.isIphone() ? 120 : 150
        imgViewHeight.constant = Constants.isIphone() ? 120 : 150
        imgProfile.cornerRadius = Double((imgViewHeight.constant / 2))
    }
}
