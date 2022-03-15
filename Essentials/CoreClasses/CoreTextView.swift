//
//  CoreTextView.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreTextView: UITextView {

    //MARK: - Controls
    private lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        return lbl
    }()
    @IBInspectable var fontFamily: Int = 0 {
        didSet {
            setFont()
        }
    }
    @IBInspectable var fontSize: CGFloat = 15 {
        didSet {
            setFont()
        }
    }
    @IBInspectable var maxCharacter: Int = 1000 {
        didSet {
            maxCharacterCount = maxCharacter
        }
    }
    @IBInspectable var type: Int = 0 {
        didSet {
            setUI()
        }
    }
    private var toolBar: CoreToolbar!
    
    //MARK: - Properties
    private var maxCharacterCount = 100
    private var topInset: CGFloat = 0
    private var leftInset: CGFloat = 0
    @IBInspectable var doneButtonTitle: String = "Done"
    @IBInspectable var placeHolderText: String = "" {
        didSet {
            placeHolderLabel.text = placeHolderText
        }
    }
    var blockForTextChange: ((_ text: String)->Void)?
    var blockForEndEditing: ((_ text: String)->Void)?
    var blockForBeginEditing: voidCompletion?
    var blockForTextChangeWithRange: ((_ text: String)->Void)?
    
    //MARK: - Setup UI Methods
    private func commonInit() {
        setupPlaceHolderLabel()
        setFont()
        setUI()
        delegate = self
    }
    
    private func setFont () {
        if let selectedFont = AppFont(rawValue: fontFamily) {
            font = selectedFont.getFont(withSize: Constants.isIphone() ? fontSize : fontSize + 3)
        }
    }
    
    private func setUI () {
        DispatchQueue.main.async(execute: {
            if self.type == 0 {
                self.layer.cornerRadius = 10
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.gray.cgColor
                self.layer.masksToBounds = true
            } else if self.type == 1 {
                self.layer.borderWidth = 1
                self.layer.masksToBounds = true
            }
        })
    }
    
    private func setupPlaceHolderLabel() {
        if !subviews.contains(placeHolderLabel) {
            addSubview(placeHolderLabel)
            addConstraintsWithFormat("H:|-\(topInset)-[v0]-14-|", views: placeHolderLabel)
            addConstraintsWithFormat("V:|-\(leftInset)-[v0]", views: placeHolderLabel)
        }
    }
    
    func bind(callback :@escaping (String) -> ()) {
        self.blockForTextChange = callback
    }
    
    //MARK: - Init Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension CoreTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        blockForBeginEditing?()
    }
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.text.count > 0
        blockForTextChange?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if blockForTextChangeWithRange != nil {
            if textView.text.count + (text.count - range.length) <= maxCharacterCount {
                return true
            }
            return false
        }
        return true
    }
    
    func setDoneButtonForTextView() {
        let toolBar = CoreToolbar.getToolbar(doneTitle: "Done".localized, doShowCancelBarButton: false, doneCompletion: {
            self.resignFirstResponder()
        }, cancelCompletion: nil)
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar
    }
}


class DisabledTextView: UITextView {
    override func becomeFirstResponder() -> Bool {
        return false
    }
}
