//
//  CoreTextField.swift
//  Essentials
//
//  Created by Ravi on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CoreTextField: UITextField, UITextFieldDelegate {
    
    //MARK: - Properties
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
    @IBInspectable var localizePlaceholderKey: String = "" {
        didSet {
            placeholder = localizePlaceholderKey.localized
        }
    }
    @IBInspectable var localizeTextKey: String = "" {
        didSet {
            
        }
    }
    @IBInspectable var leftImage: UIImage? = nil {
        didSet {
            setupLeftImage()
        }
    }
    @IBInspectable var placehoderColor: UIColor = .white {
        didSet {
            changePlaceholderTextColor()
        }
    }
    @IBInspectable var rightImage: UIImage? = nil {
        didSet {
            setupRightImage()
        }
    }
    @IBInspectable var leftRightImageWidth: CGFloat = 21 {
        didSet {
            rightView?.frame = CGRect(x: 0, y: 0, width: leftRightImageWidth, height: frame.size.height)
            leftView?.frame = CGRect(x: 0, y: 0, width: leftRightImageWidth+13+6, height: frame.size.height)
        }
    }
    
    @IBInspectable var skyFloating: Bool = true {
        didSet {
            commonInit()
        }
    }
    
    @IBInspectable var doneButtonTitle: String = "Done"
    @IBInspectable var doShowBorder: Bool = false {
        didSet {
            setupBorder()
        }
    }
    static let defaultRightPadding: CGFloat = 4
    static let defaultLeftPadding: CGFloat = 2
    var padding = UIEdgeInsets(top: 0, left: CoreTextField.defaultLeftPadding, bottom: 0, right: CoreTextField.defaultRightPadding)
    /*override var placeholder: String? {
     didSet {
     if let _ = placeholder {
     let placeHoderFont = AppFont(rawValue: fontFamily)?.getFont(withSize: fontSize) ?? AppFont.groteskRegular.getFont(withSize: fontSize)
     attributedPlaceholder = NSAttributedString(string: newPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.textColor2, NSAttributedString.Key.font: placeHoderFont])
     }
     }
     }*/
    var blockForShouldReturn: (()->Bool)?
    var blockForShouldBeginEditing: (()->Bool)?
    var blockForShouldChangeCharacters: ((_ range: NSRange, _ replacementString: String)->Bool)?
    var blockForTextChange: ((_ newText: String)->Void)? {
        didSet {
            if blockForTextChange != nil {
                addTarget(self, action: #selector(textFieldEditingChange(_:)), for: .editingChanged)
            }
        }
    }
    //    private var toolBar: CoreToolbar!
    
    //MARK: - Setup Methods
    func commonInit() {
        setupBorder()
        changePlaceholderTextColor()
        delegate = self
        enablesReturnKeyAutomatically = true
    }
    private func setFont () {
        if let selectedFont = AppFont(rawValue: fontFamily) {
            font = selectedFont.getFont(withSize: Constants.isIphone() ? fontSize : fontSize + 3)
        }
    }
    
    private func changePlaceholderTextColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: placehoderColor])
    }
    
    private func setupLeftImage() {
        if let img = self.leftImage {
            leftView = getViewWithImageView(img: img)
            leftViewMode = .always
            updatePadding()
        } else {
            leftViewMode = .always
        }
    }
    
    private func setupRightImage() {
        if let img = self.rightImage {
            rightView = getViewWithImageView(img: img)
            rightViewMode = .always
            updatePadding()
        } else {
            rightViewMode = .never
        }
    }
    
    private func getViewWithImageView(img: UIImage) -> UIView {
        let rightVw = UIView(frame: CGRect(x: 0, y: 0, width: leftRightImageWidth, height: frame.size.height))
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        rightVw.addSubview(imgView)
        rightVw.addConstraintsWithFormat("H:|-6-[v0]-1-|", views: imgView)
        rightVw.addConstraintsWithFormat("V:|-6-[v0]-6-|", views: imgView)
        return rightVw
    }
    
    private func updatePadding() {
        if let rightVw = rightView {
            padding.right = rightVw.frame.size.width
        } else {
            padding.right = CoreTextField.defaultRightPadding
        }
        
        if let rightVw = leftView {
            padding.left = rightVw.frame.size.width
        } else {
            padding.left = CoreTextField.defaultLeftPadding
        }
    }
    
    private func setupBorder() {
        layer.borderWidth = doShowBorder ? 1 : 0
    }
    
    @objc func textFieldEditingChange(_ sender: UITextField) {
        blockForTextChange?(sender.text!)
    }
    
    func bind(callback :@escaping (String) -> ()) {
        self.blockForTextChange = callback
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let returnBlock = blockForShouldBeginEditing {
            return returnBlock()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let returnBlock = blockForShouldReturn {
            return returnBlock()
        }
        self.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return blockForShouldChangeCharacters?((range), string) ?? true
    }
    
    //MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
}


class AppTextField: SkyFloatingLabelTextField, UITextFieldDelegate {
    
    //MARK: - Properties
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
    
    @IBInspectable var placehoderColor: UIColor = .white {
        didSet {
            changePlaceholderTextColor()
        }
    }
    @IBInspectable var leftImage: UIImage? = nil {
        didSet {
            setupLeftImage()
        }
    }
    @IBInspectable var rightImage: UIImage? = nil {
        didSet {
            setupRightImage()
        }
    }
    @IBInspectable var leftRightImageWidth: CGFloat = 21 {
        didSet {
            rightView?.frame = CGRect(x: 0, y: 0, width: leftRightImageWidth, height: frame.size.height)
            leftView?.frame = CGRect(x: 0, y: 0, width: leftRightImageWidth+13+6, height: frame.size.height)
        }
    }
    
    @IBInspectable var doneButtonTitle: String = "Done"
    @IBInspectable var doShowBorder: Bool = false {
        didSet {
            setupBorder()
        }
    }
    static let defaultRightPadding: CGFloat = 4
    static let defaultLeftPadding: CGFloat = 2
    var padding = UIEdgeInsets(top: 0, left: AppTextField.defaultLeftPadding, bottom: 0, right: AppTextField.defaultRightPadding)
    
    var blockForShouldReturn: (()->Bool)?
    var blockForShouldBeginEditing: (()->Bool)?
    var blockForShouldChangeCharacters: ((_ range: NSRange, _ replacementString: String)->Bool)?
    var blockForTextChange: ((_ newText: String)->Void)? {
        didSet {
            if blockForTextChange != nil {
                addTarget(self, action: #selector(textFieldEditingChange(_:)), for: .editingChanged)
            }
        }
    }
    //    private var toolBar: CoreToolbar!
    
    //MARK: - Setup Methods
    func commonInit() {
        setupBorder()
        changePlaceholderTextColor()
        delegate = self
        enablesReturnKeyAutomatically = true
        selectedLineColor = .malibu
        lineColor =  .clear
    }
    private func setFont () {
        if let selectedFont = AppFont(rawValue: fontFamily) {
            font = selectedFont.getFont(withSize: Constants.isIphone() ? fontSize : fontSize + 3)
            titleFont = selectedFont.getFont(withSize: Constants.isIphone() ? (fontSize - 2) : (fontSize + 3 - 2))
        }
    }
    
    private func changePlaceholderTextColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: placehoderColor])
    }
    
    private func setupLeftImage() {
        if let img = self.leftImage {
            leftView = getViewWithImageView(img: img)
            leftViewMode = .always
            updatePadding()
        } else {
            leftViewMode = .always
        }
    }
    
    private func setupRightImage() {
        if let img = self.rightImage {
            rightView = getViewWithImageView(img: img)
            rightViewMode = .always
            updatePadding()
        } else {
            rightViewMode = .never
        }
    }
    
    private func getViewWithImageView(img: UIImage) -> UIView {
        let rightVw = UIView(frame: CGRect(x: 0, y: 0, width: leftRightImageWidth, height: frame.size.height))
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        rightVw.addSubview(imgView)
        rightVw.addConstraintsWithFormat("H:|-6-[v0]-1-|", views: imgView)
        rightVw.addConstraintsWithFormat("V:|-6-[v0]-6-|", views: imgView)
        return rightVw
    }
    
    private func updatePadding() {
        if let rightVw = rightView {
            padding.right = rightVw.frame.size.width
        } else {
            padding.right = AppTextField.defaultRightPadding
        }
        
        if let rightVw = leftView {
            padding.left = rightVw.frame.size.width
        } else {
            padding.left = AppTextField.defaultLeftPadding
        }
    }
    
    private func setupBorder() {
        layer.borderWidth = doShowBorder ? 1 : 0
    }
    
    @objc func textFieldEditingChange(_ sender: UITextField) {
        blockForTextChange?(sender.text!)
    }
    
    func bind(callback :@escaping (String) -> ()) {
        self.blockForTextChange = callback
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let returnBlock = blockForShouldBeginEditing {
            return returnBlock()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let returnBlock = blockForShouldReturn {
            return returnBlock()
        }
        self.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return blockForShouldChangeCharacters?((range), string) ?? true
    }
    
    //MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
}
