//
//  CoreSearchBar.swift
//  Essentials
//
//  Created by Ravi on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class CoreSearchBar: UISearchBar {
    
    var shouldBeginEditing: Bool = true
    var shouldBeginEditingBlock: (() -> (Bool))?
    var blockForTextChange: ((String)->())?
    var blockForSearchTapped: voidCompletion?
    var blockForCancleTapped: voidCompletion?
    
    func commonInit(){
        let textField = getTextField()
        textField?.font = AppFont.dejaVuSansBold.getFont(withSize: Constants.isIphone() ? 9 : 9 + 3)
        setClearButton(color: .white)
        self.showsBookmarkButton = true
        delegate = self
        self.placeholder = "CITY, STATE OR ZIP CODE".localized
        self.setPlaceholder(textColor: .white)
        self.compatibleSearchTextField.textColor = .white
        self.compatibleSearchTextField.backgroundColor = .black        
        setupAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func setupAppearance() {
        setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        setImage("ic_search".imageWithOriginalMode.resize(value: 25), for: .bookmark, state: .normal)
        setPositionAdjustment(UIOffset(horizontal: -5, vertical: 0), for: UISearchBar.Icon.bookmark)
        setPositionAdjustment(UIOffset(horizontal: -5, vertical: 0), for: UISearchBar.Icon.clear)
    }
}

extension CoreSearchBar: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return shouldBeginEditingBlock?() ?? true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        blockForTextChange?(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        blockForSearchTapped?()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        blockForCancleTapped?()
    }
}

extension UISearchBar {
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func set(textColor: UIColor) { if let textField = getTextField() { textField.textColor = textColor } }
    func setPlaceholder(textColor: UIColor) { getTextField()?.setPlaceholder(textColor: textColor) }
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }

    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }

    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

private extension UITextField {

    private class Label: UILabel {
        private var _textColor = UIColor.lightGray
        override var textColor: UIColor! {
            set { super.textColor = _textColor }
            get { return _textColor }
        }

        init(label: UILabel, textColor: UIColor = .lightGray) {
            _textColor = textColor
            super.init(frame: label.frame)
            self.text = label.text
            self.font = label.font
        }

        required init?(coder: NSCoder) { super.init(coder: coder) }
    }


    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }

    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    var placeholderLabel: UILabel? { return value(forKey: "placeholderLabel") as? UILabel }

    func setPlaceholder(textColor: UIColor) {
        guard let placeholderLabel = placeholderLabel else { return }
        let label = Label(label: placeholderLabel, textColor: textColor)
        setValue(label, forKey: "placeholderLabel")
    }

    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}
