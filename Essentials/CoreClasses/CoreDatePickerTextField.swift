//
//  CoreDatePickerTextField.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreDatePickerTextField: CoreTextField {
    
    //MARK: - Properties
    @IBInspectable var pickerType: Int = 0 {
        didSet {
            commonInit()
        }
    }
    
    @IBInspectable var dateFormat: String = "dd MMM yyyy hh:mm a" {
        didSet {
            commonInit()
        }
    }
    
    var datePickerMode: UIDatePicker.Mode = .dateAndTime {
        didSet {
            datePickerView.datePickerMode = datePickerMode
        }
    }
    
    var minimumDate: Date = Date() {
        didSet {
            datePickerView.minimumDate = minimumDate
        }
    }
    
    var maximumDate: Date = Date() {
        didSet {
            datePickerView.maximumDate = maximumDate
        }
    }
    
    var selectedDate: Date = Date() {
        didSet {
            datePickerView.date = selectedDate
        }
    }
    
    var timeMinimumDate: Date? = Date() {
        didSet {
            timePickerView.minimumDate = timeMinimumDate
        }
    }
    
    //MARK: - Controls
    private lazy var dateTimePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = datePickerMode
        datePickerView.minimumDate = minimumDate
        datePickerView.date = selectedDate
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        return datePickerView
    }()
    
    private lazy var timePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.minimumDate = timeMinimumDate
        datePickerView.date = selectedDate
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        return datePickerView
    }()
    
    private lazy var staticTimePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.date = selectedDate
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        return datePickerView
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.minimumDate = minimumDate
        datePickerView.date = selectedDate
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        return datePickerView
    }()
    
    private var toolBar: CoreToolbar!
    private var sender: UIDatePicker!
    
    //MARK: - Properties
    var blockForCancelButtonTap: voidCompletion?
    var blockForDoneButtonTap: ((_ selectedValue: String, _ selectedData: Date?)->Void)?
    
    
    //MARK: - Methods
    override func commonInit() {
        super.commonInit()
        toolBar = CoreToolbar.getToolbar(doneCompletion: {
            self.resignFirstResponder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = self.dateFormat
            self.blockForDoneButtonTap?(dateFormatter.string(from: self.sender == nil ? Date() : self.sender.date), self.sender == nil ? Date() : self.sender.date)
        }, cancelCompletion: {
            self.resignFirstResponder()
            self.blockForCancelButtonTap?()
        })
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
        setupAppearance()
        self.rightView?.isUserInteractionEnabled = false
    }
    
    private func setupAppearance() {
        switch pickerType {
        case 0:
            dateTimePickerView.locale = Locale(identifier: "en_US")
            dateTimePickerView.sizeToFit()
            inputView = dateTimePickerView
            break
        case 1:
            timePickerView.locale = Locale(identifier: "en_US")
            timePickerView.sizeToFit()
            inputView = timePickerView
            break
        case 2:
            datePickerView.locale = Locale(identifier: "en_US")
            datePickerView.sizeToFit()
            inputView = datePickerView
            break
        default:
            break
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") //appLanguage == Constants.EN ? "en_US" : "ar_DZ")
        dateFormatter.dateFormat = self.dateFormat
        self.sender = sender
//        blockForDoneButtonTap?(dateFormatter.string(from: sender.date), self.sender.date)
    }
}

