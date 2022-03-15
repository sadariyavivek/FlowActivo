//
//  CoreImagePickerOption.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 25/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum BTImagePickerOption:Int {
    case
    camera,
    savedPhotosAlbum,
    photoLibrary,
    askForOption
    
    var name:String {
        switch self {
        case .photoLibrary:
            return "Photo Library".localized
        case .camera:
            return "Camera".localized
        case .savedPhotosAlbum:
            return "Saved Photos Album".localized
        case .askForOption:
            return "Ask for option".localized
        }
    }
}

class CoreImagePickerOption: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- PROPERTIES
    var blockCompletion:((_ isCancelled:Bool,_ pickedImage:UIImage?) -> Void)?
    var option:BTImagePickerOption = .photoLibrary
    
    private var image: UIImage?
    // MARK: - SHARED MANAGER
    static let shared = CoreImagePickerOption()
    
    //MARK:- SHOW IMAGE PICKER
    
    func showImagePickerFrom(vc:UIViewController, withOption option:BTImagePickerOption, andCompletion completion:@escaping ((_ isCancelled:Bool,_ pickedImage:UIImage?) -> Void)) {
        self.blockCompletion = completion
        if(option == .askForOption) {
            let options:[String] = [BTImagePickerOption.camera.name,
                                    //BTImagePickerOption.savedPhotosAlbum.name,
                                    BTImagePickerOption.photoLibrary.name]
            CustomAlertController.showActionSheet(forTitle: "Choose Option".localized, message: "", sender: vc, withActionTitles: options) { (index) in
                if(index == options.count) {
                    if(self.blockCompletion != nil) {
                        self.blockCompletion!(false, nil)
                    }
                    return
                }
                self.option = BTImagePickerOption(rawValue: index)!
                self.checkPermissionAndProceedFurther(vc: vc)
            }
        } else {
            self.option = option
            checkPermissionAndProceedFurther(vc: vc)
        }
    }
    
    func checkPermissionAndProceedFurther(vc:UIViewController) {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        var strMessage = ""
        switch cameraAuthorizationStatus {
        case .denied:
            strMessage = "image : denied"
        case .authorized:
            strMessage = "image : authorized"
        case .restricted:
            strMessage = "image : restricted"
        case .notDetermined:
            strMessage = "image : notDetermined"
        @unknown default:
            break
        }
        print("IMAGE PERMISSION : \(strMessage)")
        if(cameraAuthorizationStatus == .authorized) {
            takeOrSelectPhotoFrom(vc: vc)
        } else {
            var shouldAlertForGoToSetting:Bool = false
            if(cameraAuthorizationStatus == .notDetermined) {
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    if granted {
                        print("Granted access to \(cameraMediaType)")
                        self.takeOrSelectPhotoFrom(vc: vc)
                    } else {
                        print("Denied access to \(cameraMediaType)")
                        shouldAlertForGoToSetting = true
                    }
                }
            } else {
                shouldAlertForGoToSetting = true
            }
            if(shouldAlertForGoToSetting) {
                CustomAlertController.showAlertWithOk(forTitle: "Essentials", message: "App needs permission to take photo from your library, go to settings and allow access".localized, sender: vc) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }
    }
    
    private func takeOrSelectPhotoFrom(vc:UIViewController) {
        if self.option == .camera {
            if !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                CustomAlertController.showAlertWithOk(forTitle: "Essentials", message: "Device is not compatible for the required operation".localized, sender: self) {
                    if(self.blockCompletion != nil){
                        self.blockCompletion!(false, nil)
                    }
                }
                return
            }
        }
        self.delegate = self
        self.allowsEditing = true
        switch self.option {
        case .photoLibrary:
            self.sourceType = .photoLibrary
        case .savedPhotosAlbum:
            self.sourceType = .savedPhotosAlbum
        case .camera:
            self.sourceType = .camera
        default:
            break
        }        
        if(UIImagePickerController.isSourceTypeAvailable(self.sourceType)) {
            self.modalPresentationStyle = .fullScreen
            vc.present(self, animated: true) {
            }
        } else {
            CustomAlertController.showAlertWithOk(forTitle: "Essentials", message: "Device is not compatible for the required operation".localized, sender: self) {
                if(self.blockCompletion != nil){
                    self.blockCompletion!(false, nil)
                }
            }
        }
    }
    
    //MARK:- DELEGATE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if(self.blockCompletion != nil) {
            self.blockCompletion!(true, selectedImage)
        }
        dismiss(animated: true) {  }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if(self.blockCompletion != nil){
            self.blockCompletion!(false, nil)
        }
        dismiss(animated: true)
    }
}
