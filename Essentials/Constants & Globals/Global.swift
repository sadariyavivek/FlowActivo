
import UIKit
import Foundation

class Global: NSObject
{
    static let sharedInstance = Global()
    
    // Variable Declaration
    var DeviceToken = String()
    var UserID = String()
    var userDataPath = String()
    var PlanExpiryDate = String()
    var PlanType = String()
    var PlanPurchaseDate = String()
    var arrPurchasedPlan = NSMutableArray()
    var isSubscribed = Bool()
    // Setter & Getter
    class func setDataPath(setDataPath : String) -> Void {
        sharedInstance.userDataPath = setDataPath as String
    }
    
    class func getDataPath() -> String {
        return sharedInstance.userDataPath as String
    }
    
    class func setDeviceToken(DeviceToken : String) -> Void {
        sharedInstance.DeviceToken = DeviceToken
    }
    class func getDeviceToken() -> String {
        return sharedInstance.DeviceToken as String
    }    
    class func setUserID(setUserID : String) -> Void {
        sharedInstance.UserID = setUserID as String
    }
    class func getUserID() -> String {
        return sharedInstance.UserID as String
    }
    
    class func setPlanExpiry(setPlanExpiryDate : String) -> Void {
        sharedInstance.PlanExpiryDate = setPlanExpiryDate as String
    }
    class func getPlanExpiryDate() -> String {
        return sharedInstance.PlanExpiryDate as String
    }
    
    class func setPlanPurchaseDate(setPlanPurchaseDate : String) -> Void {
        sharedInstance.PlanPurchaseDate = setPlanPurchaseDate as String
    }
    class func getPlanPurchaseDate() -> String {
        return sharedInstance.PlanPurchaseDate as String
    }
    
    class func setPlanType(setPlanType : String) -> Void {
        sharedInstance.PlanType = setPlanType as String
    }
    class func getPlanType() -> String {
        return sharedInstance.PlanType as String
    }
    
    class func setPurchasedPlan(setPurchasedPlan : NSMutableArray) -> Void{
        sharedInstance.arrPurchasedPlan = setPurchasedPlan as NSMutableArray
    }
    
    class func getArrPurchasedPlan() -> NSMutableArray {
        return sharedInstance.arrPurchasedPlan as NSMutableArray
    }
    
    class func setIsSubscribed(setIsSubscribed : Bool) -> Void {
        sharedInstance.isSubscribed = setIsSubscribed as Bool
    }
    class func getIsSubscribed() -> Bool {
        return sharedInstance.isSubscribed as Bool
    }
}
