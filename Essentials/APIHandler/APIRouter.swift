//
//  APIRouter.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

enum APIRouter: URLRequestConvertible {
    case login(email: String?, password: String?, role: String, fcmID: String)
    case slider(type: String)
    case country(type: String, countryID: Int? = nil, stateID: Int? = nil)
    case register(userData: UserData, role: String, password: String)
    case uploadImg(imgData: Data? = nil, imgDataArray: [Data]? = nil)
    case provider(pageLimit: PageLimit, coordinates: CLLocationCoordinate2D)
    case healthCareCateory
    case logout(userID: Int)
    case search(type: String, userID: Int, searchTxt: String? = nil, pageLimit: PageLimit? = nil, filter: String? = nil)
    case providerDetails(providerID: Int, pageLimit: PageLimit)
    case forgotPassword(email: String)
    case changePassword(currentPass: String, newPass: String)
    case socialMedia(pageLimit: PageLimit)
    case requestAppointment(provider: UserData, day: String, time: String, date: String, comment: String, customerID: Int)
    case appointmentHistory(role: String, type: String, userID: Int, pageLimit: PageLimit)
    case cancelAppointment(history: AppointmentHistory, date: Date?, reason: String)
    case completeAppointment(histoy: AppointmentHistory, isStart: Bool)
    case giveRateReview(history: AppointmentHistory)
    case cms
    case getProfile(role: String, type: String, userData: UserData)
    case getChatListing(userID: Int, pageLimit: PageLimit)
    case chatHistory(fromID: Int, toID: Int, pageLimit: PageLimit)
    case sendMSG(fromID: Int, toID: Int, msg: String)
    case getNotification(pageLimit: PageLimit)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .register, .uploadImg, .search, .forgotPassword, .changePassword, .requestAppointment, .cancelAppointment,.completeAppointment, .giveRateReview, .getProfile, .chatHistory, .sendMSG:
            return .post
        case .slider, .country, .provider, .healthCareCateory, .logout, .providerDetails, .socialMedia, .appointmentHistory, .cms, .getChatListing, .getNotification:
            return .get
            //        case
            //            return .put
            //        case
            //            return .delete
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login : return "login"
        case .slider: return "sliders"
        case .country: return "countrystatecity"
        case .register: return "signup"
        case .uploadImg: return "uploads"
        case .provider: return "providerslisting"
        case .healthCareCateory: return "healthcarecategory"
        case .logout: return "logout"
        case .search: return "search"
        case .providerDetails: return "providersdetails"
        case .forgotPassword: return "forgotpassword"
        case .changePassword: return "changepassword"
        case .socialMedia: return "socialmedia"
        case .requestAppointment: return "requestappointment"
        case .appointmentHistory: return "history"
        case .cancelAppointment: return "cancelappointment"
        case .completeAppointment: return "completeappointment"
        case .giveRateReview : return "giverateandreviews"
        case .cms: return "cms"
        case .getProfile: return "profile"
        case .getChatListing: return "messaging/userlist"
        case .chatHistory: return "messaging/history"
        case .sendMSG: return "messaging/sendmessage"
        case .getNotification: return "notifications"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .uploadImg(_, _), .healthCareCateory: return [:]
        case .login(let email, let password, let role, let fcmID):
            return [ParameterKey.login_id: email ?? "", ParameterKey.password: password ?? "", ParameterKey.role: role, ParameterKey.fcm_id: fcmID]
        case .slider(let type): return [ParameterKey.type: type]
        case .country(let type, let countryID, let stateID):
            return [ParameterKey.type: type, ParameterKey.country_id: countryID ?? "", ParameterKey.state_id: stateID ?? ""]
        case .register(let userData, let role, let password):
            if role == "Customers" {
                return [ParameterKey.role: role, ParameterKey.image: userData.image ?? "", ParameterKey.username: userData.username ?? "", ParameterKey.lastname: userData.lastname ?? "", ParameterKey.firstname: userData.firstname ?? "", ParameterKey.email: userData.email ?? "", ParameterKey.password: password, ParameterKey.confirm_password: password, ParameterKey.address: userData.address ?? "" , ParameterKey.country: userData.country ?? "", ParameterKey.state: userData.state ?? "", ParameterKey.city: userData.city ?? "", ParameterKey.phone: userData.phone ?? "", ParameterKey.zipcode: userData.zipcode ?? ""]
            } else {
                return [ParameterKey.role: role, ParameterKey.image: userData.image ?? "", ParameterKey.username: userData.username ?? "", ParameterKey.lastname: userData.lastname ?? "", ParameterKey.firstname: userData.firstname ?? "", ParameterKey.email: userData.email ?? "", ParameterKey.password: password, ParameterKey.confirm_password: password, ParameterKey.address: userData.address ?? "" , ParameterKey.country: userData.country ?? "", ParameterKey.state: userData.state ?? "", ParameterKey.city: userData.city ?? "", ParameterKey.phone: userData.phone ?? "", ParameterKey.zipcode: userData.zipcode ?? "", ParameterKey.businessname: userData.businessname ?? "", ParameterKey.service_description : userData.service_description ?? "", ParameterKey.healthcarecategory_id: userData.healthcarecategory_id ?? 0, ParameterKey.monday: userData.monday ?? "0", ParameterKey.monday_start_time: userData.monday_start_time ?? "", ParameterKey.monday_end_time: userData.monday_end_time ?? "", ParameterKey.tuesday: userData.tuesday ?? "0", ParameterKey.tuesday_start_time: userData.tuesday_start_time ?? "", ParameterKey.tuesday_end_time: userData.tuesday_end_time ?? "", ParameterKey.wednesday: userData.wednesday ?? "0", ParameterKey.wednesday_start_time: userData.wednesday_start_time ?? "", ParameterKey.wednesday_end_time: userData.wednesday_end_time ?? "", ParameterKey.thursday: userData.thursday ?? "0", ParameterKey.thursday_start_time: userData.thursday_start_time ?? "", ParameterKey.thursday_end_time: userData.thursday_end_time ?? "", ParameterKey.friday: userData.friday ?? "0", ParameterKey.friday_start_time: userData.friday_start_time ?? "", ParameterKey.friday_end_time: userData.friday_end_time ?? "", ParameterKey.saturday: userData.saturday ?? "0", ParameterKey.saturday_start_time: userData.saturday_start_time ?? "", ParameterKey.saturday_end_time: userData.saturday_end_time ?? "", ParameterKey.sunday: userData.sunday ?? "0", ParameterKey.sunday_start_time: userData.sunday_start_time ?? "", ParameterKey.sunday_end_time: userData.sunday_end_time ?? ""]
            }
        case .provider(let pageLimit, let coordinates):
            return [ParameterKey.page: pageLimit.page, ParameterKey.limit: pageLimit.limit,ParameterKey.latitude: "\(coordinates.latitude)", ParameterKey.longitude: "\(coordinates.longitude)"]
        case .logout(let userID): return [ParameterKey.user_id: userID == 0 ? "" : userID]
        case .search(let type, let userID, let searchTxt, let pageLimit, let filter):
            return [ParameterKey.type: type, ParameterKey.user_id: userID == 0 ? "" : userID, ParameterKey.search: searchTxt ?? "", ParameterKey.filter: filter ?? "", ParameterKey.page: pageLimit?.page ?? "", ParameterKey.limit: pageLimit?.limit ?? ""]
        case .providerDetails(let providerID, let pageLimit):
            return [ParameterKey.provider_id: providerID, ParameterKey.page: pageLimit.page, ParameterKey.limit: pageLimit.limit]
        case .forgotPassword(let email): return [ParameterKey.email: email]
        case .changePassword(let currentPass, let newPass):
            return [ParameterKey.current_password: currentPass, ParameterKey.new_password: newPass, ParameterKey.confirm_password: newPass, ParameterKey.user_id: UserDefaults.standard.user?.user_id ?? 0]
        case .socialMedia(let pageLimit): return [ParameterKey.page: pageLimit.page, ParameterKey.limit: pageLimit.limit]
        case .requestAppointment(let provider, let day, let time, let date, let comment, let customerID):
            return [ParameterKey.provider_id: provider.user_id ?? "", ParameterKey.customer_id: customerID, ParameterKey.healthcarecategory_id: provider.healthcarecategory_id ?? 0, ParameterKey.address: provider.address ?? "", ParameterKey.latitude: provider.latitude ?? 0.0, ParameterKey.longitude: provider.longitude ?? 0.0, ParameterKey.comment: comment, ParameterKey.day: day, ParameterKey.start_time: time, ParameterKey.date: date]
        case .appointmentHistory(let role, let type, let userID, let pageLimit):
            return [ParameterKey.role: role, ParameterKey.type: type, ParameterKey.user_id: userID, ParameterKey.page: pageLimit.page]
        case .cancelAppointment(let history, let date, let reason):
            return [ParameterKey.history_id: history.history_id ?? 0, ParameterKey.provider_id: history.provider_id ?? 0, ParameterKey.cancel_time: date?.getString(inFormat: "h:mm a") ?? "", ParameterKey.cancel_date: date?.getString(inFormat: "yyyy-MM-dd") ?? "", ParameterKey.cancel_reason: reason]
        case .completeAppointment(let histoy, let isStart):
            if isStart {
                return [ParameterKey.history_id: histoy.history_id ?? 0, ParameterKey.provider_id: histoy.provider_id ?? 0, ParameterKey.date: Date().getString(inFormat: "yyyy-MM-dd"), ParameterKey.start_time: Date().getString(inFormat: "h:mm a"), ParameterKey.status: "Start"]
            } else {
                return [ParameterKey.history_id: histoy.history_id ?? 0, ParameterKey.provider_id: histoy.provider_id ?? 0, ParameterKey.end_time: Date().getString(inFormat: "h:mm a"), ParameterKey.status: "End"]
            }
        case .giveRateReview(let history):
            return [ParameterKey.history_id: history.history_id ?? 0, ParameterKey.customer_id: history.customer_id ?? 0, ParameterKey.provider_id: history.provider_id ?? 0, ParameterKey.review: history.review ?? "", ParameterKey.rate: history.rate ?? "0"]
        case .cms: return [:]
        case .getProfile(let role, let type, let userData):
            if role == "Customers" && type == "Update" {
                return [ParameterKey.role: role, ParameterKey.type: type, ParameterKey.image: userData.image ?? "", ParameterKey.lastname: userData.lastname ?? "", ParameterKey.firstname: userData.firstname ?? "", ParameterKey.address: userData.address ?? "" , ParameterKey.country: userData.country ?? "", ParameterKey.state: userData.state ?? "", ParameterKey.city: userData.city ?? "", ParameterKey.phone: userData.phone ?? "", ParameterKey.zipcode: userData.zipcode ?? "", ParameterKey.user_id: UserDefaults.standard.user?.user_id ?? 0]
            } else if role == "Providers" && type == "Update" {
                return [ParameterKey.role: role, ParameterKey.type: type, ParameterKey.image: userData.image ?? "", ParameterKey.lastname: userData.lastname ?? "", ParameterKey.firstname: userData.firstname ?? "", ParameterKey.address: userData.address ?? "" , ParameterKey.country: userData.country ?? "", ParameterKey.state: userData.state ?? "", ParameterKey.city: userData.city ?? "", ParameterKey.phone: userData.phone ?? "", ParameterKey.zipcode: userData.zipcode ?? "", ParameterKey.businessname: userData.businessname ?? "", ParameterKey.service_description : userData.service_description ?? "", ParameterKey.healthcarecategory_id: userData.healthcarecategory_id ?? 0, ParameterKey.monday: userData.monday ?? "0", ParameterKey.monday_start_time: userData.monday_start_time ?? "", ParameterKey.monday_end_time: userData.monday_end_time ?? "", ParameterKey.tuesday: userData.tuesday ?? "0", ParameterKey.tuesday_start_time: userData.tuesday_start_time ?? "", ParameterKey.tuesday_end_time: userData.tuesday_end_time ?? "", ParameterKey.wednesday: userData.wednesday ?? "0", ParameterKey.wednesday_start_time: userData.wednesday_start_time ?? "", ParameterKey.wednesday_end_time: userData.wednesday_end_time ?? "", ParameterKey.thursday: userData.thursday ?? "0", ParameterKey.thursday_start_time: userData.thursday_start_time ?? "", ParameterKey.thursday_end_time: userData.thursday_end_time ?? "", ParameterKey.friday: userData.friday ?? "0", ParameterKey.friday_start_time: userData.friday_start_time ?? "", ParameterKey.friday_end_time: userData.friday_end_time ?? "", ParameterKey.saturday: userData.saturday ?? "0", ParameterKey.saturday_start_time: userData.saturday_start_time ?? "", ParameterKey.saturday_end_time: userData.saturday_end_time ?? "", ParameterKey.sunday: userData.sunday ?? "0", ParameterKey.sunday_start_time: userData.sunday_start_time ?? "", ParameterKey.sunday_end_time: userData.sunday_end_time ?? "", ParameterKey.user_id: UserDefaults.standard.user?.user_id ?? 0]
            } else {
                return [ParameterKey.role: role, ParameterKey.type: type, ParameterKey.user_id: UserDefaults.standard.user?.user_id ?? 0]         
            }
        case .getChatListing(let userID, let pageLimit):
            return [ParameterKey.user_id: userID, ParameterKey.page: pageLimit.page, ParameterKey.limit: pageLimit.limit]
        case .chatHistory(let fromID, let toID, let pageLimit):
            return [ParameterKey.to_user: toID, ParameterKey.from_user: fromID, ParameterKey.page: pageLimit.page, ParameterKey.limit: pageLimit.limit]
        case .sendMSG(let fromID, let toID, let msg):
            return [ParameterKey.from_user: fromID, ParameterKey.to_user: toID, ParameterKey.msg: msg]
        case .getNotification(let pageLimit):
            return [ParameterKey.limit: pageLimit.limit]
        }
    }
    var formData: MultipartFormData? {
        var params: MultipartFormData?
        switch self {
        case .uploadImg(let imgData, let imgDataArray):
            params = MultipartFormData()
            let imgArray = imgDataArray ?? []
            if imgArray.count > 0 {
                for (i, singleData) in imgArray.enumerated() {
                    params?.append(singleData, withName: "\(ParameterKey.image)[\(i)]", fileName: "image\(Date().getString(inFormat: "dd-MM-yyyy_hh_mm_ss"))\(i).jpg", mimeType: "image/jpeg")
                }
            } else {
                params?.append(imgData ?? Data(), withName: "\(ParameterKey.image)", fileName: "image\(Date().getString(inFormat: "dd-MM-yyyy_hh_mm_ss")).jpg", mimeType: "image/jpeg")
            }
        default:
            break
        }
        return params
    }
    
    //MARK: - Headers
    private var headers: HTTPHeaders {
        let defaultHeaders = HTTPHeaders([HTTPHeaderField.acceptType: ContentType.json])
        switch self {
        default:
            break
        }
        return defaultHeaders
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url : URL!
        url = try NetworkingSetup.currentAppState.serverUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        do {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        return urlRequest
    }
}

