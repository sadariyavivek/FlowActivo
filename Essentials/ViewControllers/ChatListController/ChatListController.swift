//
//  ChatListController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class ChatListController: CoreViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tblView: CoreTableView!
    
    //MARK:- Properties
    var chatListArray = [ChatList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(ChatListCell.nib, forCellReuseIdentifier: ChatListCell.identifier)
        tblView.separatorStyle = .singleLine
        chatListApi(isLoader: true)
        handleClicks()
    }
    
    private func handleClicks() {
        tblView.didPullToRefresh = { control in
            self.chatListApi(isLoader: false) {
                control.endRefreshing()
            }
        }
    }
}

//MARK:- Tableview Methods
extension ChatListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as! ChatListCell
        cell.chatList = chatListArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatController.instantiateFromStoryboard()
        vc.toID = chatListArray[indexPath.row].user_id ?? 0
        self.navigationController?.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatListController {
    
    private func chatListApi(isLoader: Bool, completion: voidCompletion? = nil) {
        APIClient.getChatList(userID: UserDefaults.standard.user?.user_id ?? 0, pageLimit: PageLimit(page: 1, limit: 1000), doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.chatListArray = response.getChatList() ?? []
                self.tblView.reloadData()
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
