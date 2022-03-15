//
//  CoreButton.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreButton: UIButton {
    
    @IBInspectable var fontFamily: Int = 0 {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 18 {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var localizableKey: String = "" {
        didSet {
            setTitle(localizableKey.localized, for: .normal)
        }
    }
    
    var handleTap: (()->Void)? = nil {
        didSet {
            if let _ = handleTap {
                addTarget(self, action: #selector(didTapSelf(_:)), for: .touchUpInside)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    func commonInit() {
        setFont()
    }
    
    private func setFont() {
        if let selectedFont = AppFont(rawValue: fontFamily) {
            titleLabel?.font = selectedFont.getFont(withSize: Constants.isIphone() ? fontSize : fontSize + 3)
        }
    }
    
    @objc private func didTapSelf(_ sender: CoreButton) {
        handleTap?()
    }
}
