//
//  UserData.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct UserData : Codable {
    let user_id : Int?
    var username : String?
    var firstname : String?
    var lastname : String?
    var email : String?
    var address : String?
    var country_id : Int?
    var state_id : Int?
    var city_id : Int?
    var country : String?
    var state : String?
    var city : String?
    var phone : String?
    var zipcode : String?
    var fcm_id : String?
    var healthcarecategory_id : Int?
    var healthcarecategory : String?
    var monday : Int?
    var monday_start_time : String?
    var monday_end_time : String?
    var tuesday : Int?
    var tuesday_start_time : String?
    var tuesday_end_time : String?
    var wednesday : Int?
    var wednesday_start_time : String?
    var wednesday_end_time : String?
    var thursday : Int?
    var thursday_start_time : String?
    var thursday_end_time : String?
    var friday : Int?
    var friday_start_time : String?
    var friday_end_time : String?
    var saturday : Int?
    var saturday_start_time : String?
    var saturday_end_time : String?
    var sunday : Int?
    var sunday_start_time : String?
    var sunday_end_time : String?
    var payment_status : Bool?
    var image : String?
    var service_description: String?
    var businessname: String?
    var latitude: String?
    var longitude: String?
    var distance: String?
    var rate_average: Int?
    var total_rateandreview: Int?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case username = "username"
        case firstname = "firstname"
        case lastname = "lastname"
        case email = "email"
        case address = "address"
        case country_id = "country_id"
        case state_id = "state_id"
        case city_id = "city_id"
        case country = "country"
        case state = "state"
        case city = "city"
        case phone = "phone"
        case zipcode = "zipcode"
        case fcm_id = "fcm_id"
        case healthcarecategory_id = "healthcarecategory_id"
        case healthcarecategory = "healthcarecategory"
        case monday = "monday"
        case monday_start_time = "monday_start_time"
        case monday_end_time = "monday_end_time"
        case tuesday = "tuesday"
        case tuesday_start_time = "tuesday_start_time"
        case tuesday_end_time = "tuesday_end_time"
        case wednesday = "wednesday"
        case wednesday_start_time = "wednesday_start_time"
        case wednesday_end_time = "wednesday_end_time"
        case thursday = "thursday"
        case thursday_start_time = "thursday_start_time"
        case thursday_end_time = "thursday_end_time"
        case friday = "friday"
        case friday_start_time = "friday_start_time"
        case friday_end_time = "friday_end_time"
        case saturday = "saturday"
        case saturday_start_time = "saturday_start_time"
        case saturday_end_time = "saturday_end_time"
        case sunday = "sunday"
        case sunday_start_time = "sunday_start_time"
        case sunday_end_time = "sunday_end_time"
        case payment_status = "payment_status"
        case image = "image"
        case service_description = "service_description"
        case businessname = "businessname"
        case latitude = "latitude"
        case longitude = "longitude"
        case distance = "distance"
        case rate_average = "rate_average"
        case total_rateandreview = "total_rateandreview"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try? values.decodeIfPresent(Int.self, forKey: .user_id)
        username = try? values.decodeIfPresent(String.self, forKey: .username)
        firstname = try? values.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try? values.decodeIfPresent(String.self, forKey: .lastname)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        address = try? values.decodeIfPresent(String.self, forKey: .address)
        country_id = try? values.decodeIfPresent(Int.self, forKey: .country_id)
        state_id = try? values.decodeIfPresent(Int.self, forKey: .state_id)
        city_id = try? values.decodeIfPresent(Int.self, forKey: .city_id)
        country = try? values.decodeIfPresent(String.self, forKey: .country)
        state = try? values.decodeIfPresent(String.self, forKey: .state)
        city = try? values.decodeIfPresent(String.self, forKey: .city)
        phone = try? values.decodeIfPresent(String.self, forKey: .phone)
        zipcode = try? values.decodeIfPresent(String.self, forKey: .zipcode)
        fcm_id = try? values.decodeIfPresent(String.self, forKey: .fcm_id)
        healthcarecategory_id = try? values.decodeIfPresent(Int.self, forKey: .healthcarecategory_id)
        healthcarecategory = try? values.decodeIfPresent(String.self, forKey: .healthcarecategory)
        monday = try? values.decodeIfPresent(Int.self, forKey: .monday)
        monday_start_time = try? values.decodeIfPresent(String.self, forKey: .monday_start_time)
        monday_end_time = try? values.decodeIfPresent(String.self, forKey: .monday_end_time)
        tuesday = try? values.decodeIfPresent(Int.self, forKey: .tuesday)
        tuesday_start_time = try? values.decodeIfPresent(String.self, forKey: .tuesday_start_time)
        tuesday_end_time = try? values.decodeIfPresent(String.self, forKey: .tuesday_end_time)
        wednesday = try? values.decodeIfPresent(Int.self, forKey: .wednesday)
        wednesday_start_time = try? values.decodeIfPresent(String.self, forKey: .wednesday_start_time)
        wednesday_end_time = try? values.decodeIfPresent(String.self, forKey: .wednesday_end_time)
        thursday = try? values.decodeIfPresent(Int.self, forKey: .thursday)
        thursday_start_time = try? values.decodeIfPresent(String.self, forKey: .thursday_start_time)
        thursday_end_time = try? values.decodeIfPresent(String.self, forKey: .thursday_end_time)
        friday = try? values.decodeIfPresent(Int.self, forKey: .friday)
        friday_start_time = try? values.decodeIfPresent(String.self, forKey: .friday_start_time)
        friday_end_time = try? values.decodeIfPresent(String.self, forKey: .friday_end_time)
        saturday = try? values.decodeIfPresent(Int.self, forKey: .saturday)
        saturday_start_time = try? values.decodeIfPresent(String.self, forKey: .saturday_start_time)
        saturday_end_time = try? values.decodeIfPresent(String.self, forKey: .saturday_end_time)
        sunday = try? values.decodeIfPresent(Int.self, forKey: .sunday)
        sunday_start_time = try? values.decodeIfPresent(String.self, forKey: .sunday_start_time)
        sunday_end_time = try? values.decodeIfPresent(String.self, forKey: .sunday_end_time)
        payment_status = try? values.decodeIfPresent(Bool.self, forKey: .payment_status)
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        service_description = try? values.decodeIfPresent(String.self, forKey: .service_description)
        businessname = try? values.decodeIfPresent(String.self, forKey: .businessname)
        latitude = try? values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try? values.decodeIfPresent(String.self, forKey: .longitude)
        distance = try? values.decodeIfPresent(String.self, forKey: .distance)
        rate_average = try? values.decodeIfPresent(Int.self, forKey: .rate_average)
        total_rateandreview = try? values.decodeIfPresent(Int.self, forKey: .total_rateandreview)
    }

    init?(json: [String: Any]) {
        if let jsonSerialize = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            do {
                self = try JSONDecoder().decode(UserData.self, from: jsonSerialize)
                return
            } catch {
                assertionFailure("Error decoding : \(error)")
                return nil
            }
        }
        return nil
    }
}
