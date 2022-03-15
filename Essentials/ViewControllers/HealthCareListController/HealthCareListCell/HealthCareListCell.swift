//
//  HealthCareListCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 16/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import FloatRatingView

class HealthCareListCell: CoreTableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var btnInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var btnInfoBottom: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidht: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBottomSeprator: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: CoreLabel!
    @IBOutlet weak var lblSpeciality: CoreLabel!
    @IBOutlet weak var lblAddress: CoreLabel!
    @IBOutlet weak var floatingView: FloatRatingView!
    @IBOutlet weak var lblratingCount: CoreLabel!
    @IBOutlet weak var lblTime: CoreLabel!
    @IBOutlet weak var btnMoreInfo: CoreButton!
    @IBOutlet weak var lblNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMoreTop: NSLayoutConstraint!
    
    var provider: Providers? {
        didSet {
            guard let provider = provider else { return }
            lblName.text = "\(provider.firstname ?? "") \(provider.lastname ?? "")"
            lblSpeciality.text = provider.businessname
            lblAddress.text = provider.address
            floatingView.rating = provider.rate_average?.toDouble ?? 0
            lblratingCount.text = "(\(provider.total_rateandreview ?? "0"))"
            floatingView.isHidden = provider.rate_average == "0" || provider.rate_average == nil
            lblratingCount.isHidden = floatingView.isHidden// provider.total_rateandreview == 0
            lblNameTopConstraint.constant = floatingView.isHidden ? 10 : 0
            btnMoreTop.constant = floatingView.isHidden ? 10 : 30
            lblTime.text = "\(provider.distance ?? 0)" + "mi"
            let urlString = provider.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
            btnMoreInfo.isHidden = provider.user_id == UserDefaults.standard.user?.user_id
            btnInfoHeight.constant = btnMoreInfo.isHidden ? 0 : Constants.isIphone() ? 40 : 45
            btnInfoBottom.constant = btnMoreInfo.isHidden ? 0 : 20
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewWidht.constant = Constants.isIphone() ? 80 : 90
        imgViewHeight.constant = imgViewWidht.constant
        imgView.cornerRadius = Double(imgViewHeight.constant / 2)
    }
}
