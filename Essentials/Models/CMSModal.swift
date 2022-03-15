//
//  CMSModal.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 07/08/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation

struct Aboutus_data : Codable {
    let aboutus_id : Int?
    let description : String?

    enum CodingKeys: String, CodingKey {
        case aboutus_id = "aboutus_id"
        case description = "description"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aboutus_id = try? values.decodeIfPresent(Int.self, forKey: .aboutus_id)
        description = try? values.decodeIfPresent(String.self, forKey: .description)
    }
}

struct Contactus_data : Codable {
    let contactus_id : Int?
    let address : String?
    let phone : String?
    let email : String?
    let website : String?

    enum CodingKeys: String, CodingKey {
        case contactus_id = "contactus_id"
        case address = "address"
        case phone = "phone"
        case email = "email"
        case website = "website"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contactus_id = try? values.decodeIfPresent(Int.self, forKey: .contactus_id)
        address = try? values.decodeIfPresent(String.self, forKey: .address)
        phone = try? values.decodeIfPresent(String.self, forKey: .phone)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        website = try? values.decodeIfPresent(String.self, forKey: .website)
    }
}

struct Privacypolicy_data : Codable {
    let privacypolicy_id : Int?
    let description : String?

    enum CodingKeys: String, CodingKey {
        case privacypolicy_id = "privacypolicy_id"
        case description = "description"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacypolicy_id = try? values.decodeIfPresent(Int.self, forKey: .privacypolicy_id)
        description = try? values.decodeIfPresent(String.self, forKey: .description)
    }
}

struct Shareourapp_data : Codable {
    let shareourapp_id : Int?
    let android_link : String?
    let ios_link : String?

    enum CodingKeys: String, CodingKey {
        case shareourapp_id = "shareourapp_id"
        case android_link = "android_link"
        case ios_link = "ios_link"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shareourapp_id = try? values.decodeIfPresent(Int.self, forKey: .shareourapp_id)
        android_link = try? values.decodeIfPresent(String.self, forKey: .android_link)
        ios_link = try? values.decodeIfPresent(String.self, forKey: .ios_link)
    }
}
