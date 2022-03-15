//
//  FilterController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 21/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class FilterController: CoreViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchBar: CoreSearchBar!
    @IBOutlet weak var btnFilter: CoreButton!
    @IBOutlet weak var tblView: CoreTableView!
    
    //MARK:- Properties
    private var recentSearch = [RecentSearch]()
    private var filterArray = [HealthCareCategory]()
    private var enumSearch : EnumSearchScreen = .recentSearch
    private var providerArray = [Providers]()
    private var page = 1
    private var responseData = CoreResponseData()
    private let loadMoreTableFooterView = LoadMoreTableHeaderFooterView.fromNib()
    var isTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(FilterCell.nib, forCellReuseIdentifier: FilterCell.identifier)
        tblView.register(HealthCareListCell.nib, forCellReuseIdentifier: HealthCareListCell.identifier)
        handleclicks()
        if UserDefaults.standard.user != nil {
            searchApi(type: "Recent")
        }
        if isTap {
            searchBar.becomeFirstResponder()
        }
    }
    
    //MARK:- Handle Clicks
    private func handleclicks() {
        btnFilter.handleTap = {
            self.enumSearch = .filter
            self.searchApi(type: "Listing")
        }
        searchBar.shouldBeginEditingBlock = {
            if self.isTap {
                self.isTap = false
            } else {
                self.enumSearch = .isSearching
            }
            return true
        }
        searchBar.blockForTextChange = { txt in
            if txt != "" {
                self.searchApi(isLoader: false, type: "Suggestions", searchTxt: txt)
            } else {
                self.filterArray = []
                self.tblView.reloadData()
            }
        }
        searchBar.blockForSearchTapped =  {
            self.searchBar.resignFirstResponder()
        }
        searchBar.blockForCancleTapped = {
            self.filterArray = []
            self.tblView.reloadData()
        }
    }
}

//MARK:- TableView Methods
extension FilterController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enumSearch {
        case .search, .recentSearch: return recentSearch.count
        case .isSearching : return filterArray.count
        case .filter: return filterArray.count
        case .success: return providerArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: tblView.frame.width, height: 40))
        tempView.backgroundColor = .mischka
        let lbl = CoreLabel(frame: CGRect(15, 0, tempView.frame.width, tempView.frame.height))
        lbl.text = enumSearch == .recentSearch ? "Recent Search" : "All specialities"
        lbl.font = AppFont.dejaVuSansBold.getFont(withSize: Constants.isIphone() ? 13 : 16)
        tempView.addSubview(lbl)
        return enumSearch == .search || enumSearch == .recentSearch && recentSearch.count > 0 ? tempView : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        switch enumSearch {
        case .search, .recentSearch:
            cell.categoryView.isHidden = true
            cell.accessoryType = .none
            tblView.separatorStyle = .none
            cell.recentSearch = recentSearch[indexPath.row]
            break
        case .isSearching:
            cell.categoryView.isHidden = true
            cell.accessoryType = .none
            tblView.separatorStyle = .none
            cell.lblTitle.text = filterArray[indexPath.row].type
            break
        case .filter:
            cell.categoryView.isHidden = false
            cell.accessoryType = .disclosureIndicator
            tblView.separatorStyle = .singleLine
            cell.category = filterArray[indexPath.row]
            break
        case .success:
            let cell = tableView.dequeueReusableCell(withIdentifier: HealthCareListCell.identifier, for: indexPath) as! HealthCareListCell
            cell.provider = providerArray[indexPath.row]
            cell.btnMoreInfo.handleTap = {
                let detailVC = HealthCareDetailsController.instantiateFromStoryboard()
                detailVC.providerID = self.providerArray[indexPath.row].user_id ?? 0
                self.navigationController?.show(detailVC, sender: nil)
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchtxt = ""
        var filter = ""
        switch enumSearch {
        case .search, .recentSearch:
            searchtxt = recentSearch[indexPath.row].text ?? ""
            filter = "Unavailable"
            break
        case .isSearching:
            searchtxt = filterArray[indexPath.row].type ?? ""
            filter = "Unavailable"
            break
        case .filter:
            searchtxt = filterArray[indexPath.row].type ?? ""
            filter = "Available"
            break
        case .success: break
        }
        if UserDefaults.standard.user != nil && enumSearch != .success {
            searchApi(type: "SaveRecent", searchTxt: searchtxt)
        }
        enumSearch = .success
        page = 1
        if providerArray.count <= 0 {
        searchList(isLoader: true, isLoadingMore: false, isPullToRefresh: false, searchTxt: searchtxt, filter: filter, completion: nil)
        }        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if enumSearch == .success {
            if indexPath.row == providerArray.count - 1 {
                if providerArray.count == responseData.total_rows ?? 0 {
                    self.showHideLoadMoreView(tblView: tblView, loadMoreTableFooterView: loadMoreTableFooterView)
                } else {
                    if let lastpage = responseData.last_page, let currentPage = responseData.current_page, lastpage > currentPage {
                        if !loadMoreTableFooterView.isAnimating() {
                            searchList(isLoader: false, isLoadingMore: true, isPullToRefresh: false) {
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
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
            self.showHideLoadMoreView(tblView: tblView, loadMoreTableFooterView: loadMoreTableFooterView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return enumSearch == .search || enumSearch == .recentSearch && recentSearch.count > 0 ? 40 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- API CALL
extension FilterController {
    
    private func searchApi(isLoader: Bool = true, type: String, searchTxt: String? = nil) {
        APIClient.search(type: type, userID: UserDefaults.standard.user?.user_id ?? 0, searchTxt: searchTxt, doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                switch self.enumSearch {
                case .filter, .isSearching:
                    self.filterArray = response.getCategory() ?? []
                    break
                case .search:
                    self.recentSearch = response.getRecentSearch() ?? []
                    break
                case .recentSearch:
                    self.recentSearch = response.getRecentSearch() ?? []
                    break
                case .success: break
                }
                self.providerArray.removeAll()
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
    
    private func searchList(isLoader: Bool, isLoadingMore: Bool = false, isPullToRefresh: Bool = false, searchTxt: String? = nil, filter: String? = nil, completion: voidCompletion? = nil) {
        APIClient.search(type: "Result", userID: UserDefaults.standard.user?.user_id ?? 0, searchTxt: searchTxt, pageLimit: PageLimit(page: page, limit: PAGINATION_LIMIT), filter: filter, doShowLoading: isLoader) { (result) in
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
