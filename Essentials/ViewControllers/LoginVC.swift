//
//  LoginVC.swift
//  Essentials
//
//  Created by Parth on 18/06/20.
//  Copyright © 2020 Vaibhav. All rights reserved.
//

import UIKit

class LoginVC: CoreViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtUserName: AppTextField!
    @IBOutlet weak var lblPassword: CoreLabel!
    @IBOutlet weak var txtPassword: AppTextField!
    @IBOutlet weak var lblUsername: CoreLabel!
    @IBOutlet weak var btnShowPassword: CoreButton!
    @IBOutlet weak var btnRemember: CoreButton!
    
    //MARK:- Properties
    private var email: String?
    private var password: String?
    private var type: String?
    private var isSecurityTxt = true
    var enumForPatientOrHealthCare: PatientOrHealthCare = .customer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        handleClicks()
        showData()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.role_id == 1 && UserDefaults.standard.user?.payment_status == false {
                        
        }
    }
        
    private func showData() {
        txtUserName.text = UserDefaults.standard.email
        txtPassword.text = UserDefaults.standard.password
        email = UserDefaults.standard.email
        password = UserDefaults.standard.password
        btnRemember.isSelected = UserDefaults.standard.isRememberLogin
    }
    
    //MARK:- Validation
    private func valid() -> Bool {
        var msg = ""
        var txtArray : [AppTextField]? = []
        if email?.isEmpty ?? false || email == nil {
            msg = "Please enter your email."
            txtArray?.append(txtUserName)
        } else if password?.isEmpty ?? false || password == nil  {
            msg = "Please enter your password."
            txtArray?.append(txtPassword)
        }
        if msg.count > 0 {
            hideShowErrorMsg(isError: true, msg: msg, txtArray: txtArray)
            return false
        }
        hideShowErrorMsg(isError: false)
        return true
    }
    
    func hideShowErrorMsg(isError: Bool, msg: String? = nil, txtArray: [AppTextField]? = nil) {
        for txt in txtArray ?? [] {
            if txt == txtUserName && isError {
                lblUsername.isHidden = isError ? false : true
                lblUsername.text = msg
                txtUserName.errorMessage = msg?.isEmpty ?? false ? "" : "EMAIL / USERNAME"
                txtUserName.placeholder = msg?.isEmpty ?? false ? "EMAIL / USERNAME" : ""
            } else if txt == txtPassword && isError {
                lblPassword.isHidden = isError ? false : true
                lblPassword.text = msg
                txtPassword.errorMessage = msg?.isEmpty ?? false ? "" : "PASSWORD"
                txtPassword.placeholder = msg?.isEmpty ?? false ? "PASSWORD" : ""
            } else {
                lblUsername.isHidden = true
                lblPassword.isHidden = true
                txtUserName.errorMessage = ""
                txtPassword.errorMessage = ""
                txtUserName.placeholder = msg?.isEmpty ?? true ? "EMAIL / USERNAME" : ""
                txtPassword.placeholder = msg?.isEmpty ?? true ? "PASSWORD" : ""
            }
        }
    }
    
    //MARK:- Handle Clicks
    
    private func handleClicks() {
        var txtArray : [AppTextField]? = []
        txtUserName.blockForTextChange = { txt in
            txtArray = [self.txtUserName]
            self.hideShowErrorMsg(isError: false,txtArray: txtArray)
            self.email = txt
            UserDefaults.standard.email = self.email
        }
        txtPassword.blockForTextChange = { pass in
            txtArray = [self.txtPassword]
            self.hideShowErrorMsg(isError: false,txtArray: txtArray)
            self.password = pass
            UserDefaults.standard.password = self.password
        }
        btnRemember.handleTap = {
            if UserDefaults.standard.isRememberLogin {
                UserDefaults.standard.isRememberLogin = false
                self.btnRemember.isSelected = false
            } else {
                UserDefaults.standard.isRememberLogin = true
                self.btnRemember.isSelected = true
            }
            UserDefaults.standard.email = UserDefaults.standard.isRememberLogin ? self.email ?? "" : nil
            UserDefaults.standard.password = UserDefaults.standard.isRememberLogin ? self.password ?? "" : nil
        }
        btnShowPassword.handleTap = {
            self.txtPassword.isSecureTextEntry = self.isSecurityTxt ? false : true
            let img = self.isSecurityTxt ? "closeEye" : "openEye"
            self.btnShowPassword.setImage(UIImage(named: img), for: .normal)
            self.isSecurityTxt = !self.isSecurityTxt
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowPassClick(_ sender: UIButton) {
    }
    
    @IBAction func btnRememberClick(_ sender: UIButton) {
    }
    
    @IBAction func btnLoginClick(_ sender: UIButton) {
        if valid() {
            self.loginApi(isLoader: true) {
                self.gotoHomeVC()
            }
        }
    }
    
    private func gotoHomeVC() {
        let vc = ChoosePatientHeathCareController.instantiateFromStoryboard()
        self.navigationController?.setViewControllers([vc], animated: false)
        self.redirectHomeScreen()
    }
    
    @IBAction func btnForgotPassClick(_ sender: UIButton) {
        let vc = ForgotChangePasswordController.instantiateFromStoryboard()
        vc.forgotChangePass = .forgotPass
        self.navigationController?.show(vc, sender: nil)
    }
    
    @IBAction func btnCreateAccountClick(_ sender: UIButton) {
        let customerVC = RegisterController.instantiateFromStoryboard()
        customerVC.enumForPatientOrHealthCare = enumForPatientOrHealthCare
        self.navigationController?.show(customerVC, sender: nil)
    }
    
    @IBAction func btnEnterAsGueestClick(_ sender: UIButton) {
        UserDefaults.standard.role_id = PatientOrHealthCare.guest.value
        self.gotoHomeVC()
    }
}

//MARK:- ***** API Calls *****
extension LoginVC {
    
    private func loginApi(isLoader: Bool, completion: voidCompletion? = nil) {
        let role = enumForPatientOrHealthCare == .provider ? "Providers" : "Customers"
        UserDefaults.standard.role_id = enumForPatientOrHealthCare.value
        APIClient.login(email: email, password: password, role: role,fcmiD: "AIZscefilcsdofjfjosfofofofvjdoefjd",  doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                print(response)
                if let userData = response.getUser() {
                    UserDefaults.standard.user = userData
                    completion?()
                }
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
