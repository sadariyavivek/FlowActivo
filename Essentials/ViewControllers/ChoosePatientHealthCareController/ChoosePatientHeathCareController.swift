//
//  ChoosePatientHeathCareController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class ChoosePatientHeathCareController: CoreViewController {
    
    @IBOutlet weak var btnPatient: UIButton!
    @IBOutlet weak var btnProvider: UIButton!
    //MARK:- Properties
    var enumForPatientOrHealthCare: PatientOrHealthCare = .customer
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enumForPatientOrHealthCare = .customer
        btnPatient.isSelected = true
        btnProvider.isSelected = !btnPatient.isSelected
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

//MARK:- Clicks Handle
extension ChoosePatientHeathCareController {
    
    @IBAction func guestClicked(_ sender: UIButton) {
        UserDefaults.standard.role_id = PatientOrHealthCare.guest.value
        self.redirectHomeScreen()
    }
    
    @IBAction func patientClicked(_ sender: UIButton) {
        enumForPatientOrHealthCare = .customer
        sender.isSelected = true
        btnProvider.isSelected = !sender.isSelected
    }
    
    @IBAction func healthCareClicked(_ sender: UIButton) {
        enumForPatientOrHealthCare = .provider
        sender.isSelected = true
        btnPatient.isSelected = !sender.isSelected
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getStartedClicked(_ sender: UIButton) {
        let login = LoginVC.instantiateFromStoryboard()
        login.enumForPatientOrHealthCare = enumForPatientOrHealthCare
        self.navigationController?.show(login, sender: nil)
    }
}
