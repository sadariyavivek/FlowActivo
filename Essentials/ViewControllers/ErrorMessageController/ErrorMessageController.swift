//
//  ErrorMessageController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import FloatRatingView

class ErrorMessageController: CoreViewController {

    //MARK:- IBoutlets
    // Error MSG
    @IBOutlet weak var lblMsg: CoreLabel!
    @IBOutlet weak var btnOk: CoreButton!
    @IBOutlet weak var btnLogout: CoreButton!
    @IBOutlet weak var errorVie: UIView!
    // Appointment
    @IBOutlet weak var txtMsg: AppTextField!
    @IBOutlet weak var btnCancel: CoreButton!
    @IBOutlet weak var lblTxtMsg: CoreLabel!
    @IBOutlet weak var textView: UIView!
    // Rate & Review
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var floatView: FloatRatingView!
    @IBOutlet weak var txtReview: AppTextField!
    @IBOutlet weak var btnSubmit: CoreButton!
    @IBOutlet weak var lblReviewMsg: CoreLabel!
        
    //MARK:- Properties
    var msg = ""
    var logoutBtnTitle = ""
    var cancleBtnTitle = ""
    var isShowLogout = false
    var blockForOk: voidCompletion?
    var blockForLogout: voidCompletion?
    var enumForErrorOrText : EnumForErrorORTextField = .errorview
    var history : AppointmentHistory? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if enumForErrorOrText == .errorview {
            textView.isHidden = true
            errorVie.isHidden = false
            rateView.isHidden = true
            lblMsg.text  = msg
            setTitle()
        } else if enumForErrorOrText == .textView {
            textView.isHidden = false
            errorVie.isHidden = true
            rateView.isHidden = true
        } else {
            textView.isHidden = true
            errorVie.isHidden = true
            rateView.isHidden = false
            floatView.delegate = self
        }
        handleClicks()
    }
    //MARK:- validation
    private func isValid() -> Bool {
        if enumForErrorOrText == .textView {
            if txtMsg.text?.isEmpty ?? false {
                lblTxtMsg.isHidden = false
                txtMsg.errorMessage = "REASON FOR THE CANCELLATION"
                txtMsg.placeholder = ""
                return false
            } else {
                lblTxtMsg.isHidden = true
                txtMsg.errorMessage = ""
                txtMsg.placeholder = "REASON FOR THE CANCELLATION"
            }
        } else {
            if history?.rate == nil || history?.rate == "0" || history?.rate == "0.0" || history?.rate == "" {
                self.showMyAlert(desc: "Please give rating", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                return false
            } else if txtReview.text?.isEmpty ?? false {
                lblReviewMsg.isHidden = false
                txtReview.errorMessage = "REVIEW"
                txtReview.placeholder = ""
                return false
            } else {
                lblReviewMsg.isHidden = true
                txtReview.errorMessage = ""
                txtReview.placeholder = "REVIEW"
            }
        }
        return true
    }
    
    //MARK:- Handle clicks
    private func handleClicks() {
        btnLogout.handleTap = {
            self.blockForLogout?()
        }
        btnOk.handleTap = {
            self.blockForOk?()
        }
        btnCancel.handleTap = {
            if self.isValid() {
                self.cancelAppointmentAPI() {
                    self.blockForOk?()
                    self.dismiss(animated: true) {
                    }
                }
            }
        }
        txtMsg.blockForShouldReturn = {
            self.txtMsg.resignFirstResponder()
            return true
        }
        txtMsg.blockForTextChange = { msg in
            self.lblTxtMsg.isHidden = true
            self.txtMsg.errorMessage = ""
            self.txtMsg.placeholder = "REASON FOR THE CANCELLATION"
            self.txtMsg.text = msg
        }
        txtReview.blockForShouldReturn = {
            self.txtReview.resignFirstResponder()
            return true
        }
        txtReview.blockForTextChange = { msg in
            self.lblReviewMsg.isHidden = true
            self.txtReview.errorMessage = ""
            self.txtReview.placeholder = "REVIEW"
            self.txtReview.text = msg
            self.history?.review = msg
        }
        btnSubmit.handleTap = {
            if self.isValid() {
                self.giveRateReviewAPI {
                    self.blockForOk?()
                    self.dismiss(animated: true) {
                    }
                }
            }
        }
    }
    
    private func setTitle() {
        DispatchQueue.main.async {
            self.btnLogout.setTitle(self.logoutBtnTitle, for: .normal)
            self.btnOk.setTitle(self.cancleBtnTitle, for: .normal)
            self.btnLogout.isHidden = self.logoutBtnTitle.isEmpty ? true : false
            self.btnOk.isHidden = self.cancleBtnTitle.isEmpty  ? true : false
        }
    }
}

//MARK:- FloatRatingView method
extension ErrorMessageController: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        history?.rate = "\(rating)"
    }
}

//MARK:- API Calls
extension ErrorMessageController {
    
    private func cancelAppointmentAPI(completion: voidCompletion? = nil) {
        APIClient.cancelAppointment(history: history ?? AppointmentHistory(json: [:])!, date: Date(), reason: txtMsg.text ?? "", doShowLoading: true) { (result) in
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
    
    private func giveRateReviewAPI(completion: voidCompletion? = nil) {
        APIClient.giveRateReview(history: history ?? AppointmentHistory(json: [:])!, doShowLoading: true) { (result) in
            switch result {
            case .success(let response):
                self.showMyAlert(desc: response.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                    completion?()
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
