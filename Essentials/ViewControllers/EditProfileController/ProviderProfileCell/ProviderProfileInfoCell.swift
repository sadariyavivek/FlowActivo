//
//  ProviderProfileInfoCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class ProviderProfileInfoCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtBusinessName: AppTextField!
    @IBOutlet weak var txtAddress: AppTextField!
    @IBOutlet weak var txtCountry: CorePickerTextField!
    @IBOutlet weak var txtState: CorePickerTextField!
    @IBOutlet weak var txtCity: CorePickerTextField!
    @IBOutlet weak var txtzipCode: AppTextField!
    @IBOutlet weak var txtPhone: AppTextField!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblBusinessName: CoreLabel!
    @IBOutlet weak var lblAddress: CoreLabel!
    @IBOutlet weak var imgMon: UIImageView!
    @IBOutlet weak var btnMon: CoreButton!
    @IBOutlet weak var imgTue: UIImageView!
    @IBOutlet weak var btnTue: CoreButton!
    @IBOutlet weak var imgWed: UIImageView!
    @IBOutlet weak var btnWed: CoreButton!
    @IBOutlet weak var imgThu: UIImageView!
    @IBOutlet weak var btnThu: CoreButton!
    @IBOutlet weak var imgFri: UIImageView!
    @IBOutlet weak var btnFri: CoreButton!
    @IBOutlet weak var imgSat: UIImageView!
    @IBOutlet weak var btnSat: CoreButton!
    @IBOutlet weak var imgSun: UIImageView!
    @IBOutlet weak var btnSun: CoreButton!
    @IBOutlet weak var btnContinue: CoreButton!
    @IBOutlet weak var lblZIpcode: CoreLabel!
    @IBOutlet weak var lblPhoneNumber: CoreLabel!
    @IBOutlet weak var txtMon: CoreDatePickerTextField!
    @IBOutlet weak var txtTue: CoreDatePickerTextField!
    @IBOutlet weak var txtWed: CoreDatePickerTextField!
    @IBOutlet weak var txtThur: CoreDatePickerTextField!
    @IBOutlet weak var txtFri: CoreDatePickerTextField!
    @IBOutlet weak var txtSat: CoreDatePickerTextField!
    @IBOutlet weak var txtSun: CoreDatePickerTextField!
    @IBOutlet weak var lblMon: CoreLabel!
    @IBOutlet weak var lblTue: CoreLabel!
    @IBOutlet weak var lblWed: CoreLabel!
    @IBOutlet weak var lblThur: CoreLabel!
    @IBOutlet weak var lblFri: CoreLabel!
    @IBOutlet weak var lblSat: CoreLabel!
    @IBOutlet weak var lblSun: CoreLabel!
    @IBOutlet weak var txtEndMon: CoreDatePickerTextField!
    @IBOutlet weak var txtEndTue: CoreDatePickerTextField!
    @IBOutlet weak var txtEndWed: CoreDatePickerTextField!
    @IBOutlet weak var txtEndThur: CoreDatePickerTextField!
    @IBOutlet weak var txtEndFri: CoreDatePickerTextField!
    @IBOutlet weak var txtEndSat: CoreDatePickerTextField!
    @IBOutlet weak var txtEndSun: CoreDatePickerTextField!
    @IBOutlet weak var lblEndMon: CoreLabel!
    @IBOutlet weak var lblEndTue: CoreLabel!
    @IBOutlet weak var lblEndWed: CoreLabel!
    @IBOutlet weak var lblEndThur: CoreLabel!
    @IBOutlet weak var lblEndFri: CoreLabel!
    @IBOutlet weak var lblEndSat: CoreLabel!
    @IBOutlet weak var lblEndSun: CoreLabel!
    
    private var lblArray = [CoreLabel]()
    
    var user: UserData? {
        didSet {
            lblArray = [lblMon, lblEndMon, lblTue, lblEndTue, lblWed, lblEndWed, lblThur, lblEndThur, lblFri, lblEndFri, lblSat, lblEndSat, lblSun, lblEndSun]
            txtBusinessName.text = user?.businessname
            txtAddress.text = user?.address
            txtCountry.text = user?.country
            txtState.text = user?.state
            txtCity.text = user?.city
            txtzipCode.text = user?.zipcode
            txtPhone.text = user?.phone?.formattedNumber()
            if #available(iOS 13.0, *) {
                let check = UIImage(systemName: "checkmark.square.fill")
                let unCheck = UIImage(systemName: "app")
                imgMon.image =  user?.monday == 1 ? check : unCheck
                imgTue.image =  user?.tuesday == 1 ? check : unCheck
                imgWed.image =  user?.wednesday == 1 ? check : unCheck
                imgThu.image =  user?.thursday == 1 ? check : unCheck
                imgFri.image =  user?.friday == 1 ? check : unCheck
                imgSat.image =  user?.saturday == 1 ? check : unCheck
                imgSun.image =  user?.sunday == 1 ? check : unCheck
            } else {}
            btnMon.isSelected = user?.monday == 1
            btnTue.isSelected = user?.tuesday == 1
            btnWed.isSelected = user?.wednesday == 1
            btnThu.isSelected = user?.thursday == 1
            btnFri.isSelected = user?.friday == 1
            btnSat.isSelected = user?.saturday == 1
            btnSun.isSelected = user?.sunday == 1
            lblMon.text = user?.monday_start_time != "" ? user?.monday_start_time ?? "" : "closed".uppercased()
            lblEndMon.text = user?.monday_end_time != "" ? user?.monday_end_time ?? "" : "closed".uppercased()
            lblTue.text = user?.tuesday_start_time != "" ? user?.tuesday_start_time ?? "" : "closed".uppercased()
            lblEndTue.text = user?.tuesday_end_time != "" ? user?.tuesday_end_time ?? "" : "closed".uppercased()
            lblWed.text = user?.wednesday_start_time != "" ? user?.wednesday_start_time ?? "" : "closed".uppercased()
            lblEndWed.text = user?.wednesday_end_time != "" ? user?.wednesday_end_time ?? "" : "closed".uppercased()
            lblThur.text = user?.thursday_start_time != "" ? user?.thursday_start_time ?? "" : "closed".uppercased()
            lblEndThur.text = user?.thursday_end_time != "" ? user?.thursday_end_time ?? "" : "closed".uppercased()
            lblFri.text = user?.friday_start_time != "" ? user?.friday_start_time ?? "" : "closed".uppercased()
            lblEndFri.text = user?.friday_end_time != "" ? user?.friday_end_time ?? "" : "closed".uppercased()
            lblSat.text = user?.saturday_start_time != "" ? user?.saturday_start_time ?? "" : "closed".uppercased()
            lblEndSat.text = user?.saturday_end_time != "" ? user?.saturday_end_time ?? "" : "closed".uppercased()
            lblSun.text = user?.sunday_start_time != "" ? user?.sunday_start_time ?? "" : "closed".uppercased()
            lblEndSun.text = user?.sunday_end_time != "" ? user?.sunday_end_time ?? "" : "closed".uppercased()
            
            for lbl in lblArray {
                lbl.textColor = lbl.text == "closed".uppercased() ? .systemRed : .black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtMon.timeMinimumDate = nil
        txtTue.timeMinimumDate = nil
        txtWed.timeMinimumDate = nil
        txtThur.timeMinimumDate = nil
        txtFri.timeMinimumDate = nil
        txtSat.timeMinimumDate = nil
        txtSun.timeMinimumDate = nil
        txtEndMon.timeMinimumDate = nil
        txtEndTue.timeMinimumDate = nil
        txtEndWed.timeMinimumDate = nil
        txtEndThur.timeMinimumDate = nil
        txtEndFri.timeMinimumDate = nil
        txtEndSat.timeMinimumDate = nil
        txtEndSun.timeMinimumDate = nil
    }
}
