//
//  UserDefault+Extension.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

fileprivate let keyUser = "key_user"
fileprivate let keyemail = "key_email"
fileprivate let keypassword = "key_password"
fileprivate let keyisRemember = "key_isRememberLogin"
fileprivate let keyIntro = "key_intro"
fileprivate let keyroleID = "key_roleID"
fileprivate let keyshareLink = "key_shareLink"

extension UserDefaults {
    
    var isIntroVC: Bool {
        get {
            return bool(forKey: keyIntro)
        }
        set {
            set(newValue, forKey: keyIntro)
        }
    }
    
    var isRememberLogin: Bool {
        get {
            return bool(forKey: keyisRemember)
        }
        set {
            set(newValue, forKey: keyisRemember)
        }
    }
    
    var role_id: Int? {
        get {
            if let key = object(forKey: keyroleID) as? Int {
                return key
            }
            return nil
        }
        set {
            set(newValue, forKey: keyroleID)
        }
    }
    
    var email: String? {
        get {
            if let key = object(forKey: keyemail) as? String {
                return key
            }
            return nil
        }
        set {
            set(newValue, forKey: keyemail)
        }
    }
    
    var shareLink: String? {
        get {
            if let key = object(forKey: keyshareLink) as? String {
                return key
            }
            return nil
        }
        set {
            set(newValue, forKey: keyshareLink)
        }
    }
    
    var password: String? {
        get {
            if let key = object(forKey: keypassword) as? String {
                return key
            }
            return nil
        }
        set {
            set(newValue, forKey: keypassword)
        }
    }
    
    var user: UserData? {
        get {
            if let savedUser = object(forKey: keyUser) as? Data {
                if let loadedUser = try? JSONDecoder().decode(UserData.self, from: savedUser) {
                    return loadedUser
                }
            }
            return nil
        }
        set {
            if let newUser = newValue, let encoded = try? JSONEncoder().encode(newUser) {
                set(encoded, forKey: keyUser)
            } else {
                set(nil, forKey: keyUser)
            }
        }
    }
        
    func clearAllDefaults() {
        self.user = nil
    }    
}
