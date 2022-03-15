//
//  AppointmentHistory.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 06/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct AppointmentHistory : Codable {
    let history_id : Int?
    let provider_id : Int?
    let provider_name : String?
    let customer_id : Int?
    let customer_name : String?
    let healthcarecategory_id : Int?
    let healthcarecategory_name : String?
    let rateandreviews_id : Int?
    var rate : String?
    var review : String?
    let date : String?
    let day : String?
    let start_time : String?
    let end_time : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let comment : String?
    let rateandreviews_status : Bool?
    var appointment_status : Int?

    enum CodingKeys: String, CodingKey {
        case history_id = "history_id"
        case provider_id = "provider_id"
        case provider_name = "provider_name"
        case customer_id = "customer_id"
        case customer_name = "customer_name"
        case healthcarecategory_id = "healthcarecategory_id"
        case healthcarecategory_name = "healthcarecategory_name"
        case rateandreviews_id = "rateandreviews_id"
        case rate = "rate"
        case review = "review"
        case date = "date"
        case day = "day"
        case start_time = "start_time"
        case end_time = "end_time"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case comment = "comment"
        case rateandreviews_status = "rateandreviews_status"
        case appointment_status = "appointment_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        history_id = try? values.decodeIfPresent(Int.self, forKey: .history_id)
        provider_id = try? values.decodeIfPresent(Int.self, forKey: .provider_id)
        provider_name = try? values.decodeIfPresent(String.self, forKey: .provider_name)
        customer_id = try? values.decodeIfPresent(Int.self, forKey: .customer_id)
        customer_name = try? values.decodeIfPresent(String.self, forKey: .customer_name)
        healthcarecategory_id = try? values.decodeIfPresent(Int.self, forKey: .healthcarecategory_id)
        healthcarecategory_name = try? values.decodeIfPresent(String.self, forKey: .healthcarecategory_name)
        rateandreviews_id = try? values.decodeIfPresent(Int.self, forKey: .rateandreviews_id)
        rate = try? values.decodeIfPresent(String.self, forKey: .rate)
        review = try? values.decodeIfPresent(String.self, forKey: .review)
        date = try? values.decodeIfPresent(String.self, forKey: .date)
        day = try? values.decodeIfPresent(String.self, forKey: .day)
        start_time = try? values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try? values.decodeIfPresent(String.self, forKey: .end_time)
        address = try? values.decodeIfPresent(String.self, forKey: .address)
        latitude = try? values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try? values.decodeIfPresent(String.self, forKey: .longitude)
        comment = try? values.decodeIfPresent(String.self, forKey: .comment)
        rateandreviews_status = try? values.decodeIfPresent(Bool.self, forKey: .rateandreviews_status)
        appointment_status = try? values.decodeIfPresent(Int.self, forKey: .appointment_status)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(AppointmentHistory.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [AppointmentHistory] {
        var models = [AppointmentHistory]()
        for item in array {
            models.append(AppointmentHistory(json: item)!)
        }
        return models
    }

}

