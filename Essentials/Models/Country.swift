//
//  Country.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 25/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct Country : Codable {
    let id : Int?
    let name : String?
    let sortname : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case sortname = "sortname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(Int.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        sortname = try? values.decodeIfPresent(String.self, forKey: .sortname)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(Country.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [Country] {
        var models = [Country]()
        for item in array {
            models.append(Country(json: item)!)
        }
        return models
    }
}
