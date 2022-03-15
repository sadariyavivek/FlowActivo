//
//  ForgotChangePasswordController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 05/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import WebKit

class ForgotChangePasswordController: CoreViewController {
    
    //MARK:- IBOutlets
    //Forgot Password
    @IBOutlet weak var forgotView: UIView!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var btnLogin: CoreButton!
    @IBOutlet weak var lblEmailMsg: CoreLabel!
    //Change Password
    @IBOutlet weak var changePassView: UIView!
    @IBOutlet weak var txtCurrentPass: AppTextField!
    @IBOutlet weak var btncurrentShow: CoreButton!
    @IBOutlet weak var lblCurrentMsg: CoreLabel!
    @IBOutlet weak var txtNewPass: AppTextField!
    @IBOutlet weak var lblNewMsg: CoreLabel!
    @IBOutlet weak var btnNewShow: CoreButton!
    @IBOutlet weak var txtConfirmPass: AppTextField!
    @IBOutlet weak var btnConfirmShow: CoreButton!
    @IBOutlet weak var lblConfirmMSg: CoreLabel!
    @IBOutlet weak var btnSubmit: CoreButton!
    @IBOutlet weak var webViews: WKWebView!
    
    //MARK:- Properties
    var forgotChangePass: ForgotChangePassword = .forgotPass
    var urlstr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleClicks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if forgotChangePass == .changePass {
            self.navigationbarUnderLineisShow = false
            changePassView.isHidden = false
            forgotView.isHidden = !changePassView.isHidden
            webViews.isHidden = !changePassView.isHidden
        } else if forgotChangePass == .forgotPass {
            forgotView.isHidden = false
            changePassView.isHidden = !forgotView.isHidden
            webViews.isHidden = !forgotView.isHidden
        } else {
            webViews.isHidden = false
            forgotView.isHidden = !webViews.isHidden
            changePassView.isHidden = !webViews.isHidden
            let url = URL(string: urlstr)!
            webViews.load(URLRequest(url: url))
            webViews.navigationDelegate = self
        }
    }
    
    private func handleClicks() {
        txtEmail.blockForTextChange = { email in
            self.hideShowErrorMsg(isError: false, txtArray: [self.txtEmail])
            self.txtEmail.text = email
        }
        txtCurrentPass.blockForTextChange = { pass in
            self.hideShowErrorMsg(isError: false, txtArray: [self.txtCurrentPass])
            self.txtCurrentPass.text = pass
        }
        txtNewPass.blockForTextChange = { pass in
            self.hideShowErrorMsg(isError: false, txtArray: [self.txtNewPass])
            self.txtNewPass.text = pass
        }
        txtConfirmPass.blockForTextChange = { pass in
            self.hideShowErrorMsg(isError: false, txtArray: [self.txtConfirmPass])
            self.txtConfirmPass.text = pass
        }
        btnLogin.handleTap = {
            if self.valid() {
                self.forgotPasswordAPi()
            }
        }
        btncurrentShow.handleTap = {
            self.btncurrentShow.isSelected = !self.btncurrentShow.isSelected
            self.txtCurrentPass.isSecureTextEntry = !self.btncurrentShow.isSelected
        }
        btnNewShow.handleTap = {
            self.btnNewShow.isSelected = !self.btnNewShow.isSelected
            self.txtNewPass.isSecureTextEntry = !self.btnNewShow.isSelected
        }
        btnConfirmShow.handleTap = {
            self.btnConfirmShow.isSelected = !self.btnConfirmShow.isSelected
            self.txtConfirmPass.isSecureTextEntry = !self.btnConfirmShow.isSelected
        }
        btnSubmit.handleTap = {
            if self.valid() {
                self.changePasswordApi()
            }
        }
    }
    
    //MARK:- Validation
    private func valid() -> Bool {
        var msg = ""
        var txtArray : [AppTextField]? = []
        if forgotChangePass == .forgotPass && txtEmail.text?.isEmpty ?? false || txtEmail.text == nil  {
            msg = "Please enter your email."
            txtArray?.append(txtEmail)
        } else if forgotChangePass == .forgotPass && !(txtEmail.text?.isEmail ?? false) {
            msg = "Please enter valid email."
            txtArray?.append(txtEmail)
        }else if forgotChangePass == .changePass && txtCurrentPass.text?.isEmpty ?? false || txtCurrentPass.text == nil  {
            msg = "Please enter your current password."
            txtArray?.append(txtCurrentPass)
        } else if forgotChangePass == .changePass && txtNewPass.text?.isEmpty ?? false || txtNewPass.text == nil  {
            msg = "Please enter your new password."
            txtArray?.append(txtNewPass)
        } else if forgotChangePass == .changePass && txtConfirmPass.text?.isEmpty ?? false || txtConfirmPass.text == nil  {
            msg = "Please enter your confirm password."
            txtArray?.append(txtConfirmPass)
        } else if forgotChangePass == .changePass && txtNewPass.text != txtConfirmPass.text   {
            msg = "New passwork & confirm password must be same."
            txtArray?.append(txtConfirmPass)
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
            if txt == txtEmail && isError && forgotChangePass == .forgotPass {
                lblEmailMsg.isHidden = isError ? false : true
                lblEmailMsg.text = msg
                txtEmail.errorMessage = msg?.isEmpty ?? false ? "" : "EMAIL / USERNAME"
                txtEmail.placeholder = msg?.isEmpty ?? false ? "EMAIL / USERNAME" : ""
            } else if txt == txtCurrentPass && isError && forgotChangePass == .changePass {
                lblCurrentMsg.isHidden = isError ? false : true
                lblCurrentMsg.text = msg
                txtCurrentPass.errorMessage = msg?.isEmpty ?? false ? "" : "Current Password"
                txtCurrentPass.placeholder = msg?.isEmpty ?? false ? "Current Password" : ""
            } else if txt == txtNewPass && isError && forgotChangePass == .changePass {
                lblNewMsg.isHidden = isError ? false : true
                lblNewMsg.text = msg
                txtNewPass.errorMessage = msg?.isEmpty ?? false ? "" : "New Password"
                txtNewPass.placeholder = msg?.isEmpty ?? false ? "New Password" : ""
            } else if txt == txtConfirmPass && isError && forgotChangePass == .changePass {
                lblConfirmMSg.isHidden = isError ? false : true
                lblConfirmMSg.text = msg
                txtConfirmPass.errorMessage = msg?.isEmpty ?? false ? "" : "Confirm Password"
                txtConfirmPass.placeholder = msg?.isEmpty ?? false ? "Confirm Password" : ""
            } else {
                if forgotChangePass == .forgotPass {
                    lblEmailMsg.isHidden = true
                    txtEmail.errorMessage = ""
                    txtEmail.placeholder = msg?.isEmpty ?? true ? "EMAIL / USERNAME" : ""
                } else {
                    lblCurrentMsg.isHidden = true
                    lblNewMsg.isHidden = true
                    lblConfirmMSg.isHidden = true
                    txtCurrentPass.errorMessage = ""
                    txtCurrentPass.placeholder = msg?.isEmpty ?? true ? "Current Password" : ""
                    txtNewPass.errorMessage = ""
                    txtNewPass.placeholder = msg?.isEmpty ?? true ? "New Password" : ""
                    txtConfirmPass.errorMessage = ""
                    txtConfirmPass.placeholder = msg?.isEmpty ?? true ? "Confirm Password" : ""
                }
            }
        }
    }
}

//MARK:- WKNavigationDelegate Methods
extension ForgotChangePasswordController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LoadingView.showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoadingView.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LoadingView.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LoadingView.hideLoading()
    }
}

//MARK:- API CALLS
extension ForgotChangePasswordController {
    
    private func forgotPasswordAPi() {
        APIClient.forgotPassword(email: txtEmail.text ?? "", doShowLoading: true) { (result) in
            switch result {
            case .success(let response):
                self.showMyAlert(desc: response.message ?? "", cancelTitle: "OK", cancelHandler: {
                self.navigationController?.popViewController(animated: true)
                }, vc: self)
                break
            case .failure(let error):
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
    
    private func changePasswordApi() {
        APIClient.changePassword(currentPass: txtCurrentPass.text ?? "", newPass: txtCurrentPass.text ?? "", doShowLoading: true) { (result) in
            switch result {
            case .success(let response):
                self.showMyAlert(desc: response.message ?? "", cancelTitle: "OK", cancelHandler: {
                    isLogout = true
                    UserDefaults.standard.user = nil
                    self.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }, vc: self)
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
