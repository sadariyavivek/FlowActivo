//
//  CoreLabel.swift
//  Essentials
//
//  Created by Ravi on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreLabel: UILabel {
    
    //MARK: - Inspectable Properties
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
            text = localizableKey.localized
        }
    }
    @IBInspectable var topInset: CGFloat = 2
    @IBInspectable var bottomInset: CGFloat = 2
    @IBInspectable var leftInset: CGFloat = 2
    @IBInspectable var rightInset: CGFloat = 2
    
    //MARK: - Methods
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
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
            font = selectedFont.getFont(withSize: Constants.isIphone() ? fontSize : fontSize + 3)
        }
        
    }    
}

class AppLabel: CoreLabel{
    
    @IBInspectable var type: Int = 0 {
        didSet {
            setupAppearance()
        }
    }
    
    @IBInspectable var selectionColor: UIColor = .gray {
        didSet {
            setupAppearance()
        }
    }
    
    @IBInspectable var unSelectionColor: UIColor = .gray {
        didSet {
            setupAppearance()
        }
    }
        
    //MARK - Other Methods
    override func commonInit() {
        super.commonInit()
        setupAppearance()
    }
    
    private func setupAppearance() {
        switch type {
            //unSelected Lable
        case 0:
            self.textColor = unSelectionColor
            break
            //Selected Lable
        case 1:
            self.textColor = .white
            break
        case 2:
            self.textColor = selectionColor
            break
        //Selected Lable
        case 3:
            self.textColor = unSelectionColor
            break
        default:
            break
        }
    }
}
