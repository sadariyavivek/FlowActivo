

import Foundation

let mainURL = "http://dentalapp-env.eba-krk3v3sk.ap-south-1.elasticbeanstalk.com/api/"

enum URLs: String {
    
    case signIn = "signIn"
    case createTicket = "createTicket"
    case getTicket = "getTicket"
    case uploadFile = "uploadFile"
    case getCommunication = "getCommunication"
    case ticketCommunication = "ticketCommunication"
    case deleteTicket = "deleteTicket/"
    case getNotifications = "getNotifications"
    case getImpressionList = "getImpressionList"
    case deleteNotifications = "deleteNotifications/"
    case impressionQualitySave = "impressionQualitySave"
    case fetchGallery = "fetchGallery"
    case userFeedBack = "userFeedBack"
    case pushEnable = "pushEnable"
    
}
