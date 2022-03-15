//
//  ChatList.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 08/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct ChatList : Codable {
    let c_id : Int?
    let user_id : Int?
    let image : String?
    let firstname : String?
    let lastname : String?
    let last_msg : String?
    let display_time : String?
    let time : String?
    let read_status : Int?

    enum CodingKeys: String, CodingKey {
        case c_id = "c_id"
        case user_id = "user_id"
        case image = "image"
        case firstname = "firstname"
        case lastname = "lastname"
        case last_msg = "last_msg"
        case display_time = "display_time"
        case time = "time"
        case read_status = "read_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        c_id = try? values.decodeIfPresent(Int.self, forKey: .c_id)
        user_id = try? values.decodeIfPresent(Int.self, forKey: .user_id)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        firstname = try? values.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try? values.decodeIfPresent(String.self, forKey: .lastname)
        last_msg = try? values.decodeIfPresent(String.self, forKey: .last_msg)
        display_time = try? values.decodeIfPresent(String.self, forKey: .display_time)
        time = try? values.decodeIfPresent(String.self, forKey: .time)
        read_status = try? values.decodeIfPresent(Int.self, forKey: .read_status)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(ChatList.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [ChatList] {
        var models = [ChatList]()
        for item in array {
            models.append(ChatList(json: item)!)
        }
        return models
    }
}


struct ChatMessageList : Codable {
    let m_id : Int?
    var message : String?
    var send_user_id : Int?
    var display_date : String?
    let date : String?
    var display_time : String?
    let time : String?

    enum CodingKeys: String, CodingKey {
        case m_id = "m_id"
        case message = "message"
        case send_user_id = "send_user_id"
        case display_date = "display_date"
        case date = "date"
        case display_time = "display_time"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        m_id = try? values.decodeIfPresent(Int.self, forKey: .m_id)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        send_user_id = try? values.decodeIfPresent(Int.self, forKey: .send_user_id)
        display_date = try? values.decodeIfPresent(String.self, forKey: .display_date)
        date = try? values.decodeIfPresent(String.self, forKey: .date)
        display_time = try? values.decodeIfPresent(String.self, forKey: .display_time)
        time = try? values.decodeIfPresent(String.self, forKey: .time)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(ChatMessageList.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [ChatMessageList] {
        var models = [ChatMessageList]()
        for item in array {
            models.append(ChatMessageList(json: item)!)
        }
        return models
    }
}

