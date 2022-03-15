

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftGifOrigin


let ImageViewGif = UIImageView()
struct myColors
{
    static let AppLoaderColor: UIColor = UIColor(red: 27.0/255.0, green: 173.0/255.0, blue: 227.0/255.0, alpha: 1.0)//1BADE3
    static let AppBlackColor: UIColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
    
}

struct myStrings
{
    static let KUSEREREMAIL: String = "KUserEmail"
    static let KUSERID: String = "KUserId"
}

func getInteger(_ obj: Any?) -> Int {
    if let num = obj as? NSNumber {
        return num.intValue
    }
    else if let str = obj as? NSString {
        return str.integerValue
    }
    else {
//        print("NEITHER A STRING NOR A NUMBER")
    }
    return 0
}


/// Returns Integer Value or 0
func getFloat(_ obj: Any?) -> Float {
    if let num = obj as? NSNumber {
        return num.floatValue
    }
    else if let str = obj as? NSString {
        return str.floatValue
    }
    else {
//        print("NEITHER A STRING NOR A NUMBER")
    }
    return 0
}

/// Returns Double Value or 0
func getDouble(_ obj: Any?) -> Double {
    if let num = obj as? NSNumber {
        return num.doubleValue
    }
    else if let str = obj as? NSString {
        return str.doubleValue
    }
    else {
//        print("NEITHER A STRING NOR A NUMBER")
    }
    return 0
}


/// Returns the String Value or "" if failed
func getString(_ obj: Any?) -> String {
    if let str = obj as? NSString {
        return str as String
    }
    else if let num = obj as? NSNumber {
        return num.stringValue
    }
    else {
//        print("NEITHER A STRING NOR A NUMBER")
    }
    return ""
}


/// Returns 'true' or 'false' from given input
func getBool(_ obj: Any?, default defaultBool: Bool = false) -> Bool {
    if let bool = obj as? Bool {
        return bool
    } else if let str = obj as? String {
        return (str.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "yes") ? true : false
    } else {
        return defaultBool
    }

}

extension UIViewController {
            
    func GoNext(toScreen: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: toScreen) as UIViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func GoNextWithAnimation(toScreen: String) {
        let transition:CATransition = CATransition()
        transition.duration = 0.2
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: toScreen) as UIViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func GoBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func GoBackWithAnimation() {
        let transition:CATransition = CATransition()
        transition.duration = 0.2
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
    
    func getData(fromData: AnyObject, forKey: String) -> String{
        if let value = fromData.value(forKey: forKey) {
            return "\(value)"
        }else{
            return ""
        }
    }
    
    func showLoader(loader: NVActivityIndicatorView) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        loader.startAnimating()
        loader.isHidden = false
    }
    
    func hideLoader(loader: NVActivityIndicatorView) {
        UIApplication.shared.endIgnoringInteractionEvents()
        loader.isHidden = true
        loader.stopAnimating()
    }
    
    func addIndicator() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        ImageViewGif.frame = CGRect(x: (self.view.frame.size.width/2) - 25, y: (self.view.frame.size.height/2) - 25, width: 50, height: 50)
        ImageViewGif.loadGif(name : "Loader")
        view.addSubview(ImageViewGif)

    }
    func removeIndicator() {
        UIApplication.shared.endIgnoringInteractionEvents()
        ImageViewGif.removeFromSuperview()
    }
    
    
}
struct Miscellaneous
{
    static let APPDELEGATE  = UIApplication.shared.delegate as! AppDelegate
}

extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z_.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func insertSpace(string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
}

struct myMessages
{
    static let INTERNET_CONNECTIVITY_FAIL = "Please check your internet connection and try again"
    static let ERROR = "Error!"
    static let CONGRATULATION = "Congratulations!"
    static let SUCCESSFUL = "Successful!"

}

extension UIViewController {
    
    func makeToast(toastMessage : String) -> Void
    {
        var style = ToastStyle()
        style.backgroundColor = myColors.AppBlackColor//UIColor.black
        
        style.titleColor = .white
        style.titleAlignment = NSTextAlignment.center
        style.messageAlignment = NSTextAlignment.center
        self.view.window!.makeToast(toastMessage, duration: 2.0, position: .bottom, title: nil, image: nil, style: style, completion: nil)
    }
    func showMyAlert(myMessage : String) -> Void {
        let alertController = UIAlertController(title: "", message: myMessage, preferredStyle: UIAlertController.Style.alert)
        
        
        alertController.setValue(NSAttributedString(string: myMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]), forKey: "attributedMessage")
        
        alertController.setValue(NSAttributedString(string:myMessage,attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]), forKey: "attributedMessage")
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func hideAlert() {
//        if let nvc = appDelegate.window?.rootViewController as? UINavigationController {
//            if nvc.viewControllers.count == 1 {
//                appDelegate.closingLastAlert = true
//            }
//        }
//        let transform = CGAffineTransform(scaleX: 0, y: 0)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.backgroundColor = .clear
//            self.viewAlert.transform = transform
//        }) { (animated) in
//            if animated {
//                if let nvc = appDelegate.alertWindow?.rootViewController as? UINavigationController {
//                    if nvc.viewControllers.count > 1 {
//                        nvc.popViewController(animated: false)
//                    } else {
//                        self.alertWindow?.rootViewController = nil
//                        self.alertWindow?.removeFromSuperview()
//                        self.alertWindow = nil
//                    }
//                } else {
//                    appDelegate.removeAlertWindow()
//                }
//                appDelegate.closingLastAlert = false
//            }
//        }
//    }
    
    func showMyAlert(desc: String, details: String? = nil, logoutTitle: String? = nil, cancelTitle: String? = nil, logOutnHandler: voidCompletion? = nil, cancelHandler: voidCompletion? = nil, vc: UIViewController) {
        let alertVC = ErrorMessageController.instantiateFromStoryboard()
        alertVC.msg = desc
        alertVC.blockForOk = {
            cancelHandler?()
        }
        alertVC.blockForLogout = {
            logOutnHandler?()
        }
        let logutbtnTitle = ((logoutTitle == "") && (logOutnHandler != nil)) ? "Ok" : logoutTitle
        let canceltxt = ((cancelTitle == "") && (cancelHandler != nil)) ? "Cancel" : cancelTitle
        alertVC.cancleBtnTitle = canceltxt ?? ""
        alertVC.logoutBtnTitle = logutbtnTitle ?? ""
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    func showMyAlertWithTitle(myMessage : String, title: String) -> Void {
        let alertController = UIAlertController(title: title, message: myMessage, preferredStyle: UIAlertController.Style.alert)
        
        //For Title
        alertController.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]), forKey: "attributedMessage")
        
        alertController.setValue(NSAttributedString(string:title,attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]), forKey: "attributedMessage")
        
        //For Message
        alertController.setValue(NSAttributedString(string: myMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]), forKey: "attributedMessage")
        
        alertController.setValue(NSAttributedString(string:myMessage,attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]), forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func transition(_ index: Int, controller: UIView) {
        let tr = CATransition.init()
        tr.duration = 0.6
        tr.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tr.type = CATransitionType.push
        tr.delegate = self as? CAAnimationDelegate
        switch index {
        case 0:
            tr.subtype = CATransitionSubtype.fromBottom
        case 1:
            tr.subtype = CATransitionSubtype.fromTop
        case 2:
            tr.subtype = CATransitionSubtype.fromRight
        case 3:
            tr.subtype = CATransitionSubtype.fromLeft
        default:
            break
        }
        
        controller.layer.add(tr, forKey: nil)
    }
    
    

    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}



extension UIViewController {
    
    func previousViewController() -> UIViewController? {
        let numberOfViewControllers = self.navigationController!.viewControllers.count
        if numberOfViewControllers > 2{
            return self.navigationController!.viewControllers[numberOfViewControllers - 2] as UIViewController
        }
        else{
            return nil
        }
    }
}

extension UITextField {
    func setPlaceHolderString(mystring : String) -> Void {
        let placeholderFirstName = NSAttributedString(string: mystring, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.attributedPlaceholder = placeholderFirstName
    }
}

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType? {
        guard iPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return nil
        }
    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            
            return false
        case .online(.wwan):
            print("Connected via WWAN")
            return true
        case .online(.wiFi):
            print("Connected via WiFi")
            return true
        }
    }
}



extension String
{
    // string function to escape ' in query
    func deQuote() -> String
    {
        return self.replacingOccurrences(of: "'", with: "<!!-!!-replaceMeWithSingleQuote-!!-!!-") // do not localize this text
    }
    
    // function to add ' which was removed in query
    func reQuote() -> String
    {
        return self.replacingOccurrences(of: "<!!-!!-replaceMeWithSingleQuote-!!-!!-", with: "'") // do not localize this text
    }
    
    func removeQuote() -> String
    {
        return self.replacingOccurrences(of: "\"\"", with: "\"") // do not localize this text
    }
    
    func remove() -> String
    {
        return self.replacingOccurrences(of: "'", with: "") // do not localize this text
    }
    
    func removeBracketStart() -> String
    {
        return self.replacingOccurrences(of: "{", with: "[") // do not localize this text
    }
    
    func removeBracketEnd() -> String
    {
        return self.replacingOccurrences(of: "}", with: "]") // do not localize this text
    }
    func removeSlash() -> String
    {
        return self.replacingOccurrences(of: "\\", with: "") // do not localize this text
    }
    
    func removeDots() -> String
    {
        return self.replacingOccurrences(of: "null", with: "a") // do not localize this text
    }
    
    func removeTwoDots() -> String
    {
        return self.replacingOccurrences(of: "\\", with: "") // do not localize this text
    }
    
    func removeZero() -> String
    {
        return self.replacingOccurrences(of: "0", with: "") // do not localize this text
    }
    func removeZero123() -> String
    {
        //return self.replacingOccurrences(of: "\"[", with: "") // do not localize this text
        let myString = "\u{22}["
        return self.replacingOccurrences(of: myString, with: "[") // do not localize this text
    }
    func removeZero456() -> String
    {
        let myString = "]\u{22}"
        return self.replacingOccurrences(of: myString, with: "]") // do not localize this text
    }
    func removeDoubleQuotes() -> String
    {
        let myString = "\u{22}\u{22}Nurse Anesthetist, Certified Registered"
        return self.replacingOccurrences(of: myString, with: String()) // do not localize this text
    }
}
extension UIView {
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}


typealias StringAny = [String: Any]
typealias voidCompletion = (()->Void)
typealias Loading = (showLoader: Bool, showTransparentView: Bool)
typealias boolCompletion = ((_ success: Bool)->Void)

let appDelegate = UIApplication.shared.delegate as! AppDelegate
@available(iOS 13.0, *)
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
var isLogout = false
let placeHolderImage = "avtar".imageWithOriginalMode
let GOOGLE_MAP_KEY = "AIzaSyAy2bbSdMkjqf_HesWbZiW6vDp8Kxe56o8"
let STRIP_TEST_KEY = "pk_test_zYnCgv6nLRc5ZCZvdnqR4fRS"

class Constants {
    
    static var localizationDictionary = StringAny()
    
    static func isIphone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static func loadLocalizationDictionary(withReplacing newContent: StringAny = [:]) {
        if let jsonFile = Bundle.main.url(forResource: "localization_text", withExtension: "json") {
            if newContent.count > 0 {
                do {
                    let newData = try JSONSerialization.data(withJSONObject: newContent, options: .prettyPrinted)
                    if let newContentString = String(data: newData, encoding: .utf8) {
                        try newContentString.write(to: jsonFile, atomically: false, encoding: .utf8)
                    }
                } catch {
                    print("Cannot update localization_key_value.json: \(error.localizedDescription)")
                }
            }
            do {
                let fileData = try Data(contentsOf: jsonFile)
                if let json = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers) as? StringAny {
                    Constants.localizationDictionary = json
                }
            } catch {
                print("Cannot get localization_key_value.json : \(error.localizedDescription)")
            }
        }
    }
}
//MARK:- **** Enum ****

enum AppTimeZone {
    case current
    case utc
}

enum PatientOrHealthCare {
    case customer
    case provider
    case guest
    
    var value: Int {
        switch self {
        case .customer: return 0
        case .provider: return 1
        case .guest: return 2
        }
    }
}

enum ForgotChangePassword {
    case forgotPass
    case changePass
    case socialMedia
}

enum EnumForErrorORTextField {
    case errorview
    case textView
    case rateReview
}

enum EnumForCMS {
    case about
    case privacypolicy
    case contactus
}

enum HealthCareDetails: String {
    case about = "About"
    case rate = "Rate"
    case location = "Location"
    case reviews = "Reviews"
}

enum EnumForHistory: String {
    case complete = "COMPLETED"
    case pending = "PENDING"
    case cancelled = "CANCELLED"
}

enum EnumSocialMedia: String {
    case twitter = "ic_twitter"
    case tumbler = "ic_tumbler"
    case instagram = "ic_instagram"
    case google = "ic_google"
    case fb = "ic_fb"
}

enum EnumSearchScreen {
    case filter
    case isSearching
    case search
    case recentSearch
    case success
}

enum SideMenuOptions {
    case aboutus
    case viewLocalListing
    case changePassword
    case shareOurApp
    case socialMedia
    case privacyPolicy
    case contactus
    case appointmentHistory
    case myMessages
    
    var title: String {
        switch self {
        case .aboutus: return "About Us"
        case .viewLocalListing: return "View Local Listings"
        case .changePassword: return "Change Password"
        case .shareOurApp: return "Share Our App"
        case .socialMedia: return "Social Media"
        case .privacyPolicy: return "Privacy Policy"
        case .contactus: return "Contact US"
        case .appointmentHistory: return "Appointment History"
        case .myMessages: return "My Messages"
        }
    }
    
    var image: UIImage {
        switch self {
        case .aboutus: return "ic_aboutUs".imageWithOriginalMode
        case .viewLocalListing: return "ic_listing".imageWithOriginalMode
        case .changePassword: return "ic_key".imageWithOriginalMode
        case .shareOurApp: return "ic_share".imageWithOriginalMode
        case .socialMedia: return "ic_socialMedia".imageWithOriginalMode
        case .privacyPolicy: return "ic_privacy".imageWithOriginalMode
        case .contactus: return "ic_contact_us".imageWithOriginalMode
        case .appointmentHistory: return "ic_history".imageWithOriginalMode
        case .myMessages: return "ic_chat".imageWithOriginalMode
        }
    }
}

enum AppFont: Int {
    
    case dejaVuSansExtraLight = 0
    case dejaVuSans = 1
    case dejaVuSansOblique = 2
    case dejaVuSansBold = 3
    case dejaVuSansBoldOblique = 4
    
    func getFont(withSize size: CGFloat = 18) -> UIFont {
        switch self {
        case .dejaVuSans: return  UIFont.dejaVuSans(withSize: size)
        case .dejaVuSansExtraLight: return UIFont.dejaVuSansExtraLight(withSize: size)
        case .dejaVuSansOblique: return UIFont.dejaVuSansOblique(withSize: size)
        case .dejaVuSansBold: return UIFont.dejaVuSansBold(withSize: size)
        case .dejaVuSansBoldOblique: return UIFont.dejaVuSansBoldOblique(withSize: size)
        }
    }
}
