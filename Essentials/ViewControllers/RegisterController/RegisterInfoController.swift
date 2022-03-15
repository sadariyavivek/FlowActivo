//
//  RegisterInfoController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterInfoController: CoreViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tblView: CoreTableView!
    
    //MARK:- Properties
    private var countriesArray = [Country]()
    private var statesArray = [Country]()
    private var citiesArray = [Country]()
    private var countryNames = [String]()
    private var stateNames = [String]()
    private var cityNames = [String]()
    var userData = UserData(json: [:])!
    var coordinates = CLLocationCoordinate2D()
    var password : String?
    var isPostServices = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(RegisterInfocell.nib, forCellReuseIdentifier: RegisterInfocell.identifier)
        countryApiCall(isLoader: false, type: "Countries", countryID: nil, stateID: nil)
    }
    
    private func fillArray() {
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterInfocell {
            cell.txtCountry.dataSource = [countryNames]
            cell.txtState.dataSource = [stateNames]
            cell.txtCity.dataSource = [cityNames]
        }
    }
    
    // Validation
    private func isValid() -> Bool {
        var msg = ""
        var pickerArray : [CorePickerTextField]? = []
        var txtArray : [AppTextField]? = []
        var lblArry : [CoreLabel]? = []
        if self.userData.phone?.contains("-") ?? false {
            let newphone = self.userData.phone?.replacingOccurrences(of: "-", with: "")
            self.userData.phone = newphone
        }
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterInfocell {
            if userData.businessname == nil || userData.businessname == "" {
                msg = "Please enter business name."
                txtArray?.append(cell.txtBusinessName)
            } else if userData.address == nil || userData.address == "" {
                msg = "Please enter address."
                txtArray?.append(cell.txtAddress)
            } else if userData.country == nil || userData.country == "" {
                msg = "Please select country."
                pickerArray?.append(cell.txtCountry)
            } else if userData.state == nil || userData.state == "" {
                msg = "Please select state."
                pickerArray?.append(cell.txtState)
            } else if userData.city == nil || userData.city == "" {
                msg = "Please select city."
                pickerArray?.append(cell.txtCity)
            } else if userData.zipcode == nil || userData.zipcode == "" {
                msg = "Please enter zipcode."
                txtArray?.append(cell.txtzipCode)
            } else if !(userData.zipcode?.isPin ?? false) {
                msg = "Please enter valid zipcode."
                txtArray?.append(cell.txtzipCode)
            } else if userData.phone == nil || userData.phone == "" {
                msg = "Please enter phone number."
                txtArray?.append(cell.txtPhone)
            } else if !(userData.phone?.isPhoneNumber ?? false) {
                msg = "Please enter valid phone number."
                txtArray?.append(cell.txtPhone)
            } else if cell.btnMon.isSelected && userData.monday_start_time == nil || userData.monday_start_time == "" {
                msg = "Please select monday start time."
                lblArry?.append(cell.lblMon)
            } else if cell.btnMon.isSelected && userData.monday_end_time == nil || userData.monday_end_time == "" {
                msg = "Please select monday end time."
                lblArry?.append(cell.lblEndMon)
            } else if cell.btnTue.isSelected && userData.tuesday_start_time == nil || userData.tuesday_start_time == "" {
                msg = "Please select tuesday start time."
                lblArry?.append(cell.lblTue)
            } else if cell.btnTue.isSelected && userData.tuesday_end_time == nil || userData.tuesday_end_time == "" {
                msg = "Please select tuesday end time."
                lblArry?.append(cell.lblEndTue)
            } else if cell.btnWed.isSelected && userData.wednesday_start_time == nil || userData.wednesday_start_time == "" {
                msg = "Please select wednesday start time."
                lblArry?.append(cell.lblWed)
            } else if cell.btnWed.isSelected && userData.wednesday_end_time == nil || userData.wednesday_end_time == "" {
                msg = "Please select wednesday end time."
                lblArry?.append(cell.lblEndWed)
            } else if cell.btnThu.isSelected && userData.thursday_start_time == nil || userData.thursday_start_time == "" {
                msg = "Please select thursday start time."
                lblArry?.append(cell.lblThur)
            } else if cell.btnThu.isSelected && userData.thursday_end_time == nil || userData.thursday_end_time == "" {
                msg = "Please select thursday end time."
                lblArry?.append(cell.lblEndThur)
            } else if cell.btnFri.isSelected && userData.friday_start_time == nil || userData.friday_start_time == "" {
                msg = "Please select friday start time."
                lblArry?.append(cell.lblFri)
            } else if cell.btnFri.isSelected && userData.friday_end_time == nil || userData.friday_end_time == "" {
                msg = "Please select friday end time."
                lblArry?.append(cell.lblEndFri)
            } else if cell.btnSat.isSelected && userData.saturday_start_time == nil || userData.saturday_start_time == "" {
                msg = "Please select saturday start time."
                lblArry?.append(cell.lblSat)
            } else if cell.btnSat.isSelected && userData.saturday_end_time == nil || userData.saturday_end_time == "" {
                msg = "Please select saturday end time."
                lblArry?.append(cell.lblEndSat)
            } else if cell.btnSun.isSelected && userData.sunday_start_time == nil || userData.sunday_start_time == "" {
                msg = "Please select sunday start time."
                lblArry?.append(cell.lblSun)
            } else if cell.btnSun.isSelected && userData.sunday_end_time == nil || userData.sunday_end_time == "" {
                msg = "Please select sunday end time."
                lblArry?.append(cell.lblEndSun)
            }
        }
        if msg.count > 0 {
            hideShowErrorMsg(isError: true, msg: msg, txtArray: txtArray, pickerView: pickerArray, lable: lblArry)
            return false
        }
        hideShowErrorMsg(isError: false)
        return true
    }
    
    func hideShowErrorMsg(isError: Bool, msg: String? = nil, txtArray: [AppTextField]? = nil, pickerView: [CorePickerTextField]? = nil, lable: [CoreLabel]? = nil) {
        valueReturn()
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterInfocell {
            for txt in txtArray ?? [] {
                if txt == cell.txtBusinessName && isError {
                    cell.lblBusinessName.isHidden = isError ? false : true
                    cell.lblBusinessName.text = msg
                    cell.txtBusinessName.errorMessage = msg?.isEmpty ?? false ? "" : "Business Name"
                    cell.txtBusinessName.placeholder = msg?.isEmpty ?? false ? "Business Name": ""
                } else if txt == cell.txtAddress && isError {
                    cell.lblAddress.isHidden = isError ? false : true
                    cell.addressMSGHeight.constant = isError ? Constants.isIphone() ? 20 : 25 : 0
                    cell.lblAddress.text = msg
                    cell.txtAddress.errorMessage = msg?.isEmpty ?? false ? "" : "Address"
                    cell.txtAddress.placeholder = msg?.isEmpty ?? false ? "Address" : ""
                } else if txt == cell.txtzipCode && isError {
                    cell.lblZIpcode.isHidden = isError ? false : true
                    cell.lblZIpcode.text = msg
                    cell.txtzipCode.errorMessage = msg?.isEmpty ?? false ? "" : "zipcode".uppercased()
                    cell.txtzipCode.placeholder = msg?.isEmpty ?? false ? "zipcode".uppercased() : ""
                } else if txt == cell.txtPhone && isError {
                    cell.lblPhoneNumber.isHidden = isError ? false : true
                    cell.lblPhoneNumber.text = msg
                    cell.txtPhone.errorMessage = msg?.isEmpty ?? false ? "" : "phone number".uppercased()
                    cell.txtPhone.placeholder = msg?.isEmpty ?? false ? "phone number".uppercased() : ""
                } else {
                    cell.lblBusinessName.isHidden = true
                    cell.lblAddress.isHidden = true
                    cell.addressMSGHeight.constant = 0
                    cell.lblZIpcode.isHidden = true
                    cell.lblPhoneNumber.isHidden = true
                    cell.txtBusinessName.errorMessage = ""
                    cell.txtAddress.errorMessage = ""
                    cell.txtzipCode.errorMessage = ""
                    cell.txtPhone.errorMessage = ""
                    cell.txtBusinessName.placeholder = msg?.isEmpty ?? true ? "Business Name".uppercased() : ""
                    cell.txtAddress.placeholder = msg?.isEmpty ?? true ? "Address" : ""
                    cell.txtzipCode.placeholder = msg?.isEmpty ?? true ? "zipcode".uppercased() : ""
                    cell.txtPhone.placeholder = msg?.isEmpty ?? true ? "phone number".uppercased() : ""                    
                }
            }
            for txt in pickerView ?? [] {
                if txt == cell.txtCountry && isError {
                    //                    cell.lblCountry.isHidden = isError ? false : true
                    //                    cell.lblCountry.text = msg
                    cell.lblCountry.textColor = msg?.isEmpty ?? false ? .lightGray : .systemRed
                } else if txt == cell.txtState && isError {
                    //                    cell.lblState.isHidden = isError ? false : true
                    //                    cell.lblState.text = msg
                    cell.lblState.textColor = msg?.isEmpty ?? false ? .lightGray : .systemRed
                } else if txt == cell.txtCity && isError {
                    //                    cell.lblCity.isHidden = isError ? false : true
                    //                    cell.lblCity.text = msg
                    cell.lblCity.textColor = msg?.isEmpty ?? false ? .lightGray : .systemRed
                } else {
                    cell.lblCountry.textColor = .lightGray
                    cell.lblState.textColor = .lightGray
                    cell.lblCity.textColor = .lightGray
                }
            }
            for lbl in lable ?? [] {
                if lbl == cell.lblMon {
                    cell.lblMon.textColor = .systemRed; break
                } else if lbl == cell.lblEndMon {
                    cell.lblEndMon.textColor = .systemRed; break
                } else if lbl == cell.lblTue {
                    cell.lblTue.textColor = .systemRed; break
                } else if lbl == cell.lblEndTue {
                    cell.lblEndTue.textColor = .systemRed; break
                } else if lbl == cell.lblWed {
                    cell.lblWed.textColor = .systemRed; break
                } else if lbl == cell.lblEndWed {
                    cell.lblEndWed.textColor = .systemRed; break
                } else if lbl == cell.lblThur {
                    cell.lblThur.textColor = .systemRed; break
                } else if lbl == cell.lblEndThur {
                    cell.lblEndThur.textColor = .systemRed; break
                } else if lbl == cell.lblFri {
                    cell.lblFri.textColor = .systemRed; break
                } else if lbl == cell.lblEndFri {
                    cell.lblEndFri.textColor = .systemRed; break
                } else if lbl == cell.lblSat {
                    cell.lblSat.textColor = .systemRed; break
                } else if lbl == cell.lblEndSat {
                    cell.lblEndSat.textColor = .systemRed; break
                } else if lbl == cell.lblSun {
                    cell.lblSun.textColor = .systemRed; break
                } else if lbl == cell.lblEndSun {
                    cell.lblEndSun.textColor = .systemRed; break
                } else {
                    cell.lblMon.textColor = .black
                    cell.lblEndMon.textColor = .black
                    cell.lblTue.textColor = .black
                    cell.lblEndTue.textColor = .black
                    cell.lblWed.textColor = .black
                    cell.lblEndWed.textColor = .black
                    cell.lblThur.textColor = .black
                    cell.lblEndThur.textColor = .black
                    cell.lblFri.textColor = .black
                    cell.lblEndFri.textColor = .black
                    cell.lblSat.textColor = .black
                    cell.lblEndSat.textColor = .black
                    cell.lblSun.textColor = .black
                    cell.lblEndSun.textColor = .black
                    break
                }
            }
            if lable?.count ?? 0 > 0 {
                self.showMyAlert(desc: msg ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
            }
        }
    }
    
    private func valueReturn() {
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterInfocell {
            cell.txtBusinessName.blockForShouldReturn = {
                cell.txtAddress.becomeFirstResponder()
                return true
            }
            cell.txtAddress.blockForShouldReturn = {
                cell.txtCountry.becomeFirstResponder()
                return true
            }
        }
    }
}

//MARK:- TableView Methods
extension RegisterInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegisterInfocell.identifier, for: indexPath) as! RegisterInfocell
        var txtArray : [AppTextField]? = []
        var pickerArray : [CorePickerTextField]? = []
        cell.txtBusinessName.blockForTextChange = { txt in
            txtArray = [cell.txtBusinessName]
            self.hideShowErrorMsg(isError: false,txtArray: txtArray)
            self.userData.businessname = txt
        }
        cell.txtAddress.blockForTextChange = { txt in
            txtArray = [cell.txtAddress]
            self.hideShowErrorMsg(isError: false,txtArray: txtArray)
            self.userData.address = txt
        }
        cell.txtCountry.blockForDoneButtonTap = { selectedValue, selectedIndex in
            cell.txtCountry.text = selectedValue
            let first = self.countriesArray.first(where: { $0.name == selectedValue })
            self.userData.country = first?.name
            cell.txtState.text = nil
            self.userData.state = nil
            cell.txtCity.text = nil
            self.userData.city = nil
            pickerArray = [cell.txtCountry]
            self.hideShowErrorMsg(isError: false, pickerView: pickerArray)
            self.countryApiCall(isLoader: true, type: "States", countryID: first?.id)
        }
        cell.txtState.blockForDoneButtonTap = { selectedValue, selectedIndex in
            cell.txtState.text = selectedValue
            let first = self.statesArray.first(where: { $0.name == selectedValue })
            self.userData.state = first?.name
            cell.txtCity.text = nil
            self.userData.city = nil
            pickerArray = [cell.txtState]
            self.hideShowErrorMsg(isError: false, pickerView: pickerArray)
            self.countryApiCall(isLoader: true, type: "Cities", stateID: first?.id)
        }
        cell.txtCity.blockForDoneButtonTap = { selectedValue, selectedIndex in
            cell.txtCity.text = selectedValue
            let first = self.citiesArray.first(where: { $0.name == selectedValue })
            self.userData.city = first?.name
            pickerArray = [cell.txtCity]
            self.hideShowErrorMsg(isError: false, pickerView: pickerArray)
        }
        cell.txtzipCode.blockForTextChange = { fname in
            txtArray = [cell.txtzipCode]
            self.hideShowErrorMsg(isError: false,txtArray: txtArray)
            if fname.setMaxValue(max: 6) {
                self.userData.zipcode = fname
            } else {
                cell.txtzipCode.text = self.userData.zipcode
            }
        }
        cell.btnMon.handleTap = {
            cell.btnMon.isSelected = !cell.btnMon.isSelected
            if cell.btnMon.isSelected {
                self.userData.monday = 1
                cell.lblMon.textColor = .black
                cell.lblEndMon.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgMon.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.monday = 0
                self.userData.monday_end_time = nil
                self.userData.monday_start_time = nil
                cell.lblMon.text = "CLOSED"
                cell.lblMon.textColor = .systemRed
                cell.lblEndMon.text = "CLOSED"
                cell.lblEndMon.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgMon.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtMon.blockForDoneButtonTap = { str, date in
            cell.lblMon.text = str
            cell.lblMon.textColor = .black
            self.userData.monday_start_time = str
            cell.txtEndMon.timeMinimumDate = date
        }
        cell.txtEndMon.blockForDoneButtonTap = { str, date in
            cell.lblEndMon.text = str
            cell.lblEndMon.textColor = .black
            self.userData.monday_end_time = str
        }
        cell.btnTue.handleTap = {
            cell.btnTue.isSelected = !cell.btnTue.isSelected
            if cell.btnTue.isSelected {
                self.userData.tuesday = 1
                cell.lblTue.textColor = .black
                cell.lblEndTue.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgTue.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.tuesday = 0
                self.userData.tuesday_end_time = nil
                self.userData.tuesday_start_time = nil
                cell.lblTue.text = "CLOSED"
                cell.lblTue.textColor = .systemRed
                cell.lblEndTue.text = "CLOSED"
                cell.lblEndTue.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgTue.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtTue.blockForDoneButtonTap = { str, date in
            cell.lblTue.text = str
            cell.lblTue.textColor = .black
            self.userData.tuesday_start_time = str
            cell.txtEndTue.timeMinimumDate = date
        }
        cell.txtEndTue.blockForDoneButtonTap = { str, date in
            cell.lblEndTue.text = str
            cell.lblEndTue.textColor = .black
            self.userData.tuesday_end_time = str
        }
        cell.btnWed.handleTap = {
            cell.btnWed.isSelected = !cell.btnWed.isSelected
            if cell.btnWed.isSelected {
                self.userData.wednesday = 1
                cell.lblWed.textColor = .black
                cell.lblEndWed.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgWed.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.wednesday = 0
                self.userData.wednesday_end_time = nil
                self.userData.wednesday_start_time = nil
                cell.lblWed.text = "CLOSED"
                cell.lblWed.textColor = .systemRed
                cell.lblEndWed.text = "CLOSED"
                cell.lblEndWed.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgWed.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtWed.blockForDoneButtonTap = { str, date in
            cell.lblWed.text = str
            cell.lblWed.textColor = .black
            self.userData.wednesday_start_time = str
            cell.txtEndWed.timeMinimumDate = date
        }
        cell.txtEndWed.blockForDoneButtonTap = { str, date in
            cell.lblEndWed.text = str
            cell.lblEndWed.textColor = .black
            self.userData.wednesday_end_time = str
        }
        cell.btnThu.handleTap = {
            cell.btnThu.isSelected = !cell.btnThu.isSelected
            if cell.btnThu.isSelected {
                self.userData.thursday = 1
                cell.lblThur.textColor = .black
                cell.lblEndThur.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgThu.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.thursday = 0
                self.userData.thursday_end_time = nil
                self.userData.thursday_start_time = nil
                cell.lblThur.text = "CLOSED"
                cell.lblThur.textColor = .systemRed
                cell.lblEndThur.text = "CLOSED"
                cell.lblEndThur.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgThu.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtThur.blockForDoneButtonTap = { str, date in
            cell.lblThur.text = str
            cell.lblThur.textColor = .black
            self.userData.thursday_start_time = str
            cell.txtEndThur.timeMinimumDate = date
        }
        cell.txtEndThur.blockForDoneButtonTap = { str, date in
            cell.lblEndThur.text = str
            cell.lblEndThur.textColor = .black
            self.userData.thursday_end_time = str
        }
        cell.btnFri.handleTap = {
            cell.btnFri.isSelected = !cell.btnFri.isSelected
            if cell.btnFri.isSelected {
                self.userData.friday = 1
                cell.lblFri.textColor = .black
                cell.lblEndFri.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgFri.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.friday = 0
                self.userData.friday_end_time = nil
                self.userData.friday_start_time = nil
                cell.lblFri.text = "CLOSED"
                cell.lblFri.textColor = .systemRed
                cell.lblEndFri.text = "CLOSED"
                cell.lblEndFri.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgFri.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtFri.blockForDoneButtonTap = { str, date in
            cell.lblFri.text = str
            self.userData.friday_start_time = str
            cell.lblFri.textColor = .black
            cell.txtEndFri.timeMinimumDate = date
        }
        cell.txtEndFri.blockForDoneButtonTap = { str, date in
            cell.lblEndFri.text = str
            cell.lblEndFri.textColor = .black
            self.userData.friday_end_time = str
        }
        cell.btnSat.handleTap = {
            cell.btnSat.isSelected = !cell.btnSat.isSelected
            if cell.btnSat.isSelected {
                self.userData.saturday = 1
                cell.lblSat.textColor = .black
                cell.lblEndSat.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgSat.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.saturday = 0
                self.userData.saturday_end_time = nil
                self.userData.saturday_start_time = nil
                cell.lblSat.text = "CLOSED"
                cell.lblSat.textColor = .systemRed
                cell.lblEndSat.text = "CLOSED"
                cell.lblEndSat.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgSat.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtSat.blockForDoneButtonTap = { str, date in
            cell.lblSat.text = str
            cell.lblSat.textColor = .black
            self.userData.saturday_start_time = str
            cell.txtEndSat.timeMinimumDate = date
        }
        cell.txtEndSat.blockForDoneButtonTap = { str, date in
            cell.lblEndSat.text = str
            cell.lblEndSat.textColor = .black
            self.userData.saturday_end_time = str
        }
        cell.btnSun.handleTap = {
            cell.btnSun.isSelected = !cell.btnSun.isSelected
            if cell.btnSun.isSelected {
                self.userData.sunday = 1
                cell.lblSun.textColor = .black
                cell.lblEndSun.textColor = .black
                if #available(iOS 13.0, *) {
                    cell.imgSun.image = UIImage(systemName: "checkmark.square.fill")
                } else {}
            } else {
                self.userData.sunday = 0
                self.userData.sunday_end_time = nil
                self.userData.sunday_start_time = nil
                cell.lblSun.text = "CLOSED"
                cell.lblSun.textColor = .systemRed
                cell.lblEndSun.text = "CLOSED"
                cell.lblEndSun.textColor = .systemRed
                if #available(iOS 13.0, *) {
                    cell.imgSun.image = UIImage(systemName: "app")
                } else {}
            }
        }
        cell.txtSun.blockForDoneButtonTap = { str, date in
            cell.lblSun.text = str
            self.userData.sunday_start_time = str
            cell.lblSun.textColor = .black
            cell.txtEndSun.timeMinimumDate = date
        }
        cell.txtEndSun.blockForDoneButtonTap = { str, date in
            cell.lblEndSun.text = str
            cell.lblEndSun.textColor = .black
            self.userData.sunday_end_time = str
        }
        cell.txtPhone.blockForTextChange = { fname in
            txtArray = [cell.txtPhone]
            self.hideShowErrorMsg(isError: false,txtArray: txtArray)
            self.userData.phone = fname
            cell.txtPhone.text = fname.formattedNumber()
        }
        cell.btnContinue.handleTap = {
            if self.isValid() {
                self.registerApiCall(isLoader: true) {
                    if self.isPostServices {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        let vcs = self.navigationController?.viewControllers ?? []
                        for vc in vcs {
                            if let loginvc = vc as? LoginVC {
                                self.navigationController?.popToViewController(loginvc, animated: true)
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.isIphone() ? 900 : 1020
    }
}

extension RegisterInfoController {
    
    private func countryApiCall(isLoader: Bool, type: String, countryID: Int? = nil, stateID: Int? = nil) {
        APIClient.getCountry(type: type, countryID: countryID, stateID: stateID, doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                if countryID == nil && stateID == nil {
                    self.countriesArray = response.getCountries() ?? []
                }
                if countryID != nil {
                    self.statesArray = response.getStates() ?? []
                }
                if stateID != nil {
                    self.citiesArray = response.getCities() ?? []
                }
                let _ = self.countriesArray.compactMap { (country)  in
                    self.countryNames.append(country.name ?? "")
                }
                let _ = self.statesArray.compactMap { (state)  in
                    self.stateNames.append(state.name ?? "")
                }
                let _ = self.citiesArray.compactMap { (city)  in
                    self.cityNames.append(city.name ?? "")
                }
                self.fillArray()
                break
            case .failure(let error):
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
        
    private func registerApiCall(isLoader: Bool, completion: voidCompletion? = nil) {
        APIClient.register(userData: userData, role: "Providers", password: password ?? "", doShowLoading: isLoader) { (result) in
            switch result {
            case .success( _):
                completion?()
                break
            case .failure(let error):
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
}
