//
//  RegisterController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class RegisterController: CoreViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblView: CoreTableView!
    
    //MARK:- Properties
    var enumForPatientOrHealthCare: PatientOrHealthCare = .customer
    var isPostServices = false
    private var countriesArray = [Country]()
    private var statesArray = [Country]()
    private var citiesArray = [Country]()
    private var countryNames = [String]()
    private var stateNames = [String]()
    private var cityNames = [String]()
    private var userData = UserData(json: [:])!
    private var isSecurityPassTxt = true
    private var isSecurityConfirmPassTxt = true
    private var password : String?
    private var category = [HealthCareCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(RegisterCell.nib, forCellReuseIdentifier: RegisterCell.identifier)
        tblView.register(HealthCareCell.nib, forCellReuseIdentifier: HealthCareCell.identifier)
        if enumForPatientOrHealthCare == .customer {
            countryApiCall(isLoader: false, type: "Countries", countryID: nil, stateID: nil)
        } else {
            healthCareCategoryApi(isLoader: false)
        }
        if isPostServices {
            self.navigationbarUnderLineisShow = false
        }
    }
    
    // Validation
    private func isValid() -> Bool {
        var msg = ""
        var pickerArray : [CorePickerTextField]? = []
        var txtArray : [AppTextField]? = []
        var textViewArray : [CoreTextView]? = []
        if self.userData.phone?.contains("-") ?? false {
            let newphone = self.userData.phone?.replacingOccurrences(of: "-", with: "")
            self.userData.phone = newphone
        }
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterCell {
            if userData.firstname == nil || userData.firstname == "" {
                msg = "Please enter first name."
                txtArray?.append(cell.txtFirstName)
            } else if userData.lastname == nil || userData.lastname == "" {
                msg = "Please enter last name."
                txtArray?.append(cell.txtLastName)
            } else if userData.username == nil || userData.username == "" {
                msg = "Please enter username."
                txtArray?.append(cell.txtUserName)
            } else if userData.email == nil || userData.email == "" {
                msg = "Please enter email."
                txtArray?.append(cell.txtEmail)
            } else if !(userData.email?.isEmail ?? false) {
                msg = "Please enter valid email."
                txtArray?.append(cell.txtEmail)
            } else if password == nil || password == "" {
                msg = "Please enter password."
                txtArray?.append(cell.txtPassword)
            } else if cell.txtConfirmPass.text?.isEmpty ?? false {
                msg = "Please enter confirm password."
                txtArray?.append(cell.txtConfirmPass)
            } else if password != cell.txtConfirmPass.text ?? "" {
                msg = "Passwork & confirm password must be same."
                txtArray?.append(cell.txtConfirmPass)
            } else if userData.address == nil || userData.address == "" {
                msg = "Please enter address."
                txtArray?.append(cell.txtaddress)
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
                txtArray?.append(cell.txtZipcode)
            } else if !(userData.zipcode?.isPin ?? false) {
                msg = "Please enter valid zipcode."
                txtArray?.append(cell.txtZipcode)
            } else if userData.phone == nil || userData.phone == "" {
                msg = "Please enter phone number."
                txtArray?.append(cell.txtPhone)
            } else if !(userData.phone?.isPhoneNumber ?? false) {
                msg = "Please enter valid phone number."
                txtArray?.append(cell.txtPhone)
            }
        } else if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HealthCareCell {
            if userData.firstname == nil || userData.firstname == "" {
                msg = "Please enter first name."
                txtArray?.append(cell.txtFirstName)
            } else if userData.lastname == nil || userData.lastname == "" {
                msg = "Please enter last name."
                txtArray?.append(cell.txtLastName)
            } else if userData.username == nil || userData.username == "" {
                msg = "Please enter username."
                txtArray?.append(cell.txtUserName)
            } else if userData.email == nil || userData.email == "" {
                msg = "Please enter email."
                txtArray?.append(cell.txtEmail)
            } else if !(userData.email?.isEmail ?? false) {
                msg = "Please enter valid email."
                txtArray?.append(cell.txtEmail)
            } else if password == nil || password == "" {
                msg = "Please enter password."
                txtArray?.append(cell.txtPasswork)
            } else if cell.txtConfirmPassword.text?.isEmpty ?? false {
                msg = "Please enter confirm password."
                txtArray?.append(cell.txtConfirmPassword)
            } else if password != cell.txtConfirmPassword.text ?? "" {
                msg = "Passwork & confirm password must be same."
                txtArray?.append(cell.txtConfirmPassword)
            } else if userData.healthcarecategory_id == nil || userData.healthcarecategory_id == 0 {
                msg = "Please select healthcare category."
                pickerArray?.append(cell.txtCategory)
            } else if userData.service_description == nil || userData.service_description == "" {
                msg = "Please enter service description."
                textViewArray?.append(cell.txtDesc)
            }
        }
        if msg.count > 0 {
            hideShowErrorMsg(isError: true, msg: msg, txtArray: txtArray, pickerView: pickerArray, textView: textViewArray)
            return false
        }
        hideShowErrorMsg(isError: false)
        return true
    }
    
    func hideShowErrorMsg(isError: Bool, msg: String? = nil, txtArray: [AppTextField]? = nil, pickerView: [CorePickerTextField]? = nil, textView: [CoreTextView]? = nil) {
        valueReturn()
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterCell {
            for txt in txtArray ?? [] {
                if txt == cell.txtFirstName && isError {
                    cell.lblfirstName.isHidden = isError ? false : true
                    cell.lblfirstName.text = msg
                    cell.txtFirstName.errorMessage = msg?.isEmpty ?? false ? "" : "first name".uppercased()
                    cell.txtFirstName.placeholder = msg?.isEmpty ?? false ? "first name".uppercased() : ""
                } else if txt == cell.txtLastName && isError {
                    cell.lblLastname.isHidden = isError ? false : true
                    cell.lblLastname.text = msg
                    cell.txtLastName.errorMessage = msg?.isEmpty ?? false ? "" : "last name".uppercased()
                    cell.txtLastName.placeholder = msg?.isEmpty ?? false ? "last name".uppercased() : ""
                } else if txt == cell.txtUserName && isError {
                    cell.lblusername.isHidden = isError ? false : true
                    cell.lblusername.text = msg
                    cell.txtUserName.errorMessage = msg?.isEmpty ?? false ? "" : "username".uppercased()
                    cell.txtUserName.placeholder = msg?.isEmpty ?? false ? "username".uppercased() : ""
                } else if txt == cell.txtEmail && isError {
                    cell.lblEmail.isHidden = isError ? false : true
                    cell.lblEmail.text = msg
                    cell.txtEmail.errorMessage = msg?.isEmpty ?? false ? "" : "email".uppercased()
                    cell.txtEmail.placeholder = msg?.isEmpty ?? false ? "email".uppercased() : ""
                } else if txt == cell.txtPassword && isError {
                    cell.lblpassword.isHidden = isError ? false : true
                    cell.lblpassword.text = msg
                    cell.txtPassword.errorMessage = msg?.isEmpty ?? false ? "" : "password".uppercased()
                    cell.txtPassword.placeholder = msg?.isEmpty ?? false ? "password".uppercased() : ""
                } else if txt == cell.txtConfirmPass && isError {
                    cell.lblConfirmPass.isHidden = isError ? false : true
                    cell.lblConfirmPass.text = msg
                    cell.txtConfirmPass.errorMessage = msg?.isEmpty ?? false ? "" : "confirm password".uppercased()
                    cell.txtConfirmPass.placeholder = msg?.isEmpty ?? false ? "confirm password".uppercased() : ""
                } else if txt == cell.txtaddress && isError {
                    cell.lblAddress.isHidden = isError ? false : true
                    cell.lblAddress.text = msg
                    cell.addressMSGHeight.constant = isError ? Constants.isIphone() ? 20 : 25 : 0
                    cell.txtaddress.errorMessage = msg?.isEmpty ?? false ? "" : "address".uppercased()
                    cell.txtaddress.placeholder = msg?.isEmpty ?? false ? "address".uppercased() : ""
                } else if txt == cell.txtZipcode && isError {
                    cell.lblZipCode.isHidden = isError ? false : true
                    cell.lblZipCode.text = msg
                    cell.txtZipcode.errorMessage = msg?.isEmpty ?? false ? "" : "zipcode".uppercased()
                    cell.txtZipcode.placeholder = msg?.isEmpty ?? false ? "zipcode".uppercased() : ""
                } else if txt == cell.txtPhone && isError {
                    cell.lblPhone.isHidden = isError ? false : true
                    cell.lblPhone.text = msg
                    cell.txtPhone.errorMessage = msg?.isEmpty ?? false ? "" : "phone number".uppercased()
                    cell.txtPhone.placeholder = msg?.isEmpty ?? false ? "phone number".uppercased() : ""
                } else {
                    cell.lblfirstName.isHidden = true
                    cell.lblLastname.isHidden = true
                    cell.lblusername.isHidden = true
                    cell.lblpassword.isHidden = true
                    cell.lblConfirmPass.isHidden = true
                    cell.lblAddress.isHidden = true
                    cell.addressMSGHeight.constant = 0
                    cell.lblZipCode.isHidden = true
                    cell.lblPhone.isHidden = true
                    cell.lblEmail.isHidden = true
                    cell.txtFirstName.errorMessage = ""
                    cell.txtLastName.errorMessage = ""
                    cell.txtUserName.errorMessage = ""
                    cell.txtPassword.errorMessage = ""
                    cell.txtConfirmPass.errorMessage = ""
                    cell.txtaddress.errorMessage = ""
                    cell.txtZipcode.errorMessage = ""
                    cell.txtPhone.errorMessage = ""
                    cell.txtEmail.errorMessage = ""
                    cell.txtFirstName.placeholder = msg?.isEmpty ?? true ? "first name".uppercased() : ""
                    cell.txtLastName.placeholder = msg?.isEmpty ?? true ? "last name".uppercased() : ""
                    cell.txtUserName.placeholder = msg?.isEmpty ?? true ? "username".uppercased() : ""
                    cell.txtPassword.placeholder = msg?.isEmpty ?? true ? "password".uppercased() : ""
                    cell.txtConfirmPass.placeholder = msg?.isEmpty ?? true ? "confirm password".uppercased() : ""
                    cell.txtaddress.placeholder = msg?.isEmpty ?? true ? "address".uppercased() : ""
                    cell.txtZipcode.placeholder = msg?.isEmpty ?? true ? "zipcode".uppercased() : ""
                    cell.txtPhone.placeholder = msg?.isEmpty ?? true ? "phone number".uppercased() : ""
                    cell.txtEmail.placeholder = msg?.isEmpty ?? true ? "email".uppercased() : ""
                }
            }
            for txt in pickerView ?? [] {
                if txt == cell.txtCountry && isError {
                    cell.lblCountyMsg.isHidden = isError ? false : true
                    cell.lblCountyMsg.text = msg
                    cell.lblCountry.textColor = msg?.isEmpty ?? false ? .lightGray : .systemRed
                } else if txt == cell.txtState && isError {
                    cell.lblStateMsg.isHidden = isError ? false : true
                    cell.lblStateMsg.text = msg
                    cell.lblState.textColor = msg?.isEmpty ?? false ? .lightGray : .systemRed
                } else if txt == cell.txtCity && isError {
                    cell.lblCityMsg.isHidden = isError ? false : true
                    cell.lblCityMsg.text = msg
                    cell.lblCity.textColor = msg?.isEmpty ?? false ? .lightGray : .systemRed
                } else {
                    cell.lblCountry.textColor = .lightGray
                    cell.lblState.textColor = .lightGray
                    cell.lblCity.textColor = .lightGray
                    cell.lblCountyMsg.text = msg
                    cell.lblStateMsg.text = msg
                    cell.lblCityMsg.text = msg
                }
            }
        } else if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HealthCareCell {
            for txt in txtArray ?? [] {
                if txt == cell.txtFirstName && isError {
                    cell.lblFirstName.isHidden = isError ? false : true
                    cell.lblFirstName.text = msg
                    cell.txtFirstName.errorMessage = msg?.isEmpty ?? false ? "" : "first name".uppercased()
                    cell.txtFirstName.placeholder = msg?.isEmpty ?? false ? "first name".uppercased() : ""
                } else if txt == cell.txtLastName && isError {
                    cell.lblLastname.isHidden = isError ? false : true
                    cell.lblLastname.text = msg
                    cell.txtLastName.errorMessage = msg?.isEmpty ?? false ? "" : "last name".uppercased()
                    cell.txtLastName.placeholder = msg?.isEmpty ?? false ? "last name".uppercased() : ""
                } else if txt == cell.txtUserName && isError {
                    cell.lblUsername.isHidden = isError ? false : true
                    cell.lblUsername.text = msg
                    cell.txtUserName.errorMessage = msg?.isEmpty ?? false ? "" : "username".uppercased()
                    cell.txtUserName.placeholder = msg?.isEmpty ?? false ? "username".uppercased() : ""
                } else if txt == cell.txtEmail && isError {
                    cell.lblEmail.isHidden = isError ? false : true
                    cell.lblEmail.text = msg
                    cell.txtEmail.errorMessage = msg?.isEmpty ?? false ? "" : "email".uppercased()
                    cell.txtEmail.placeholder = msg?.isEmpty ?? false ? "email".uppercased() : ""
                } else if txt == cell.txtPasswork && isError {
                    cell.lblPassword.isHidden = isError ? false : true
                    cell.lblPassword.text = msg
                    cell.txtPasswork.errorMessage = msg?.isEmpty ?? false ? "" : "password".uppercased()
                    cell.txtPasswork.placeholder = msg?.isEmpty ?? false ? "password".uppercased() : ""
                } else if txt == cell.txtConfirmPassword && isError {
                    cell.lblConfirmPass.isHidden = isError ? false : true
                    cell.lblConfirmPass.text = msg
                    cell.txtConfirmPassword.errorMessage = msg?.isEmpty ?? false ? "" : "confirm password".uppercased()
                    cell.txtConfirmPassword.placeholder = msg?.isEmpty ?? false ? "confirm password".uppercased() : ""
                }  else {
                    cell.lblFirstName.isHidden = true
                    cell.lblLastname.isHidden = true
                    cell.lblUsername.isHidden = true
                    cell.lblPassword.isHidden = true
                    cell.lblConfirmPass.isHidden = true
                    cell.lblEmail.isHidden = true
                    cell.txtFirstName.errorMessage = ""
                    cell.txtLastName.errorMessage = ""
                    cell.txtUserName.errorMessage = ""
                    cell.txtPasswork.errorMessage = ""
                    cell.txtConfirmPassword.errorMessage = ""
                    cell.txtEmail.errorMessage = ""
                    cell.txtFirstName.placeholder = msg?.isEmpty ?? true ? "first name".uppercased() : ""
                    cell.txtLastName.placeholder = msg?.isEmpty ?? true ? "last name".uppercased() : ""
                    cell.txtUserName.placeholder = msg?.isEmpty ?? true ? "username".uppercased() : ""
                    cell.txtPasswork.placeholder = msg?.isEmpty ?? true ? "password".uppercased() : ""
                    cell.txtConfirmPassword.placeholder = msg?.isEmpty ?? true ? "confirm password".uppercased() : ""
                    cell.txtEmail.placeholder = msg?.isEmpty ?? true ? "email".uppercased() : ""
                }
            }
            for txt in pickerView ?? [] {
                if txt == cell.txtCategory && isError {
                    cell.lblCategoryMsg.isHidden = isError ? false : true
                    cell.lblCategoryMsg.text = msg
                    cell.lblCategory.textColor = msg?.isEmpty ?? false ? .darkGray : .systemRed
                } else {
                    cell.lblCategory.textColor = .darkGray
                    cell.lblCategoryMsg.text = msg
                }
            }
            for txt in textView ?? [] {
                if txt == cell.txtDesc && isError {
                    cell.lblDesc.textColor = msg?.isEmpty ?? false ? .darkGray : .systemRed
                    cell.lblDescLine.backgroundColor = msg?.isEmpty ?? false ? .darkGray : .systemRed
                } else {
                    cell.lblDesc.textColor = .darkGray
                    cell.lblDesc.text = msg
                    cell.lblDescLine.backgroundColor = .black
                }
            }
        }
    }
    
    private func valueReturn() {
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterCell {
            cell.txtFirstName.blockForShouldReturn = {
                cell.txtLastName.becomeFirstResponder()
                return true
            }
            cell.txtLastName.blockForShouldReturn = {
                cell.txtUserName.becomeFirstResponder()
                return true
            }
            cell.txtUserName.blockForShouldReturn = {
                cell.txtEmail.becomeFirstResponder()
                return true
            }
            cell.txtEmail.blockForShouldReturn = {
                cell.txtPassword.becomeFirstResponder()
                return true
            }
            cell.txtPassword.blockForShouldReturn = {
                cell.txtConfirmPass.becomeFirstResponder()
                return true
            }
            cell.txtConfirmPass.blockForShouldReturn = {
                cell.txtaddress.becomeFirstResponder()
                return true
            }
            cell.txtaddress.blockForShouldReturn = {
                cell.txtZipcode.becomeFirstResponder()
                return true
            }
        } else if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HealthCareCell {
            cell.txtFirstName.blockForShouldReturn = {
                cell.txtLastName.becomeFirstResponder()
                return true
            }
            cell.txtLastName.blockForShouldReturn = {
                cell.txtUserName.becomeFirstResponder()
                return true
            }
            cell.txtUserName.blockForShouldReturn = {
                cell.txtEmail.becomeFirstResponder()
                return true
            }
            cell.txtEmail.blockForShouldReturn = {
                cell.txtPasswork.becomeFirstResponder()
                return true
            }
            cell.txtPasswork.blockForShouldReturn = {
                cell.txtConfirmPassword.becomeFirstResponder()
                return true
            }
            cell.txtConfirmPassword.blockForShouldReturn = {
                cell.txtCategory.becomeFirstResponder()
                return true
            }
            cell.txtCategory.blockForShouldReturn = {
                cell.txtDesc.becomeFirstResponder()
                return true
            }
            cell.txtCategory.blockForShouldReturn = {
                cell.txtDesc.resignFirstResponder()
                return true
            }
        }
    }
    
    private func fillArray() {
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterCell {
            cell.txtCountry.dataSource = [countryNames]
            cell.txtState.dataSource = [stateNames]
            cell.txtCity.dataSource = [cityNames]
        } else if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HealthCareCell {
            cell.txtCategory.dataSource = [cityNames]
        }
    }
}

//MARK:- TableView Methods
extension RegisterController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumForPatientOrHealthCare {
        case .customer:
            let cell = tableView.dequeueReusableCell(withIdentifier: RegisterCell.identifier, for: indexPath) as! RegisterCell
            var txtArray : [AppTextField]? = []
            var pickerArray : [CorePickerTextField]? = []
            cell.txtFirstName.blockForTextChange = { fname in
                txtArray = [cell.txtFirstName]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.firstname = fname
            }
            cell.txtLastName.blockForTextChange = { fname in
                txtArray = [cell.txtLastName]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.lastname = fname
            }
            cell.txtUserName.blockForTextChange = { fname in
                txtArray = [cell.txtUserName]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.username = fname
            }
            cell.txtEmail.blockForTextChange = { fname in
                txtArray = [cell.txtEmail]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.email = fname
            }
            cell.txtPassword.blockForTextChange = { fname in
                txtArray = [cell.txtPassword]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.password = fname
            }
            cell.txtConfirmPass.blockForTextChange = { fname in
                txtArray = [cell.txtConfirmPass]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                cell.txtConfirmPass.text = fname
            }
            cell.txtaddress.blockForTextChange = { fname in
                txtArray = [cell.txtaddress]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.address = fname
            }
            cell.txtZipcode.blockForTextChange = { fname in
                txtArray = [cell.txtZipcode]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                if fname.setMaxValue(max: 6) {
                    self.userData.zipcode = fname
                } else {
                    cell.txtZipcode.text = self.userData.zipcode
                }
            }
            cell.txtPhone.blockForTextChange = { fname in
                txtArray = [cell.txtPhone]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.phone = fname
                cell.txtPhone.text = fname.formattedNumber()                
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
            cell.btnShowPass.handleTap = {
                cell.btnShowPass.isSelected = !cell.btnShowPass.isSelected
                cell.txtPassword.isSecureTextEntry = !cell.btnShowPass.isSelected
            }
            cell.btnShowConfirmPass.handleTap = {
                cell.btnShowConfirmPass.isSelected = !cell.btnShowConfirmPass.isSelected
                cell.txtConfirmPass.isSecureTextEntry = !cell.btnShowConfirmPass.isSelected
            }
            cell.imgProfile.handleSelfTap = {
                CoreImagePickerOption.shared.showImagePickerFrom(vc: self, withOption: .askForOption) { (isSuccess, img) in
                    if isSuccess {
                        cell.imgProfile.image = img
                        self.uploadImgApiCall(img: img)
                    }
                }
            }
            cell.btnCreateProfile.handleTap = {
                if self.isValid() {
                    self.registerApiCall(isLoader: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            return cell
        case .provider:
            let cell = tableView.dequeueReusableCell(withIdentifier: HealthCareCell.identifier, for: indexPath) as! HealthCareCell
            var txtArray : [AppTextField]? = []
            var pickerArray : [CorePickerTextField]? = []
            cell.txtFirstName.blockForTextChange = { fname in
                txtArray = [cell.txtFirstName]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.firstname = fname
            }
            cell.txtLastName.blockForTextChange = { fname in
                txtArray = [cell.txtLastName]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.lastname = fname
            }
            cell.txtUserName.blockForTextChange = { fname in
                txtArray = [cell.txtUserName]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.username = fname
            }
            cell.txtEmail.blockForTextChange = { fname in
                txtArray = [cell.txtEmail]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.userData.email = fname
            }
            cell.txtPasswork.blockForTextChange = { fname in
                txtArray = [cell.txtPasswork]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                self.password = fname
            }
            cell.txtConfirmPassword.blockForTextChange = { fname in
                txtArray = [cell.txtConfirmPassword]
                self.hideShowErrorMsg(isError: false,txtArray: txtArray)
                cell.txtConfirmPassword.text = fname
            }
            cell.txtCategory.blockForDoneButtonTap = { selectedValue, selectedIndex in
                cell.txtCategory.text = selectedValue
                let first = self.category.first(where: { $0.type == selectedValue })
                self.userData.healthcarecategory_id = first?.healthcarecategory_id
                pickerArray = [cell.txtCategory]
                self.hideShowErrorMsg(isError: false, pickerView: pickerArray)
            }
            cell.txtDesc.blockForTextChange = { desc in
                cell.txtDesc.text = desc
                self.userData.service_description = desc
            }
            cell.btnPassword.handleTap = {
                cell.btnPassword.isSelected = !cell.btnPassword.isSelected
                cell.txtPasswork.isSecureTextEntry = !cell.btnPassword.isSelected
            }
            cell.btnConfirmPass.handleTap = {
                cell.btnConfirmPass.isSelected = !cell.btnConfirmPass.isSelected
                cell.txtConfirmPassword.isSecureTextEntry = !cell.btnConfirmPass.isSelected
            }
            cell.imgView.handleSelfTap = {
                CoreImagePickerOption.shared.showImagePickerFrom(vc: self, withOption: .askForOption) { (isSuccess, img) in
                    if isSuccess {
                        cell.imgView.image = img
                        self.uploadImgApiCall(img: img)
                    }
                }
            }
            cell.btnContinue.handleTap = {
                if self.isValid() {
                    let vc = RegisterInfoController.instantiateFromStoryboard()
                    vc.isPostServices = self.isPostServices
                    vc.userData = self.userData                    
                    vc.password = self.password
                    self.navigationController?.show(vc, sender: nil)
                }
            }
            return cell
        case .guest : return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch enumForPatientOrHealthCare {
        case .customer : return UITableView.automaticDimension
        case .provider : return Constants.isIphone() ? 910 : 1110
        case .guest : return 0.01
        }        
    }
}

//MARK:- API CALL
extension RegisterController {
    
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
        APIClient.register(userData: userData, role: "Customers", password: password ?? "", doShowLoading: isLoader) { (result) in
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
    
    private func uploadImgApiCall(img: UIImage?) {
        let data = img?.jpegData(compressionQuality: 0.5)
        APIClient.uploadImage(img: data, doShowLoading: false) { (result) in
            switch result {
            case .success(let response):                
                self.userData.image = response.image
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func healthCareCategoryApi(isLoader: Bool) {
        APIClient.getHealthCareCategory(doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.category = response.getCategory() ?? []
                let _ = self.category.compactMap { (cate)  in
                    self.cityNames.append(cate.type ?? "")
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
}
