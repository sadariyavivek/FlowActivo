//
//  HealthCareDetailsController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class HealthCareDetailsController: CoreViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnRequest: CoreButton!
    @IBOutlet weak var tblView: CoreTableView!
    
    //MARK:- Properties
    var enumForHealthCareDetails: HealthCareDetails = .about
    var providerID = 0
    private var response = CoreResponseData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(HealthCareDetailsCell.nib, forCellReuseIdentifier: HealthCareDetailsCell.identifier)
        tblView.register(ReviewCell.nib, forCellReuseIdentifier: ReviewCell.identifier)
        tblView.register(LocationCell.nib, forCellReuseIdentifier: LocationCell.identifier)
        tblView.register(NoDataFoundCell.nib, forCellReuseIdentifier: NoDataFoundCell.identifier)
        handleClicks()
        providerDetailsApi(isLoader: true)
    }
}

//MARK:- Handle Clicks
extension HealthCareDetailsController {
    
    private func handleClicks(){
        btnRequest.handleTap = {
            if UserDefaults.standard.role_id == 1 {
                self.showMyAlert(desc: "Please login to Customer account to continue", logoutTitle: "SIGN IN", cancelTitle: "CANCEL", logOutnHandler: {
                    self.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }, cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                return
            } else if UserDefaults.standard.role_id == 2 {
                self.showMyAlert(desc: "Please login to continue", logoutTitle: "SIGN IN", cancelTitle: "CANCEL", logOutnHandler: {
                    self.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }, cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                return
            }
            let vc = AppointmentCotroller.instantiateFromStoryboard()
            vc.providerDetails = self.response.provider_data?.first ?? UserData(json: [:])!
            self.navigationController?.show(vc, sender: nil)
        }
    }
}

//MARK:- TableView Methods
extension HealthCareDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return response.provider_data?.count ?? 0
        } else {
            switch enumForHealthCareDetails {
            case .about:
                return 0
            case .rate:
                return response.rateandreviews_data?.count ?? 0 <= 0 ? 1 : response.rateandreviews_data?.count ?? 0
            case .location:
                return 1
            case .reviews:
                return response.rateandreviews_data?.count ?? 0 <= 0 ? 1 : response.rateandreviews_data?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HealthCareDetailsCell.identifier, for: indexPath) as! HealthCareDetailsCell
            cell.providerDetails = response.provider_data?[indexPath.row]
            cell.blockForSelectDetails = { enumForDetails in
                self.enumForHealthCareDetails = enumForDetails
                self.tblView.reloadSections(IndexSet([1]), with: .automatic)
            }
            cell.btnCall.handleTap = {
                PhoneNumber.init(extractFrom: self.response.provider_data?[indexPath.row].phone ?? "")?.makeACall()
            }
            return cell
        } else {
            switch enumForHealthCareDetails {
            case .about:
                return UITableViewCell()
            case .rate:
                if response.rateandreviews_data?.count ?? 0 <= 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundCell.identifier, for: indexPath) as! NoDataFoundCell
                    cell.lblNodata.text = "No Rating Found."
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
                cell.reviews = response.rateandreviews_data?[indexPath.row]
                return cell
            case .location:
                let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
                cell.provide = response.provider_data?[indexPath.row]
                return cell
            case .reviews:
                if response.rateandreviews_data?.count ?? 0 <= 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundCell.identifier, for: indexPath) as! NoDataFoundCell
                    cell.lblNodata.text = "No Review Found."
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
                return cell
            }
            
        } 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension :UITableView.automaticDimension 
    }
}

//MARK:- API CALL
extension HealthCareDetailsController {
    
    private func providerDetailsApi(isLoader: Bool) {
        APIClient.providerDetails(providerID: providerID, pageLimit: PageLimit(page: 1, limit: PAGINATION_LIMIT), doShowLoading: isLoader) { (result) in
            switch result {
            case .success(let response):
                //                self.providerDetails = response.provider_data?.first ?? Providers(json: [:])!
                self.response = response
                self.tblView.reloadData()
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
