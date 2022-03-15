//
//  NetworkingSetup.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation
import Alamofire

typealias ParameterKey = NetworkingSetup.APIParameterKey
typealias HTTPHeaderField = NetworkingSetup.HTTPHeaderField
typealias ContentType = NetworkingSetup.ContentType
typealias PageLimit = NetworkingSetup.PageLimit
let PAGINATION_LIMIT = 20

struct NetworkingSetup {
    
    static let currentAppState: AppState = .development
    
    enum AppState {
        case production
        case development
        
        var serverUrl: String {
            switch self {
            case .production:
                return ""
            case .development:
                return "http://100.24.72.18/essentials/api"
            }
        }
        
    }
    
    struct APIParameterKey {
        static let login_id = "login_id"
        static let password = "password"
        static let fcm_id = "fcm_id"
        static let role = "role"
        static let longitude = "longitude"
        static let latitude = "latitude"
        static let type = "type"
        static let country_id = "country_id"
        static let state_id = "state_id"
        static let username = "username"
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let email = "email"
        static let confirm_password = "confirm_password"
        static let address = "address"
        static let country = "country"
        static let state = "state"
        static let city = "city"
        static let phone = "phone"
        static let zipcode = "zipcode"
        static let image = "image"
        static let limit = "limit"
        static let page = "page"
        static let user_id = "user_id"
        static let businessname = "businessname"
        static let service_description = "service_description"
        static let healthcarecategory_id = "healthcarecategory_id"
        static let monday = "monday"
        static let monday_start_time = "monday_start_time"
        static let monday_end_time = "monday_end_time"
        static let tuesday = "tuesday"
        static let tuesday_start_time = "tuesday_start_time"
        static let tuesday_end_time = "tuesday_end_time"
        static let wednesday = "wednesday"
        static let wednesday_start_time = "wednesday_start_time"
        static let wednesday_end_time = "wednesday_end_time"
        static let thursday = "thursday"
        static let thursday_start_time = "thursday_start_time"
        static let thursday_end_time = "thursday_end_time"
        static let friday = "friday"
        static let friday_start_time = "friday_start_time"
        static let friday_end_time = "friday_end_time"
        static let saturday = "saturday"
        static let saturday_start_time = "saturday_start_time"
        static let saturday_end_time = "saturday_end_time"
        static let sunday = "sunday"
        static let sunday_start_time = "sunday_start_time"
        static let sunday_end_time = "sunday_end_time"
        static let search = "search"
        static let filter = "filter"
        static let provider_id = "provider_id"
        static let current_password = "current_password"
        static let new_password = "new_password"
        static let customer_id = "customer_id"
        static let comment = "comment"
        static let day = "day"
        static let start_time = "start_time"
        static let date = "date"
        static let history_id = "history_id"
        static let cancel_time = "cancel_time"
        static let cancel_date = "cancel_date"
        static let cancel_reason = "cancel_reason"
        static let end_time = "end_time"
        static let status = "status"
        static let rate = "rate"
        static let review = "review"
        static let from_user = "from_user"
        static let to_user = "to_user"
        static let msg = "msg"
    }
    
    struct HTTPHeaderField {
        static let authorization = "token"
        static let contentType = "Content-Type"
        static let acceptType = "Accept"
        static let acceptEncoding = "Accept-Encoding"
        static let lancode = "lancode"
        static let platform = "platform"
        static let timezone = "timezone"
    }
    
    struct ContentType {
        static let json = "application/json"
    }
    
    struct PageLimit {
        let page: Int
        var limit: Int = PAGINATION_LIMIT
        init(page: Int, limit: Int = PAGINATION_LIMIT) {
            self.page = page
            self.limit = limit
        }
    }
    
}


