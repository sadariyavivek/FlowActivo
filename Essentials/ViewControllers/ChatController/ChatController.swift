//
//  ChatController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatController: CoreViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tblView: CoreTableView!
    @IBOutlet weak var btnSend: CoreButton!
    @IBOutlet weak var txtMsg: CoreTextView!
    @IBOutlet weak var txtTextMsg: CoreTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var msgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    //MARK:- Properties
    var msgArray = [ChatMessageList]()
    var toID = 0
    var message: String? = nil
    private var sendMsgView : ChatMSGView = ChatMSGView().fromNib()
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    override var inputAccessoryView: UIView? {
        return sendMsgView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(SenderCell.nib, forCellReuseIdentifier: SenderCell.identifier)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        showData()
        handleClicks()
        getChatHistory(isLoader: true)
    }
    
    private func showData() {
        let urlString = UserDefaults.standard.user?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        imgProfile.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
        sendMsgView.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
        imgWidth.constant = Constants.isIphone() ? 45 : 50
        imgHeight.constant = imgWidth.constant
        imgProfile.cornerRadius = Double(imgHeight.constant / 2)
        sendMsgView.imgWidth.constant = Constants.isIphone() ? 45 : 50
        sendMsgView.imgHeight.constant = sendMsgView.imgWidth.constant
        sendMsgView.imgView.cornerRadius = Double(sendMsgView.imgHeight.constant / 2)
    }
    
    //VALIDATION
    private func isValid() -> Bool {
        if message == nil || message == "" {
            self.showMyAlert(desc: "please enter message", cancelTitle: "OK", cancelHandler: {
                self.dismiss(animated: true, completion: nil)
            }, vc: self)
            return false
        }
        return true
    }
    
    //MARK:- Handle Clicks
    private func handleClicks() {
        sendMsgView.txtMsg.blockForTextChange = { txt in
            self.message = txt
            self.txtTextMsg.text = self.message
        }
        sendMsgView.txtMsg.blockForShouldBeginEditing = {
            self.msgView.isHidden = true
            return true
        }
        sendMsgView.txtMsg.blockForShouldReturn = {
            if self.isValid() {
                self.sendMessage()
            }
            return true
        }
        txtTextMsg.blockForTextChange = { txt in
            self.message = txt
            self.sendMsgView.txtMsg.text = self.message
        }
        txtTextMsg.blockForShouldBeginEditing = {
            self.sendMsgView.txtMsg.becomeFirstResponder()
            self.msgView.isHidden = true
            return true
        }
        txtTextMsg.blockForShouldReturn = {
            if self.isValid() {
                self.sendMessage()
            }
            return true
        }
        btnSend.handleTap = {
            if self.isValid() {
                self.sendMessage()
            }
        }
        sendMsgView.btnSend.handleTap = {
            if self.isValid() {
                self.sendMessage()
            }
        }
    }
    // MSG Send
    private func sendMessage() {
        var chatMSg = ChatMessageList(json: [:])!
        chatMSg.message = self.message
        chatMSg.send_user_id = UserDefaults.standard.user?.user_id
        chatMSg.display_time = Date().getString(inFormat: "h:mm a")
        self.msgArray.append(chatMSg)
        self.gotoLastRow()
        txtTextMsg.text = ""
        sendMsgView.txtMsg.text = ""
        self.sendMessageAPI() {
            self.message = nil
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        _ = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right:  0)
            msgViewHeight.constant = 80
            msgView.isHidden = false
            let lastSection = tblView.numberOfSections - 1
            let lastRow = tblView.numberOfRows(inSection: lastSection) - 1
            let lastIndexpath = IndexPath(row: lastRow, section: lastSection)
            tblView.scrollToRow(at: lastIndexpath, at: .bottom, animated: false)
        } else {
            tblView.contentInset = .zero
            msgViewHeight.constant = 0
        }
//        sendMsgView.txtMsgView.scrollIndicatorInsets = sendMsgView.txtMsgView.contentInset
//        let selectedRange = sendMsgView.txtMsgView.selectedRange
//        sendMsgView.txtMsgView.scrollRangeToVisible(selectedRange)
    }
}

//MARK:- Tableview Methods
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SenderCell.identifier, for: indexPath) as! SenderCell
        cell.chatMSG = msgArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func gotoLastRow() {
        IQKeyboardManager.shared.enable = msgArray.count > 4 ? true : false
        tblView.reloadData()
        let lastSection = tblView.numberOfSections - 1
        let lastRow = tblView.numberOfRows(inSection: lastSection) - 1
        let lastIndexpath = IndexPath(row: lastRow, section: lastSection)
        tblView.scrollToRow(at: lastIndexpath, at: .bottom, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.isKind(of: ChatController.self) && !self.isKind(of: UIView.self) {
            self.view.endEditing(true)
            self.msgView.isHidden = false
        }
    }
}

extension ChatController {
    
    private func getChatHistory(isLoader: Bool) {
        APIClient.getChatHistory(fromID: UserDefaults.standard.user?.user_id ?? 0, toID: toID, pageLimit: PageLimit(page: 1, limit: 1000), doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.msgArray = response.getChatHistory() ?? []
                self.gotoLastRow()
                break
            case .failure(let error):
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
    
    private func sendMessageAPI(complition: voidCompletion? = nil) {
        APIClient.sendMsg(fromID: UserDefaults.standard.user?.user_id ?? 0, toID: toID, msg: message ?? "", doShowLoading: false) { (result) in
            switch result {
            case .success(let response):
                complition?()
                break
            case .failure(let error):
                break
            }
        }
    }
}
