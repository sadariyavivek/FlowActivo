//
//  NotificationModal.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 10/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct NotificationModal : Codable {
    let notifications_id : Int?
    let title : String?
    let message : String?
    let created_at : String?

    enum CodingKeys: String, CodingKey {
        case notifications_id = "notifications_id"
        case title = "title"
        case message = "message"
        case created_at = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notifications_id = try? values.decodeIfPresent(Int.self, forKey: .notifications_id)
        title = try? values.decodeIfPresent(String.self, forKey: .title)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
        created_at = try? values.decodeIfPresent(String.self, forKey: .created_at)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(NotificationModal.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [NotificationModal] {
        var models = [NotificationModal]()
        for item in array {
            models.append(NotificationModal(json: item)!)
        }
        return models
    }
}

