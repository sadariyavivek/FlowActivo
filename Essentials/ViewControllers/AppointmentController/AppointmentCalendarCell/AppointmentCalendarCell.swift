//
//  AppointmentCalendarCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import CollectionPickerView

class DateModel {
    var date: Date?
    var strMonth : String?
    var strday : String?
    var strdate : String?
}

class AppointmentCalendarCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var pickerView: CollectionPickerView!
    @IBOutlet weak var txtTime: CoreDatePickerTextField!
    @IBOutlet weak var btnConfirm: CoreButton!
    
    //MARK:- Properites
    private var selectedIndex = -1
    private var dateArray = [DateModel]()
    var blockForSelectDate: ((_ date: Date?)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.collectionView.register(DateCell.nib, forCellWithReuseIdentifier: DateCell.identifier)
        pickerView.dataSource = self
        pickerView.delegate = self
        dateArray = getDays()
        //        pickerView.collectionView.reloadData()
        //        pickerView.reloadData()
    }
}

//MARK:- CollectionView Methods
extension AppointmentCalendarCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
        cell.lblMonth.text = dateArray[indexPath.item].strMonth
        cell.lblDate.text = dateArray[indexPath.item].strdate
        cell.lblDayName.text = dateArray[indexPath.item].strday
        cell.lblDate.textColor = selectedIndex == indexPath.item ? .malibu : .darkGray
        cell.lblDayName.textColor = selectedIndex == indexPath.item ? .malibu : .darkGray
        cell.lblMonth.textColor = selectedIndex == indexPath.item ? .malibu : .darkGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        blockForSelectDate?(dateArray[indexPath.item].date)
        pickerView.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.isIphone() ? 60 : 70, height: Constants.isIphone() ? 90 : 100)
    }
}

extension AppointmentCalendarCell {
    
    func getDays() -> [DateModel] {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 12
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        var date = Calendar.current.date(byAdding: .day, value: 0, to: currentDate)
        //        let fmt = DateFormatter()
        //        fmt.dateFormat = "dd"
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "MMM EEE"
        
        
        var tempAryy = [DateModel]()
        while date?.compare(futureDate ?? Date()) != .orderedDescending {
            //            var dayInWeek = dateFormatter.string(from: date!)
            //            dayInWeek.removeLast()
            //    print("\(fmt.string(from: date!)) \(dayInWeek)")
            let dateModel = DateModel()
            dateModel.date = date ?? Date()
            dateModel.strdate = date?.getString(inFormat: "dd")
            dateModel.strMonth = date?.getString(inFormat: "MMM")
            dateModel.strday = date?.getString(inFormat: "EEE")
            tempAryy.append(dateModel)
            date = Calendar.current.date(byAdding: .day, value: 1, to: date!)!
        }
        
        return tempAryy
    }
}
