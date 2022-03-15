//
//  SenderCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class SenderCell: CoreTableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var receiveView: UIView!
    @IBOutlet weak var lblReTime: CoreLabel!
    @IBOutlet weak var lblReMsg: CoreLabel!
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var lblSeMsg: CoreLabel!
    @IBOutlet weak var lblSeTime: CoreLabel!
        
    var chatMSG: ChatMessageList? {
        didSet {
            let currentUserID = UserDefaults.standard.user?.user_id
            if chatMSG?.send_user_id == currentUserID {
                senderView.isHidden = false
                receiveView.isHidden = !senderView.isHidden
                lblSeTime.text = chatMSG?.display_time
                lblSeMsg.text = chatMSG?.message
            } else {
                lblReTime.text = chatMSG?.display_time
                lblReMsg.text = chatMSG?.message
                senderView.isHidden = true
                receiveView.isHidden = !senderView.isHidden
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
