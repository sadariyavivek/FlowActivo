//
//  SocialMedia.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 05/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct SocialMedia : Codable {
    let socialmedia_id : Int?
    let image : String?
    let link : String?

    enum CodingKeys: String, CodingKey {
        case socialmedia_id = "socialmedia_id"
        case image = "image"
        case link = "link"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        socialmedia_id = try? values.decodeIfPresent(Int.self, forKey: .socialmedia_id)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        link = try? values.decodeIfPresent(String.self, forKey: .link)
    }
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(SocialMedia.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [SocialMedia] {
        var models = [SocialMedia]()
        for item in array {
            models.append(SocialMedia(json: item)!)
        }
        return models
    }
}

