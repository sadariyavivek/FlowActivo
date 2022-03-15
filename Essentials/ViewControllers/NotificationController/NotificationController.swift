//
//  NotificationController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 10/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class NotificationController: CoreViewController {
    
    @IBOutlet weak var tblview: CoreTableView!
    
    var notificationArray = [NotificationModal]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblview.register(NotificationCell.nib, forCellReuseIdentifier: NotificationCell.identifier)
        tblview.rowHeight = UITableView.automaticDimension
        notificationAPI(isLoader: true)
        handleClicks()
    }
    
    private func handleClicks(){
        tblview.didPullToRefresh = { control in
            self.notificationAPI(isLoader: false) {
                control.endRefreshing()
            }
        }
    }
}

//MARK:- TableView Methods
extension NotificationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        cell.notifi = notificationArray[indexPath.row]
        return cell
    }
}

extension NotificationController {
    
    private func notificationAPI(isLoader: Bool, completion: voidCompletion? = nil) {
        APIClient.getNotificatioin(pageLimit: PageLimit(page: 1, limit: 1000), doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.notificationArray = response.getNotification() ?? []
                self.tblview.reloadData()
                completion?()
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
