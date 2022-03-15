//
//  SocialMediaController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 21/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class SocialMediaController: CoreViewController {

    @IBOutlet weak var tblView: CoreTableView!
    //MARK:- Properites
    private var socialArray : [EnumSocialMedia] = [.twitter, .tumbler, .instagram, .google, .fb]
    private var selectedIndex = -1
    private var socialMediaArray = [SocialMedia]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(SocialMediaCell.nib, forCellReuseIdentifier: SocialMediaCell.identifier)
        socialMediaAPI()
    }
}

//MARK:- TableView Methods
extension SocialMediaController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMediaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SocialMediaCell.identifier, for: indexPath) as! SocialMediaCell
//        cell.imgView.image = UIImage(named: socialArray[indexPath.row].rawValue)
        let urlString = socialMediaArray[indexPath.row].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        cell.imgView.sd_setImage(with: URL(string: urlString ?? ""))
        cell.backgroundColor = selectedIndex == indexPath.row ? .black : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        UIView.performWithoutAnimation {
            self.tblView.reloadData()
        }
        let vc = ForgotChangePasswordController.instantiateFromStoryboard()
        vc.forgotChangePass = .socialMedia
        vc.urlstr = socialMediaArray[indexPath.row].link ?? ""
        self.navigationController?.show(vc, sender: nil)
    }
}

extension SocialMediaController {
    
    private func socialMediaAPI() {
        APIClient.socialMedia(pageLimit: PageLimit(page: 1, limit: PAGINATION_LIMIT), doShowLoading: true) { (result) in
            switch result {
            case .success(var response):
                self.socialMediaArray = response.getSocialMedia() ?? []
                self.tblView.reloadData()
                break
            case .failure(let error):
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
}
