//
//  CorePickerTextField.swift
//  Essentials
//
//  Created by Ravi on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//


import UIKit

class CoreToolbar: UIToolbar {

    //MARK: - Controls
    private lazy var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(didTapDoneBarButton(sender:)))
        barButton.tintColor = .black
        return barButton
    }()
    
    private lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelBarButton(sender:)))
        barButton.tintColor = .black
        return barButton
    }()
    
    //MARK: - Properties
    var blockForCancelButtonTap: voidCompletion?
    var blockForDoneButtonTap: voidCompletion?
    
    static func getToolbar(doneTitle: String = "Done", cancelTitle: String = "Cancel", doShowCancelBarButton: Bool = true, doneCompletion: voidCompletion?, cancelCompletion: voidCompletion?) -> CoreToolbar {
        let toolbar = CoreToolbar()
        toolbar.barTintColor = .white
        toolbar.blockForCancelButtonTap = cancelCompletion
        toolbar.blockForDoneButtonTap = doneCompletion
        toolbar.doneBarButton.title = doneTitle
        toolbar.cancelBarButton.title = cancelTitle
        var barButtons = [UIBarButtonItem]()
        if doShowCancelBarButton {
            barButtons.append(toolbar.cancelBarButton)
        }
        barButtons.append(contentsOf: [UIBarButtonItem.flexibleBarButton, toolbar.doneBarButton])
        toolbar.setItems(barButtons, animated: false)
        toolbar.sizeToFit()
        return toolbar
    }
    
    //MARK: - Handle Events
    @objc private func didTapDoneBarButton(sender: UIBarButtonItem) {
        blockForDoneButtonTap?()
    }
    
    @objc private func didTapCancelBarButton(sender: UIBarButtonItem) {
        blockForCancelButtonTap?()
    }
    
}
