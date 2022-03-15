//
//  Providers.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 25/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct Providers : Codable {
    let user_id : Int?
    let firstname : String?
    let lastname : String?
    let username : String?
    let businessname : String?
    let image : String?
    let email : String?
    let address : String?
    let county : String?
    let state : String?
    let city : String?
    let zipcode : String?
    let phone : String?
    let service_description : String?
    let healthcarecategory_id : Int?
    let healthcarecategory : String?
    let total_rateandreview : String?
    let rate_average : String?
    let distance : Double?

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case firstname = "firstname"
        case lastname = "lastname"
        case username = "username"
        case businessname = "businessname"
        case image = "image"
        case email = "email"
        case address = "address"
        case county = "county"
        case state = "state"
        case city = "city"
        case zipcode = "zipcode"
        case phone = "phone"
        case service_description = "service_description"
        case healthcarecategory_id = "healthcarecategory_id"
        case healthcarecategory = "healthcarecategory"
        case total_rateandreview = "total_rateandreview"
        case rate_average = "rate_average"
        case distance = "distance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try? values.decodeIfPresent(Int.self, forKey: .user_id)
        firstname = try? values.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try? values.decodeIfPresent(String.self, forKey: .lastname)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        businessname = try? values.decodeIfPresent(String.self, forKey: .businessname)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        address = try? values.decodeIfPresent(String.self, forKey: .address)
        county = try? values.decodeIfPresent(String.self, forKey: .county)
        state = try? values.decodeIfPresent(String.self, forKey: .state)
        city = try? values.decodeIfPresent(String.self, forKey: .city)
        zipcode = try? values.decodeIfPresent(String.self, forKey: .zipcode)
        phone = try? values.decodeIfPresent(String.self, forKey: .phone)
        service_description = try? values.decodeIfPresent(String.self, forKey: .service_description)
        healthcarecategory_id = try? values.decodeIfPresent(Int.self, forKey: .healthcarecategory_id)
        healthcarecategory = try? values.decodeIfPresent(String.self, forKey: .healthcarecategory)
        total_rateandreview = try? values.decodeIfPresent(String.self, forKey: .total_rateandreview)
        rate_average = try? values.decodeIfPresent(String.self, forKey: .rate_average)
        distance = try? values.decodeIfPresent(Double.self, forKey: .distance)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(Providers.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [Providers] {
        var models = [Providers]()
        for item in array {
            models.append(Providers(json: item)!)
        }
        return models
    }
}

struct HealthCareCategory : Codable {
    var healthcarecategory_id : Int?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case healthcarecategory_id = "healthcarecategory_id"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        healthcarecategory_id = try? values.decodeIfPresent(Int.self, forKey: .healthcarecategory_id)
        type = try? values.decodeIfPresent(String.self, forKey: .type)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(HealthCareCategory.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [HealthCareCategory] {
        var models = [HealthCareCategory]()
        for item in array {
            models.append(HealthCareCategory(json: item)!)
        }
        return models
    }
}

struct Rateandreviews_data : Codable {
    let rateandreviews_id : Int?
    let user_id : Int?
    let name : String?
    let provider_id : Int?
    let rate : String?
    let review : String?
    let date : String?

    enum CodingKeys: String, CodingKey {
        case rateandreviews_id = "rateandreviews_id"
        case user_id = "user_id"
        case name = "name"
        case provider_id = "provider_id"
        case rate = "rate"
        case review = "review"
        case date = "date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rateandreviews_id = try? values.decodeIfPresent(Int.self, forKey: .rateandreviews_id)
        user_id = try? values.decodeIfPresent(Int.self, forKey: .user_id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        provider_id = try? values.decodeIfPresent(Int.self, forKey: .provider_id)
        rate = try? values.decodeIfPresent(String.self, forKey: .rate)
        review = try? values.decodeIfPresent(String.self, forKey: .review)
        date = try? values.decodeIfPresent(String.self, forKey: .date)
    }
    
    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(Rateandreviews_data.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func modelsFromDictionaryArray(array: [StringAny]) -> [Rateandreviews_data] {
        var models = [Rateandreviews_data]()
        for item in array {
            models.append(Rateandreviews_data(json: item)!)
        }
        return models
    }
}
