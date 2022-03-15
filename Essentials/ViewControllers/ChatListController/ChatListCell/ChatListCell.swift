//
//  ChatListCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class ChatListCell: CoreTableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var lblMsg: CoreLabel!
    @IBOutlet weak var lblname: CoreLabel!
    @IBOutlet weak var lblTime: CoreLabel!
    @IBOutlet weak var onlineView: UIView!
    
    var chatList: ChatList? {
        didSet {
            let urlString = chatList?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            imgprofile.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeHolderImage)
            lblMsg.text = chatList?.last_msg
            lblname.text = "\(chatList?.firstname ?? "") \(chatList?.lastname ?? "")"
            lblTime.text = chatList?.display_time
            onlineView.isHidden = chatList?.read_status == 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewWidth.constant = Constants.isIphone() ? 45 : 60
        imgViewHeight.constant = imgViewWidth.constant
        imgprofile.cornerRadius = Double(imgViewWidth.constant / 2)
    }
}
