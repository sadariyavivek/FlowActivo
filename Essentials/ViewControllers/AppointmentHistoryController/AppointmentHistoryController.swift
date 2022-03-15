//
//  AppointmentHistoryController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 06/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class AppointmentHistoryController: CoreViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var collectView: CoreCollectionView!
    @IBOutlet weak var tblview: CoreTableView!
    @IBOutlet weak var lblNoData: CoreLabel!
    
    //MARK:- Properties
    private var enumForHistory = [EnumForHistory]()
    private var selectedIndex = 0
    private var historyArray = [AppointmentHistory]()
    private var role = ""
    private var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enumForHistory = [.complete,.pending, .cancelled]
        collectView.register(HistoryMenuCell.nib, forCellWithReuseIdentifier: HistoryMenuCell.identifier)
        collectView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tblview.register(HistoryCell.nib, forCellReuseIdentifier: HistoryCell.identifier)
        tblview.rowHeight = UITableView.automaticDimension
        role = UserDefaults.standard.role_id == 0 ? "Customers" : "Providers"
        type = "Completed"
        historyApi(isLoder: true, role: role, type: type)
        handleClicks()
    }
    
    private func handleClicks() {
        tblview.didPullToRefresh = { control in
            self.historyApi(isLoder: false, role: self.role, type: self.type) {
                control.endRefreshing()
            }
        }
    }
}

//MARK:- CollectionView Methods
extension AppointmentHistoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enumForHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryMenuCell.identifier, for: indexPath) as! HistoryMenuCell
        cell.lblTitle.textColor = selectedIndex == indexPath.item ? .malibu : .darkGray
        cell.lblBottomLine.isHidden = selectedIndex != indexPath.item
        cell.lblTitle.text = enumForHistory[indexPath.item].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        UIView.performWithoutAnimation {
            self.collectView.reloadData()
        }
        if enumForHistory[selectedIndex] == .complete {
            type = "Completed"
        } else if enumForHistory[selectedIndex] == .pending {
            type = "Pending"
        } else if enumForHistory[selectedIndex] == .cancelled {
            type = "Cancelled"
        }
        historyApi(isLoder: true, role: role, type: type)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectView.frame.width / CGFloat(enumForHistory.count)) - 20, height: collectView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

//MARK:- TableView Methods
extension AppointmentHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        cell.history = historyArray[indexPath.row]
        cell.btnStart.handleTap = {
            let status = self.historyArray[indexPath.row].appointment_status
            self.historyArray[indexPath.row].appointment_status = status == 1 ? 2 : 1
            let isStart = self.historyArray[indexPath.row].appointment_status == 1
            self.completeAppointmentApi(isStart: isStart, history: self.historyArray[indexPath.row]) {
                if isStart {
                    self.tblview.reloadRows(at: [indexPath], with: .none)
                } else {
                    self.historyArray.remove(at: indexPath.row)
                    self.tblview.reloadData()
                }
                if self.historyArray.count <= 0 {
                    self.historyApi(isLoder: false, role: self.role, type: self.type)
                }
            }
        }
        cell.btnRate.handleTap = {
            let vc = ErrorMessageController.instantiateFromStoryboard()
            vc.enumForErrorOrText = .rateReview
            vc.history = self.historyArray[indexPath.row]
            vc.blockForOk = {
                self.historyArray.remove(at: indexPath.row)
                self.tblview.reloadData()
                if self.historyArray.count <= 0 {
                    self.historyApi(isLoder: false, role: self.role, type: self.type)
                }
            }
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        }
        cell.btnCancel.handleTap = {
            let vc = ErrorMessageController.instantiateFromStoryboard()
            vc.enumForErrorOrText = .textView
            vc.history = self.historyArray[indexPath.row]
            vc.blockForOk = {
                self.historyArray.remove(at: indexPath.row)
                if self.historyArray.count <= 0 {
                    self.historyApi(isLoder: false, role: self.role, type: self.type)
                }
            }
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
}

//MARK:- API Calls

extension AppointmentHistoryController {
    
    private func historyApi(isLoder: Bool, role: String, type: String, completion: voidCompletion? = nil) {
        APIClient.appointmentHistory(role: role, type: type, userID: UserDefaults.standard.user?.user_id ?? 0, page: PageLimit(page: 1), doShowLoading: isLoder) { (result) in
            switch result {
            case .success(var response):
                self.historyArray = response.getHistory() ?? []
                self.tblview.backgroundView = self.lblNoData
                self.tblview.backgroundView?.isHidden = self.historyArray.count > 0
                self.tblview.reloadData()
                completion?()
                break
            case .failure(let error):
                completion?()
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
    
    private func completeAppointmentApi(isStart: Bool, history: AppointmentHistory, completion: voidCompletion? = nil) {
        APIClient.completeAppointment(history: history, isStart: isStart, doShowLoading: true) { (result) in
            switch result {
            case .success(let response):
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
