//
//  LaunchController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class LaunchController: CoreViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLogout {
            isLogout = false
            let vc = ChoosePatientHeathCareController.instantiateFromStoryboard()
            self.navigationController?.setViewControllers([vc], animated: false)
        } else {
            navigateToScreen()
        }        
    }
    
    private func navigateToScreen() {
        if !UserDefaults.standard.isIntroVC {
            UserDefaults.standard.isIntroVC = true
            self.redirectToIntroScreen()
        } else if UserDefaults.standard.user == nil {
            self.redirectToChooseUserScreen()
        }
//        else if UserDefaults.standard.role_id == 1 && UserDefaults.standard.user?.payment_status == false {
//            gotoLoginScreen()
//        }
        else {
            self.redirectHomeScreen()
        }
    }
    
    func gotoLoginScreen() {
        let vc = ChoosePatientHeathCareController.instantiateFromStoryboard()
        let loginVC = LoginVC.instantiateFromStoryboard()
        self.navigationController?.setViewControllers([vc, loginVC], animated: false)
    }
}
