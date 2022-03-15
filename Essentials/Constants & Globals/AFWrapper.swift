

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SwiftGifOrigin


//let ImageViewGif = UIImageView()

class AFWrapper: NSObject {
    
    class func requestGETURL(_ strURL: String, loaderType: Int, controller: UIViewController, success:@escaping ([String:Any]) -> Void, failure:@escaping (Error) -> Void, netConn:@escaping (String) -> Void) {
        
        let myURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if Reachability.isConnectedToNetwork() {
            
            switch(loaderType) {
            case 1:
                NVActivityIndicatorViewable.show(myView: controller.view)
                break
            case 2:
                break
            default:
                NVActivityIndicatorViewable.show(myView: controller.view)
                break
            }

            AF.request(myURL!).responseJSON { (response) in
                NVActivityIndicatorViewable.hide()
                
                guard let myData = response.value else {
                    failure(response.error!)
                    return
                }
                success(myData as! [String:Any])
                
            }
        }
        else{
            netConn("No internet connection")
            //controller.makeToast(toastMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            //Miscellaneous.APPDELEGATE.window!.makeToast(myMessages.INTERNET_CONNECTIVITY_FAIL)
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : Parameters, loaderType: Int, controller: UIViewController, encode: ParameterEncoding, headers : HTTPHeaders, success:@escaping ([String:Any]) -> Void, failure:@escaping (Error) -> Void, netConn:@escaping (String) -> Void){
        
        let myURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if Reachability.isConnectedToNetwork() {
            switch(loaderType) {
            case 1:
                NVActivityIndicatorViewable.show(myView: controller.view)
                break
            case 2:
                break
            default:
                NVActivityIndicatorViewable.show(myView: controller.view)
                break
            }
            AF.request(myURL!, method: .post, parameters: params, encoding: encode, headers: headers).responseJSON { (response) in
                NVActivityIndicatorViewable.hide()
                
                guard let myData = response.value else {
                    failure(response.error!)
                    return
                }
                success(myData as! [String:Any])
            }
        }
        else{
            netConn("No internet connection")
            //controller.makeToast(toastMessage: myMessages.INTERNET_CONNECTIVITY_FAIL)
            //Miscellaneous.APPDELEGATE.window!.makeToast(myMessages.INTERNET_CONNECTIVITY_FAIL)
        }
    }
    
    
    
}
func addIndicator(_ controller: UIViewController) {
    UIApplication.shared.beginIgnoringInteractionEvents()
    ImageViewGif.frame = CGRect(x: (controller.view.frame.size.width/2) - 25, y: (controller.view.frame.size.height/2) - 25, width: 50, height: 50)
    ImageViewGif.loadGif(name : "Loader")
    controller.view.addSubview(ImageViewGif)
    
}
func removeIndicator() {
    UIApplication.shared.endIgnoringInteractionEvents()
    ImageViewGif.removeFromSuperview()
}
