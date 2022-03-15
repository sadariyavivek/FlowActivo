//
//  SideMenuVC.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class SideMenuVC: CoreViewController {
    
    //MAKR:- IBOutlets
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tblView: CoreTableView!
    @IBOutlet weak var btnLogout: CoreButton!
    @IBOutlet weak var btnSetting: CoreButton!
    @IBOutlet weak var lblName: CoreLabel!
    @IBOutlet weak var lblAddress: CoreLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var profileView: UIView!
    
    //MARK:- Properties
    var sideMenuOptions = [SideMenuOptions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationbarUnderLineisShow = true
        btnSetting.setImage("ic_setting".imageWithOriginalMode.resize(value: Constants.isIphone() ? 15 : 20), for: .normal)
        btnLogout.setImage("ic_logout".imageWithOriginalMode.resize(value: Constants.isIphone() ? 25 : 30), for: .normal)
        if UserDefaults.standard.user?.user_id == nil {
            sideMenuOptions = [.aboutus, .viewLocalListing, .shareOurApp, .socialMedia, .privacyPolicy, .contactus]
        } else {
            sideMenuOptions = [.aboutus, .viewLocalListing, .shareOurApp, .socialMedia, .privacyPolicy, .contactus, .appointmentHistory, .myMessages, .changePassword]
        }
        imgViewWidth.constant = Constants.isIphone() ? 40 : 45
        imgViewHeight.constant = imgViewWidth.constant
        imgProfile.cornerRadius = Double(imgViewWidth.constant / 2)
        tblView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        tblView.register(SideMenuCell2.nib, forCellReuseIdentifier: SideMenuCell2.identifier)
        handleClicks()        
        cmsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showData()
    }
    
    private func showData() {
        self.navigationbarUnderLineisShow = true
        lblAddress.text = UserDefaults.standard.user?.address
        let name = "\(UserDefaults.standard.user?.firstname ?? "") \(UserDefaults.standard.user?.lastname ?? "")"
        lblName.text = name
        let urlString = UserDefaults.standard.user?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        imgProfile.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
        let btnLogoutTitle = UserDefaults.standard.user == nil ? "Login" : "Logout"
        btnLogout.setTitle(btnLogoutTitle, for: .normal)
        profileView.isHidden = UserDefaults.standard.user?.user_id == nil
    }
    
    //MARK:- Handle Clicks
    private func handleClicks() {
        btnSetting.handleTap = {
            let vc = EditProfileController.instantiateFromStoryboard()
            self.navigationController?.show(vc, sender: nil)
        }
        btnLogout.handleTap = {
            if UserDefaults.standard.user == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showMyAlert(desc: "Are you sure you want logout?", logoutTitle: "Logout", cancelTitle: "Cancel", logOutnHandler: {
                    isLogout = true
                    self.logoutApi()
                    UserDefaults.standard.user = nil
                    self.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }, cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
            }
        }
    }
}

//MARK:- TableView Methods
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sideMenuOptions.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
            cell.lblBottomSeprator.isHidden = indexPath.row != (sideMenuOptions.count - 1)
            cell.lblTopSeprator.isHidden = indexPath.row != 0
            cell.imgView.image = sideMenuOptions[indexPath.row].image
            cell.lblTitle.text = sideMenuOptions[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell2.identifier, for: indexPath) as! SideMenuCell2
            cell.btnPostServices.handleTap = {
                let vc = RegisterController.instantiateFromStoryboard()
                vc.isPostServices = true
                vc.enumForPatientOrHealthCare = .provider
                self.navigationController?.show(vc, sender: nil)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch sideMenuOptions[indexPath.row] {
            case .aboutus:
                let vc = CMSController.instantiateFromStoryboard()
                vc.enumForCMS = .about
                navigateTOVC(vc: vc)
                break
            case .privacyPolicy:
                let vc = CMSController.instantiateFromStoryboard()
                vc.enumForCMS = .privacypolicy
                navigateTOVC(vc: vc)
                break
            case .shareOurApp:
                self.showShareActivity(msg: nil, image: nil, url: URL(string: UserDefaults.standard.shareLink ?? ""), sourceRect: self.view.frame)
                break
            case .changePassword:
                let vc = ForgotChangePasswordController.instantiateFromStoryboard()
                vc.forgotChangePass = .changePass
                self.navigationController?.show(vc, sender: nil)
                break
            case .socialMedia:
                let vc = SocialMediaController.instantiateFromStoryboard()
                navigateTOVC(vc: vc)
                break
            case .viewLocalListing:
                let vc = HealthCareListController.instantiateFromStoryboard()
                navigateTOVC(vc: vc)
                break
            case .appointmentHistory:
                let vc = AppointmentHistoryController.instantiateFromStoryboard()
                navigateTOVC(vc: vc)
                break
            case .myMessages:
                let vc = ChatListController.instantiateFromStoryboard()
                navigateTOVC(vc: vc)
                break
            case .contactus:
                let vc = CMSController.instantiateFromStoryboard()
                vc.enumForCMS = .contactus
                navigateTOVC(vc: vc)
                break
            }
        }
    }
    
    private func navigateTOVC(vc: UIViewController) {
        //        let homeVC = HomeController.instantiateFromStoryboard()
        self.navigationController?.show(vc, sender: nil)
        //        self.navigationController?.setViewControllers([homeVC,vc], animated: true)
    }
}

extension SideMenuVC {
    
    private func logoutApi() {
        APIClient.logout(userID: UserDefaults.standard.user?.user_id ?? 0) { (result) in
            switch result {
            case .success( _):
                break
            case .failure( _):
                break
            }
        }
    }
    
    private func cmsAPI() {
        APIClient.cms(doShowLoading: false) { (result) in
            switch result {
            case .success(let response):
                UserDefaults.standard.shareLink = response.shareourapp_data?.first?.ios_link
                break
            case .failure( _):
                break
            }
        }
    }
}
