//
//  SideMenuCell2.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 16/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class SideMenuCell2: CoreTableViewCell {

    @IBOutlet weak var btnPostServices: CoreButton!
    @IBOutlet weak var btnPostView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPostView.isHidden = UserDefaults.standard.role_id == 1 || UserDefaults.standard.user == nil
    }
}
