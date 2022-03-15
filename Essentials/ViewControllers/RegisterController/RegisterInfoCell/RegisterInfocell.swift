//
//  RegisterInfocell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class RegisterInfocell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var addressMSGHeight: NSLayoutConstraint!
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
    @IBOutlet weak var hoursView: UIView!
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
