//
//  HealthCareDetailsCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import FloatRatingView

class HealthCareDetailsCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: CoreImageView!
    @IBOutlet weak var btnChat: CoreButton!
    @IBOutlet weak var btnCall: CoreButton!
    @IBOutlet weak var lblName: CoreLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblRateCount: CoreLabel!
    @IBOutlet weak var collectView: CoreCollectionView!
    @IBOutlet weak var collectViewHeight: NSLayoutConstraint!
    
    //MARK:- Properties
    var enumForHealthCareDetails = [HealthCareDetails]()
    private var selectedIndex = 0
    var blockForSelectDetails : ((_ enumForDetail: HealthCareDetails)->Void)?
    var providerDetails: UserData? {
        didSet {
            guard let details = providerDetails else {  return   }
            let urlString = details.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imgProfile.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
            lblName.text = "\(details.firstname ?? "") \(details.lastname ?? "")"
            ratingView.rating = Double(integerLiteral: Int64(details.rate_average ?? 0))
            lblRateCount.text = "(\(details.total_rateandreview ?? 0))"
            btnCall.isHidden = UserDefaults.standard.role_id == 2
            btnChat.isHidden = UserDefaults.standard.role_id == 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewWidth.constant = Constants.isIphone() ? 130 : 150
        imgViewHeight.constant = imgViewWidth.constant
        imgProfile.cornerRadius = Double(imgViewWidth.constant / 2)
        enumForHealthCareDetails = [.about, .rate, .location, .reviews]
        collectView.register(HealthCareMenuCell.nib, forCellWithReuseIdentifier: HealthCareMenuCell.identifier)
        collectView.dataSource = self
        collectView.delegate = self
        collectView.reloadData()
    }
        
    func menuOptionisHide(isHide: Bool) {
        collectViewHeight.constant = isHide ? 0 : Constants.isIphone() ? 35 : 40
        collectView.isHidden = isHide
    }
}

//MARK:- CollectionView Methods
extension HealthCareDetailsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enumForHealthCareDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HealthCareMenuCell.identifier, for: indexPath) as! HealthCareMenuCell
        cell.lblBottomLine.isHidden = selectedIndex != indexPath.item
        cell.lblTitle.text = enumForHealthCareDetails[indexPath.item].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        blockForSelectDetails?(enumForHealthCareDetails[indexPath.item])
        UIView.performWithoutAnimation {
            self.collectView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectView.frame.width / CGFloat(enumForHealthCareDetails.count)) - 10, height: collectView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
