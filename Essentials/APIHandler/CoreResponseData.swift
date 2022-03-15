//
//  CoreResponseData.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation
import Alamofire

struct AppError: Error  {
    
    let status : Int?
    let message : String?
    let data: Any?
    let error: Error?
    
    func getResponseDictionary() -> StringAny? {
        return data as? StringAny
    }
    func getResponseArryDictionary() -> [StringAny]? {
        return data as? [StringAny]
    }
}

struct CoreResponseData : Codable {
    
    var code : Int?
    var status : Int?
    var message : String?
    var data : Any?
    var image : String?
    var per_page: String?
    var current_page: Int?
    var last_page: Int?
    var total_rows: Int?
    var rateandreviews_data: [Rateandreviews_data]?
    var provider_data: [UserData]?
    var contactus_data: [Contactus_data]?
    var aboutus_data:  [Aboutus_data]?
    var shareourapp_data: [Shareourapp_data]?
    var privacypolicy_data: [Privacypolicy_data]?
    var notification: [NotificationModal]?
    
    
    private var user : UserData?
    private var sliders : [Slider]?
    private var countries : [Country]?
    private var states : [Country]?
    private var cities : [Country]?
    private var providers : [Providers]?
    private var healthCareCategory : [HealthCareCategory]?
    private var recentSearch: [RecentSearch]?
    private var socialMedia: [SocialMedia]?
    private var appointmentHistory: [AppointmentHistory]?
    private var chatList: [ChatList]?
    private var chatMessage: [ChatMessageList]?
    
    private var values: KeyedDecodingContainer<CodingKeys>?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case message = "message"
        case data = "data"
        case image = "image"
        case per_page = "per_page"
        case current_page = "current_page"
        case last_page = "last_page"
        case total_rows = "total_rows"
        case rateandreviews_data = "rateandreviews_data"
        case provider_data = "provider_data"
        case contactus_data = "contactus_data"
        case aboutus_data = "aboutus_data"
        case shareourapp_data = "shareourapp_data"
        case privacypolicy_data = "privacypolicy_data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.values = values
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        if let stringAny = try? values.decode(StringAny.self, forKey: .data) {
            data = stringAny
        } else if let stringAny = try? values.decode([Any].self, forKey: .data) {
            data = stringAny
        }
        image = try? values.decodeIfPresent(String.self, forKey: .image)
        per_page = try? values.decodeIfPresent(String.self, forKey: .per_page)
        current_page = try? values.decodeIfPresent(Int.self, forKey: .current_page)
        last_page = try? values.decodeIfPresent(Int.self, forKey: .last_page)
        total_rows = try? values.decodeIfPresent(Int.self, forKey: .total_rows)
        rateandreviews_data = try? values.decodeIfPresent([Rateandreviews_data].self, forKey: .rateandreviews_data)
        provider_data = try? values.decodeIfPresent([UserData].self, forKey: .provider_data)
        contactus_data = try? values.decodeIfPresent([Contactus_data].self, forKey: .contactus_data)
        aboutus_data = try? values.decodeIfPresent([Aboutus_data].self, forKey: .aboutus_data)
        shareourapp_data = try? values.decodeIfPresent([Shareourapp_data].self, forKey: .shareourapp_data)
        privacypolicy_data = try? values.decodeIfPresent([Privacypolicy_data].self, forKey: .privacypolicy_data)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    init() {
        self.code = nil
        self.status = nil
        self.message = nil
        self.data = nil
    }
    
    func getResponseDictionary() -> StringAny? {
        return data as? StringAny
    }
    func getResponseArryDictionary() -> [StringAny]? {
        return data as? [StringAny]
    }
        
    mutating func getUser() -> UserData? {
        if let user = self.user {
            return user
        }
        if let stringAny = getResponseArryDictionary() {
            if let dict = stringAny.first {
                user = UserData(json: dict)
                return user!
            }
        }
        return nil
    }
    
    mutating func getSlider() -> [Slider]? {
        if let user = self.sliders {
            return user
        }
        if let stringAny = getResponseArryDictionary() {
            let array = Slider.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getCountries() -> [Country]? {
        if let country = self.countries {
            return country
        }
        if let stringAny = getResponseArryDictionary() {
            let array = Country.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getStates() -> [Country]? {
        if let state = self.states {
            return state
        }
        if let stringAny = getResponseArryDictionary() {
            let array = Country.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getCities() -> [Country]? {
        if let state = self.cities {
            return state
        }
        if let stringAny = getResponseArryDictionary() {
            let array = Country.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getProvider() -> [Providers]? {
        if let provider = self.providers {
            return provider
        }
        if let stringAny = getResponseArryDictionary() {
            let array = Providers.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getCategory() -> [HealthCareCategory]? {
        if let category = self.healthCareCategory {
            return category
        }
        if let stringAny = getResponseArryDictionary() {
            let array = HealthCareCategory.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getRecentSearch() -> [RecentSearch]? {
        if let search = self.recentSearch {
            return search
        }
        if let stringAny = getResponseArryDictionary() {
            let array = RecentSearch.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getSocialMedia() -> [SocialMedia]? {
        if let media = self.socialMedia {
            return media
        }
        if let stringAny = getResponseArryDictionary() {
            let array = SocialMedia.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getHistory() -> [AppointmentHistory]? {
        if let history = self.appointmentHistory {
            return history
        }
        if let stringAny = getResponseArryDictionary() {
            let array = AppointmentHistory.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getChatList() -> [ChatList]? {
        if let history = self.chatList {
            return history
        }
        if let stringAny = getResponseArryDictionary() {
            let array = ChatList.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getChatHistory() -> [ChatMessageList]? {
        if let history = self.chatMessage {
            return history
        }
        if let stringAny = getResponseArryDictionary() {
            let array = ChatMessageList.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
    
    mutating func getNotification() -> [NotificationModal]? {
        if let history = self.notification {
            return history
        }
        if let stringAny = getResponseArryDictionary() {
            let array = NotificationModal.modelsFromDictionaryArray(array: stringAny)
            return array
        }
        return nil
    }
}
