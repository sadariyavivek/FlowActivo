//
//  Slider.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 24/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct Slider : Codable {
    let introductionslider_id : String?
    let homeslider_id : Int?
    let image : String?
    let description : String?

    enum CodingKeys: String, CodingKey {
        case introductionslider_id = "introductionslider_id"
        case homeslider_id = "homeslider_id"
        case image = "image"
        case description = "description"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        introductionslider_id = try? values.decodeIfPresent(String.self, forKey: .introductionslider_id)
        homeslider_id = try? values.decodeIfPresent(Int.self, forKey: .homeslider_id)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        description = try? values.decodeIfPresent(String.self, forKey: .description)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(Slider.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [Slider] {
        var models = [Slider]()
        for item in array {
            models.append(Slider(json: item)!)
        }
        return models
    }
}
