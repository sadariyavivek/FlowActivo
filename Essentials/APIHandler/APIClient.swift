//
//  APIClient.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

struct APIClient {
    
    @discardableResult
    private static func performRequest<T:Decodable>(route: APIRouter, doShowLoading: Bool = true, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, AFError>, HTTPURLResponse?) -> Void) -> DataRequest {
        print("Request: ")
        debugPrint(route.urlRequest!)
        if let body = route.urlRequest?.httpBody, let header = route.urlRequest?.headers {
            print("Headers: ")
            debugPrint(header)
            print("Params: ")
            debugPrint(String(data: body, encoding: .utf8) ?? "")
        }
        if doShowLoading {
            LoadingView.showLoading()
        }
        if let formData = route.formData {
            return AF.upload(multipartFormData: formData, with: route).responseDecodable (decoder: decoder){ (response: AFDataResponse<T>) in
                LoadingView.hideLoading()
                if let data = response.data {
                    print("Response: ")
                    let responseString = String(data: data, encoding: .utf8) ?? ""
                    print(responseString.html2String)
                }
                completion(response.result,response.response)
            }
        }
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: AFDataResponse<T>) in
                LoadingView.hideLoading()
                if let data = response.data {
                    print("Response: ")
                    let responseString = String(data: data, encoding: .utf8) ?? ""
                    print(responseString.html2String)
                }
                completion(response.result,response.response)
        }
    }
    
    private static func handleResponse(result: (Result<CoreResponseData, AFError>), httpUrlResponse: HTTPURLResponse? = nil) -> Result<CoreResponseData, AppError> {
        switch result {
        case .success(let data):
            let appError = AppError(status: data.status, message: (httpUrlResponse?.statusCode ?? 0) == 500 ? "Internal Server Error".localized : data.message, data: data.data, error: nil)
            if let code = data.status, !(code >= 200 && code <= 210) {
                return .failure(appError)
            }
            if let urlReponse = httpUrlResponse, urlReponse.statusCode == 401 {
                return .failure(appError)
            }
            if let urlResponse = httpUrlResponse, !(urlResponse.statusCode >= 200 && urlResponse.statusCode <= 210) {
                return .failure(appError)
            }
            return .success(data)
        case .failure(let err):
                let error = err as NSError
                if error.code == NSURLErrorNotConnectedToInternet || error.code == 13 {
                    return .failure(AppError(status: nil, message: "No internet connection", data: nil, error: err))
                }
            return .failure(AppError(status: nil, message: nil, data: nil, error: err))
        }
    }
    
    static func login(email: String?, password: String?, role: String, fcmiD: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.login(email: email, password: password, role: role, fcmID: fcmiD), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func register(userData: UserData, role: String, password: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.register(userData: userData, role: role, password: password), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func slider(type: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.slider(type: type), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getCountry(type: String, countryID: Int? = nil, stateID: Int? = nil, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.country(type: type, countryID: countryID, stateID: stateID), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func uploadImage(img: Data? = nil, imgArray: [Data]? = nil, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.uploadImg(imgData: img, imgDataArray: imgArray), doShowLoading: doShowLoading, completion: {completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getProviders(pageLimit: PageLimit, coordinates: CLLocationCoordinate2D, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.provider(pageLimit: pageLimit, coordinates: coordinates), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getHealthCareCategory(doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.healthCareCateory, doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func logout(userID: Int, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.logout(userID: userID), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func search(type: String, userID: Int, searchTxt: String? = nil, pageLimit: PageLimit? = nil, filter: String? = nil, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.search(type: type, userID: userID, searchTxt: searchTxt, pageLimit: pageLimit, filter: filter), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func providerDetails(providerID: Int, pageLimit: PageLimit, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.providerDetails(providerID: providerID, pageLimit: pageLimit), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func forgotPassword(email: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.forgotPassword(email: email), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func changePassword(currentPass: String, newPass: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.changePassword(currentPass: currentPass, newPass: newPass), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func socialMedia(pageLimit: PageLimit, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.socialMedia(pageLimit: pageLimit), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func requestAppoinment(provider: UserData, day: String, time: String, date: String, comment: String, customerID: Int, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.requestAppointment(provider: provider, day: day, time: time, date: date, comment: comment, customerID: customerID), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func appointmentHistory(role: String, type: String, userID: Int, page: PageLimit, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.appointmentHistory(role: role, type: type, userID: userID, pageLimit: page), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func cancelAppointment(history: AppointmentHistory, date: Date?, reason: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.cancelAppointment(history: history, date: date, reason: reason), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func completeAppointment(history: AppointmentHistory, isStart: Bool, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.completeAppointment(histoy: history, isStart: isStart), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func giveRateReview(history: AppointmentHistory, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.giveRateReview(history: history), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func cms(doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.cms, doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getProfile(role: String, type: String, userData: UserData, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.getProfile(role: role, type: type, userData: userData), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getChatList(userID:Int, pageLimit: PageLimit, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.getChatListing(userID: userID, pageLimit: pageLimit), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getChatHistory(fromID:Int, toID: Int, pageLimit: PageLimit, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.chatHistory(fromID: fromID, toID: toID, pageLimit: pageLimit), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func sendMsg(fromID:Int, toID: Int, msg: String, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.sendMSG(fromID: fromID, toID: toID, msg: msg), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
    
    static func getNotificatioin(pageLimit: PageLimit, doShowLoading: Bool = false, completion: @escaping (Result<CoreResponseData, AppError>) -> Void) {
        performRequest(route: APIRouter.getNotification(pageLimit: pageLimit), doShowLoading: doShowLoading, completion:{completion(handleResponse(result: $0, httpUrlResponse: $1))})
    }
}
