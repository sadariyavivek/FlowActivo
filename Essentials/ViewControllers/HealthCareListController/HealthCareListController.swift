//
//  HealthCareListController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 16/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import CoreLocation

class HealthCareListController: CoreViewController {
    
    @IBOutlet weak var tblView: CoreTableView!
    
    private var page = 1
    private var responseData = CoreResponseData()
    private var providerArray = [Providers]()
    private let loadMoreTableFooterView = LoadMoreTableHeaderFooterView.fromNib()
    private var coordinates = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(HealthCareListCell.nib, forCellReuseIdentifier: HealthCareListCell.identifier)
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 80
        handleClicks()
        checkPermission()
    }
    
    // Permission for Location
    private func checkPermission() {
        PermissionManager.manager.checkAndAskFor(permission: .location) { (issucces) in
            if issucces {
                LocationManager.manager.getUserCurrentLocation = { coordinat in
                    self.coordinates = coordinat
                    self.providerList(isLoader: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK:- Handle Clickes
    private func handleClicks() {
        tblView.didPullToRefresh = { control in
            self.page = 1
            self.providerList(isLoader: false, isLoadingMore: false, isPullToRefresh: true) {
                control.endRefreshing()
            }
        }
    }
}

//MARK:- TableView Methods
extension HealthCareListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HealthCareListCell.identifier, for: indexPath) as! HealthCareListCell
        cell.provider = providerArray[indexPath.row]
        cell.btnMoreInfo.handleTap = {
            let detailVC = HealthCareDetailsController.instantiateFromStoryboard()
            detailVC.providerID = self.providerArray[indexPath.row].user_id ?? 0
            self.navigationController?.show(detailVC, sender: nil)
        }
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == providerArray.count - 1 {
            if providerArray.count == responseData.total_rows ?? 0 {
                self.showHideLoadMoreView(tblView: tblView, loadMoreTableFooterView: loadMoreTableFooterView)
            } else {
                if let lastpage = responseData.last_page, let currentPage = responseData.current_page, lastpage > currentPage {
                    if !loadMoreTableFooterView.isAnimating() {
                        providerList(isLoader: false, isLoadingMore: true, isPullToRefresh: false) {
                            self.showHideLoadMoreView(doShow: false, tblView: self.tblView, loadMoreTableFooterView: self.loadMoreTableFooterView)
                        }
                    }
                    showHideLoadMoreView(doShow: true, tblView: self.tblView, loadMoreTableFooterView: self.loadMoreTableFooterView)
                } else {
                    showHideLoadMoreView(doShow: false, tblView: self.tblView, loadMoreTableFooterView: self.loadMoreTableFooterView)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
            self.showHideLoadMoreView(tblView: tblView, loadMoreTableFooterView: loadMoreTableFooterView)
        }
    }    
}

extension HealthCareListController {
    
    private func providerList(isLoader: Bool, isLoadingMore: Bool = false, isPullToRefresh: Bool = false, completion: voidCompletion? = nil) {
        APIClient.getProviders(pageLimit: PageLimit(page: page, limit: PAGINATION_LIMIT), coordinates: coordinates, doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.responseData = response
                let array = response.getProvider() ?? []
                if isLoadingMore {
                    self.providerArray.append(contentsOf: array)
                } else {
                    self.providerArray = array
                }
                self.page += 1
                self.tblView.reloadData()
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
}
