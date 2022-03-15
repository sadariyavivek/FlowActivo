//
//  CoreViewController.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreViewController: UIViewController {

    var navigationBarTintColor: UIColor = .clear {
        didSet {
            self.setupNavigationBarBGColor()
        }
    }
    var navigationTintColor: UIColor = .malibu {
        didSet {
            self.navigationController?.navigationBar.tintColor = navigationTintColor
        }
    }
    
    var navigationBarTitleColor: UIColor = .white {
        didSet {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navigationBarTitleColor]
        }
    }
    
    var navigationbarUnderLineisShow: Bool = false {
        didSet {
            navigationController?.navigationBar.setBackgroundImage(navigationbarUnderLineisShow ? nil :  UIImage(), for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = navigationbarUnderLineisShow ?  UIColor.malibu.image() : UIImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          setNavigationTitleView()
//        self.navigationItem.backBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitleView()
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setupNavigationBarBGColor() {
        self.navigationController?.navigationBar.barTintColor = navigationBarTintColor
        navigationController?.navigationBar.setBackgroundImage(navigationBarTintColor != .clear ? nil : UIImage(), for: .default)
    }
    
    func redirectToIntroScreen() {
        let vc = IntroVC.instantiateFromStoryboard()
        self.navigationController?.show(vc, sender: nil)
    }
    
    func redirectToChooseUserScreen() {
        let vc = ChoosePatientHeathCareController.instantiateFromStoryboard()
        self.navigationController?.show(vc, sender: nil)
    }
    
    func redirectHomeScreen() {
        let vc = HomeController.instantiateFromStoryboard()
        let navVC = CoreNavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func showShareActivity(msg: String?, textDesc: String? = nil, image: UIImage?, url: URL?, sourceRect:CGRect?){
        var shareAll = [Any]()
        if let text = msg {
            shareAll.append(text)
        }
        if let text = textDesc {
            shareAll.append(text)
        }
        if let img = image {
            shareAll.append(img)
        }
        if let strURL = url {
            shareAll.append(strURL)
        }
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showHideLoadMoreView(doShow: Bool = false, tblView: CoreTableView, loadMoreTableFooterView :LoadMoreTableHeaderFooterView) {
        loadMoreTableFooterView.frame = CGRect(x: 0, y: 0, width: loadMoreTableFooterView.frame.size.width, height: doShow ? 50 : 0)
        loadMoreTableFooterView.layoutIfNeeded()
        if doShow {
            loadMoreTableFooterView.startAnimating()
        } else {
            loadMoreTableFooterView.stopAnimating()
        }
        tblView.tableFooterView = loadMoreTableFooterView
    }
        
    func setNavigationTitleView() {
        if self is RegisterController || self is RegisterInfoController || self is EditProfileController {
            let imageView = UIImageView(image:"title".imageWithOriginalMode.resize(value: Constants.isIphone() ? 150 : 250))
            self.navigationItem.titleView = imageView
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(3, for: .default)
        }
        if self is HomeController {
            let sideMenuBtn = UIBarButtonItem(image: "ic_menu".imageWithOriginalMode.resize(value: Constants.isIphone() ? 30 : 35), style: .plain, target: self, action: #selector(menuClicked))
            let notificationBtn = UIBarButtonItem(image: "ic_notification".imageWithOriginalMode.resize(value: Constants.isIphone() ? 25 : 30), style: .plain, target: self, action: #selector(notificationClicked))
            self.navigationItem.rightBarButtonItem = notificationBtn
            self.navigationItem.leftBarButtonItem = sideMenuBtn
        }
        if self is SideMenuVC || self is HealthCareListController || self is HealthCareDetailsController || self is AppointmentCotroller || self is FilterController || self is SocialMediaController || self is AppointmentHistoryController || self is CMSController || self is ChatListController || self is ChatController{
            //Back Button
            self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_back")?.resize(value: Constants.isIphone() ? 20 : 25)
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_back")?.resize(value: Constants.isIphone() ? 20 : 25)
            //Notification Button
            let notificationBtn = UIBarButtonItem(image: "ic_notification".imageWithOriginalMode.resize(value: Constants.isIphone() ? 25 : 30), style: .plain, target: self, action: #selector(notificationClicked))
            //Search Button
            let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchClicked))
            searchBtn.tintColor = .malibu
            if !(self is FilterController) {
                self.navigationItem.rightBarButtonItems = [notificationBtn, searchBtn]
            } else {
                self.navigationItem.rightBarButtonItems = [notificationBtn]
            }
            //Header Logo
            if !(self is SideMenuVC) {
                let imageView = UIImageView(image:"ic_headerLogo".imageWithOriginalMode.resize(value: Constants.isIphone() ? 35 : 40))
                self.navigationItem.titleView = imageView
            }
        }
    }
    
    @objc func notificationClicked() {
        let vc = NotificationController.instantiateFromStoryboard()
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func searchClicked() {
        let vc = FilterController.instantiateFromStoryboard()
        self.navigationController?.show(vc, sender: nil)
    }
    
    @objc func menuClicked() {
    }
}
