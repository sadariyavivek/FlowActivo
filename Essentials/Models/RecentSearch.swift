//
//  RecentSearch.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 31/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct RecentSearch : Codable {
    let recentsearch_id : Int?
    let text : String?

    enum CodingKeys: String, CodingKey {
        case recentsearch_id = "recentsearch_id"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recentsearch_id = try? values.decodeIfPresent(Int.self, forKey: .recentsearch_id)
        text = try? values.decodeIfPresent(String.self, forKey: .text)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(RecentSearch.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [RecentSearch] {
        var models = [RecentSearch]()
        for item in array {
            models.append(RecentSearch(json: item)!)
        }
        return models
    }
}
