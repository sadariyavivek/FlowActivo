//
//  CMSController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 07/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CMSController: CoreViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var lblTitle: CoreLabel!
    @IBOutlet weak var lblDesc: CoreLabel!
    @IBOutlet weak var lblAddress: CoreLabel!
    @IBOutlet weak var lblPhone: CoreLabel!
    @IBOutlet weak var lblEmail: CoreLabel!
    @IBOutlet weak var lblWebsite: CoreLabel!
    @IBOutlet weak var contactView: UIScrollView!
    @IBOutlet weak var aboutView: UIScrollView!
    
    var enumForCMS : EnumForCMS = .about
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cmsAPI()
    }    
}

extension CMSController {
    private func cmsAPI() {
        APIClient.cms(doShowLoading: true) { (result) in
            switch result {
            case .success(let response):
                UserDefaults.standard.shareLink = response.shareourapp_data?.first?.ios_link
                switch self.enumForCMS {
                case .about:
                    self.lblTitle.text = "About Us"
                    self.lblDesc.attributedText = response.aboutus_data?.first?.description?.html2AttributedString
                    self.aboutView.isHidden = false
                    self.contactView.isHidden = !self.aboutView.isHidden
                    break
                case .contactus:
                    self.lblAddress.text = response.contactus_data?.first?.address
                    self.lblPhone.text = response.contactus_data?.first?.phone
                    self.lblEmail.text = response.contactus_data?.first?.email
                    self.lblWebsite.text = response.contactus_data?.first?.website
                    self.contactView.isHidden = false
                    self.aboutView.isHidden = !self.contactView.isHidden
                    break
                case .privacypolicy:
                    self.lblTitle.text = "Privacy Policy"
                    self.lblDesc.attributedText = response.privacypolicy_data?.first?.description?.html2AttributedString
                    self.aboutView.isHidden = false
                    self.contactView.isHidden = !self.aboutView.isHidden
                    break
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
