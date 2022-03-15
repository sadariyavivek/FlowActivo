//
//  AppointmentCotroller.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import SwiftDate

struct WeekData {
    var weekName : String = ""
    var isSelected : Bool = false
    var startTime : String = ""
    var endTime : String = ""
}

class AppointmentCotroller: CoreViewController {
    
    @IBOutlet weak var tblView: CoreTableView!
    
    //MARK:- Properties
    private var ismakeAppointment = false
    var providerDetails = UserData(json: [:])!
    private var selectedDate : String? = nil
    private var selectTime: String? = nil
    private var selectDay: String? = nil
    private var comment: String? = nil
    private var tempDate: Date?
    var weekNameArray : [WeekData] = [WeekData(weekName: "Mon", isSelected: false, startTime: "", endTime: ""), WeekData(weekName: "Tue", isSelected: false, startTime: "", endTime: ""), WeekData(weekName: "Wed", isSelected: false, startTime: "", endTime: ""), WeekData(weekName: "Thu", isSelected: false, startTime: "", endTime: ""), WeekData(weekName: "Fri", isSelected: false, startTime: "", endTime: ""), WeekData(weekName: "Sat", isSelected: false, startTime: "", endTime: ""),WeekData(weekName: "Sun", isSelected: false, startTime: "", endTime: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(AppointmentCalendarCell.nib, forCellReuseIdentifier: AppointmentCalendarCell.identifier)
        tblView.register(MakeAppointmentCell.nib, forCellReuseIdentifier: MakeAppointmentCell.identifier)
        tblView.register(HealthCareDetailsCell.nib, forCellReuseIdentifier: HealthCareDetailsCell.identifier)
        var tempArrya = [WeekData]()
        for week in weekNameArray {
            if week.weekName == "Mon" {
                let isTrue = providerDetails.monday == 1 ? true : false
                let dict = WeekData(weekName: "Mon", isSelected: isTrue, startTime: providerDetails.monday_start_time ?? "", endTime: providerDetails.monday_end_time ?? "")
                tempArrya.append(dict)
            } else if week.weekName == "Tue" {
                let isTrue = providerDetails.tuesday == 1 ? true : false
                let dict = WeekData(weekName: "Tue", isSelected: isTrue, startTime: providerDetails.tuesday_start_time ?? "", endTime: providerDetails.tuesday_end_time ?? "")
                tempArrya.append(dict)
            } else if week.weekName == "Wed" {
                let isTrue = providerDetails.wednesday == 1 ? true : false
                let dict = WeekData(weekName: "Wed", isSelected: isTrue, startTime: providerDetails.wednesday_start_time ?? "", endTime: providerDetails.wednesday_end_time ?? "")
                tempArrya.append(dict)
            } else if week.weekName == "Thu" {
                let isTrue = providerDetails.thursday == 1 ? true : false
                let dict = WeekData(weekName: "Thu", isSelected: isTrue, startTime: providerDetails.thursday_start_time ?? "", endTime: providerDetails.thursday_end_time ?? "")
                tempArrya.append(dict)
            } else if week.weekName == "Fri" {
                let isTrue = providerDetails.friday == 1 ? true : false
                let dict = WeekData(weekName: "Fri", isSelected: isTrue, startTime: providerDetails.friday_start_time ?? "", endTime: providerDetails.friday_end_time ?? "")
                tempArrya.append(dict)
            } else if week.weekName == "Sat" {
                let isTrue = providerDetails.saturday == 1 ? true : false
                let dict = WeekData(weekName: "Sat", isSelected: isTrue, startTime: providerDetails.saturday_start_time ?? "", endTime: providerDetails.saturday_end_time ?? "")
                tempArrya.append(dict)
            } else if week.weekName == "Sun" {
                let isTrue = providerDetails.sunday == 1 ? true : false
                let dict = WeekData(weekName: "Sun", isSelected: isTrue, startTime: providerDetails.sunday_start_time ?? "", endTime: providerDetails.sunday_end_time ?? "")
                tempArrya.append(dict)
            }
        }
        weekNameArray = tempArrya
    }
    
    // MARK:- Validation
    private func isValid() -> Bool {
        let tempWeekName = tempDate?.getString(inFormat: "EEE")
        let weekObj = weekNameArray.first(where: {$0.weekName == tempWeekName})
        let year = Int(tempDate?.getString(inFormat: "yyyy") ?? "0")
        let month = Int(tempDate?.getString(inFormat: "MM") ?? "0")
        let region = Region(calendar: Calendars.gregorian, zone: Zones.americaNewYork, locale: Locales.englishUnitedStates)
        let startTime = weekObj?.startTime.components(separatedBy: ":")
        var startDate = DateInRegion()
        var endDate = DateInRegion()
        var tempSelectdate = DateInRegion()
        if startTime?.count ?? 0 > 1 {
            let hour = Int(startTime?[0] ?? "10") ?? 10
            let minuteArray = startTime?[1].components(separatedBy: " ")
            let minute = Int(minuteArray?[0] ?? "00") ?? 00
            startDate = DateInRegion(year: year ?? 2020, month: month ?? 02, day: 0, hour: hour, minute: minute, second: 0, nanosecond: 0, region: region)
        }
        let endTime = weekObj?.endTime.components(separatedBy: ":")
        if endTime?.count ?? 0 > 1 {
            let hour = Int(endTime?[0] ?? "10") ?? 10
            let minuteArray = endTime?[1].components(separatedBy: " ")
            let minute = Int(minuteArray?[0] ?? "00") ?? 00
            endDate = DateInRegion(year: year ?? 2020, month: month ?? 02, day: 0, hour: hour, minute: minute, second: 0, nanosecond: 0, region: region)
        }
        let tempSelectTime = selectTime?.components(separatedBy: ":")
        if tempSelectTime?.count ?? 0 > 1 {
            let hour = Int(tempSelectTime?[0] ?? "10") ?? 10
            let minuteArray = tempSelectTime?[1].components(separatedBy: " ")
            let minute = Int(minuteArray?[0] ?? "00") ?? 00
            tempSelectdate = DateInRegion(year: year ?? 2020, month: month ?? 02, day: 0, hour: hour, minute: minute, second: 0, nanosecond: 0, region: region)
        }
        var msg = ""
        if selectedDate == nil {
            msg = "Please select date."
        } else if !(weekObj?.isSelected ?? false) {
            msg = "\(providerDetails.firstname ?? "") \(providerDetails.lastname ?? "") is not available at the time you selected. Choose another provider."
            self.showMyAlert(desc: msg,logoutTitle: "CHOOSE PROVIDER", cancelTitle: "CANCEL", logOutnHandler: {
                let vcs = self.navigationController?.viewControllers ?? []
                for vc in vcs {
                    if vc is HealthCareListController {
                        self.dismiss(animated: true) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }
            }, cancelHandler: {
                self.dismiss(animated: true, completion: nil)
            }, vc: self)
            return false
        } else if selectTime == nil {
            msg = "Please select time."
        } else if tempSelectdate < startDate && tempSelectdate > endDate {
            msg = "\(providerDetails.firstname ?? "") \(providerDetails.lastname ?? "") is not available at the time you selected. Choose another provider."
            self.showMyAlert(desc: msg,logoutTitle: "CHOOSE PROVIDER", cancelTitle: "CANCEL", logOutnHandler: {
                let vcs = self.navigationController?.viewControllers ?? []
                for vc in vcs {
                    if vc is HealthCareListController {
                        self.dismiss(animated: true) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }
            }, cancelHandler: {
                self.dismiss(animated: true, completion: nil)
            }, vc: self)
            return false
        } else if ismakeAppointment && comment == nil || comment == "" {
            if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MakeAppointmentCell {
                cell.txtComment.borderColor = .systemRed
                cell.lblError.isHidden = false
                msg = " "
            }
        } else {
            if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MakeAppointmentCell {
                cell.txtComment.borderColor = .darkGray
                cell.lblError.isHidden = true
            }
        }
        if msg == " "{
            return false
        } else if msg.count > 0 {
            self.showMyAlert(desc: msg, cancelTitle: "OK", cancelHandler: {
                self.dismiss(animated: true, completion: nil)
            }, vc: self)
            return false
        }
        return true
    }
}

//MARK:- TableView Methods
extension AppointmentCotroller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HealthCareDetailsCell.identifier, for: indexPath) as! HealthCareDetailsCell
            cell.providerDetails = providerDetails
            cell.blockForSelectDetails = { enumForDetails in
                self.tblView.reloadSections(IndexSet([1]), with: .automatic)
            }
            cell.menuOptionisHide(isHide: true)
            return cell
        } else if ismakeAppointment {
            let cell = tableView.dequeueReusableCell(withIdentifier: MakeAppointmentCell.identifier, for: indexPath) as! MakeAppointmentCell
            cell.lblAddrss.text = providerDetails.address
            cell.lblDate.text = selectedDate
            cell.lblTime.text = selectTime
            cell.lblAddrss.text = providerDetails.address
            cell.txtComment.blockForTextChange = { txt in
                cell.txtComment.borderColor = .darkGray
                cell.lblError.isHidden = true
                self.comment = txt
                cell.txtComment.text = txt
            }
            cell.btnSubmit.handleTap = {
                if self.isValid() {
                    self.requestAppoinment()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentCalendarCell.identifier, for: indexPath) as! AppointmentCalendarCell
            cell.txtTime.timeMinimumDate = nil
            cell.txtTime.blockForDoneButtonTap = { str, date in
                self.selectTime = date?.getString(inFormat: "h:mm a")
                cell.txtTime.text = "TIME : " + str
            }
            cell.blockForSelectDate = { selectedDates in
                self.tempDate = selectedDates
                self.selectDay = selectedDates?.getString(inFormat: "EEEE")
                self.selectedDate = selectedDates?.getString(inFormat: "yyyy-MM-dd")
            }
            cell.btnConfirm.handleTap = {
                if self.isValid() {
                    self.ismakeAppointment = true
                    self.tblView.reloadSections(IndexSet([1]), with: .left)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AppointmentCotroller {
    
    private func requestAppoinment() {
        APIClient.requestAppoinment(provider: providerDetails, day: selectDay ?? "", time: selectTime ?? "", date: selectedDate ?? "", comment: comment ?? "", customerID: UserDefaults.standard.user?.user_id ?? 0, doShowLoading: true) { (result) in
            switch result {
            case .success(let response):
                self.showMyAlert(desc: response.message ?? "", cancelTitle: "OK", cancelHandler: {
                    let vcs = self.navigationController?.viewControllers ?? []
                    for vc in vcs {
                        if vc is HealthCareListController {
                            self.dismiss(animated: true) {
                                self.navigationController?.popToViewController(vc, animated: true)
                            }
                        }
                    }
                }, vc: self)
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
