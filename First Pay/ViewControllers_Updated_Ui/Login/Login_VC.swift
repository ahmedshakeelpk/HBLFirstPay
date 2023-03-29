//
//  Login_VC.swift
//  First Pay
//
//  Created by Irum Butt on 11/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
import ObjectMapper
import MapKit
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import CryptoSwift
import RNCryptor
import PasswordTextField
import CoreLocation
import OneSignal
class Login_VC: BaseClassVC, UITextFieldDelegate  {
    var homeObj : HomeModel?
 var concateString = ""
 var ecn = ""
 let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    var viaBio : Bool = false
    var loginObj : login?
    var flag :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_InvalidPassword.isHidden = true
        pinTextField.delegate = self
        show_text.setTitle("", for: .normal)
//        pinTextField.resignFirstResponder()
        pinTextField.keyboardType = .namePhonePad
        self.hideKeyboardWhenTappedAround()
        pinTextField.isSecureTextEntry = true
        getIMEI()
        getIPAddressmac()
       
        self.pinTextField.addDoneButtonOnKeyboardWithAction { [self] in
            self.loginAction()
            self.pinTextField.resignFirstResponder()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
  
//    --------------------
//    outlets
//    --------------------
    @IBOutlet weak var btnTouchId: UIButton!
    @IBOutlet weak var btnFaceiD: UIButton!
    @IBOutlet weak var lbl_InvalidPassword: UILabel!
    @IBOutlet weak var pinTextField: PasswordTextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var show_text: UIButton!
    
    @IBAction func Show_Passowrd(_ sender: UIButton) {
        flag = true
         if flag == false
        {
            pinTextField.isSecureTextEntry  = true
        }
        else
        {
            pinTextField.isSecureTextEntry  = false
        }
        
    }
    
    @IBAction func loginActionviaTouchID(_ sender: UIButton) {
        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true {
            self.authenticateUserViaTouchID()
            viaBio = true
            print("true")
        }
        else {
            self.showToast(title: "Please Enable TouchID/FaceID by logging in with your Password")
            print("false")
        }
    }
    
//    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
//       navigateToHome()
//    }
    
    @IBAction func forgotAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPassword_SetNewPassVC") 
        DataManager.instance.forgotPassword == true
//        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func getIPAddressmac(){
        
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
        getOneSignalUUIDD()
        
    }
   
    private func saveInDataManager(){
//        AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
//        print(self.loginObj?.userData?.token)

if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else { return }
        
        DispatchQueue.main.async { /// execute on main thread
//                    let pngImage =  UIImage(data: data)
//                    UserDefaults.standard.set(pngImage, forKey: "proImage")
        }
    }
    task.resume()
}
       
          self.navigateToHome()

}
    //MARK: - TextField Delegates
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if range.length + range.location > (textField.text?.count)!{
//            return false
//        }
//        let newLength:Int = (textField.text?.count)! + string.count - range.length
//        if pinTextField?.text?.count == 6 {
//            print("done", pinTextField.text)
//            print("pin count", pinTextField.text?.count)
//            self.loginAction()
////            self.navigateToHome()
//
//        }
//
//       return true
//    }
////
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if(textField == pinTextField){
                let characterCountLimit = 6
                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace = range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace
                print("count",newLength)
//                loginAction()
                return newLength <= characterCountLimit
//                navigateToHome()

            }
            return true
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if pinTextField?.text?.count == 6
        {
//              loginAction()
//            navigateToHome()
            
        }
        else{
            
        }
//            return true
    }
    
    func authenticateUserViaTouchID() {
        let touchIDManager = PITouchIDManager()
        touchIDManager.authenticateUser(success: { () -> () in
            OperationQueue.main.addOperation({ () -> Void in
                self.loginAction()
//                self.navigateToHome()
                
            })
        }, failure: { (evaluationError: NSError) -> () in
            switch evaluationError.code {
            case LAError.Code.systemCancel.rawValue:
                print("Authentication cancelled by the system")
                self.showToast(title: "Authentication cancelled by the system")
            case LAError.Code.userCancel.rawValue:
                print("Authentication cancelled by the user")
                self.viaBio = false
                self.showToast(title: "Authentication cancelled by the user")
            case LAError.Code.userFallback.rawValue:
                print("User wants to use a password")
                OperationQueue.main.addOperation({ () -> Void in
                })
            case LAError.Code.touchIDNotEnrolled.rawValue:
                print("TouchID not enrolled")
                self.showToast(title: "TouchID not enrolled")
            case LAError.Code.passcodeNotSet.rawValue:
                print("Passcode not set")
                self.showToast(title: "Passcode not set")
            default:
                print("Authentication failed")
                self.showToast(title: "Authentication failed")
                OperationQueue.main.addOperation({ () -> Void in
                })
            }
        })
    }
    
    
    @IBAction func textfieldPin(_ sender: PasswordTextField) {
        if pinTextField.text?.count == 6
        {
//            loginAction()
        }
    }
    private func navigateToHome()
    {
//     LoginChnaged
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }
    func getOneSignalUUIDD(){
         let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
         let hasPrompted = status.permissionStatus.hasPrompted
         print("hasPrompted = \(hasPrompted)")
         let userStatus = status.permissionStatus.status
         print("userStatus = \(userStatus)")
         let isSubscribed = status.subscriptionStatus.subscribed
         print("isSubscribed = \(isSubscribed)")
         let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
         print("userSubscri ptionSetting = \(userSubscriptionSetting)")
         let userID = status.subscriptionStatus.userId
         print("userID = \(userID)")
        DataManager.instance.userUUID = userID
         let pushToken = status.subscriptionStatus.pushToken
         print("pushToken = \(pushToken)")
     let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
                print("Received Notification - \(notification?.payload.notificationID) - \(notification?.payload.title)")
            }
     }
    func loginAction() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        var pessi : String?
        var userCnic : String?
        
//      let compelteUrl = GlobalConstants.BASE_URL + "v2/fundsTransferIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/login"
        
        if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
            pessi = KeychainWrapper.standard.string(forKey: "userKey")
        }
        else if let password = pinTextField.text {
            pessi = password
        }
        else{
            self.showDefaultAlert(title: "", message: "Please Use Password for first time Login after Registration")
            self.hideActivityIndicator()
            return
        }
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }

//userCnic!
//    "\(DataManager.instance.userCnic!)
//        mustChange
        guard let cnic = UserDefaults.standard.string(forKey: "userCnic")else {
            let parameters = ["cnic":   "\(DataManager.instance.userCnic!)","loginPin":"\(pessi!)","imeiNo":"\(DataManager.instance.imei!)","ipAddress":"\(DataManager.instance.ipAddress! )","channelId":"\(DataManager.instance.channelID )","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "e5f458f7-a1ad-4398-92ba-62c15a22738d")" ,"osVersion": "\(systemVersion ?? "")"]
            return
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["cnic":   userCnic!,"loginPin":"\(pessi!)","imeiNo":"\(DataManager.instance.imei!)","ipAddress":"\(DataManager.instance.ipAddress! )","channelId":"\(DataManager.instance.channelID )","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "e5f458f7-a1ad-4398-92ba-62c15a22738d")" ,"osVersion": "\(systemVersion ?? "")"]
//        testcase
        
//        GlobalData.lat = DataManager.instance.Latitude
//        GlobalData.long = DataManager.instance.Longitude
        print(parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
//        print(parameters)
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        

        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
          

        // longitude and latitude round off to 4 digits
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
        
        
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
//
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<login>) in
//            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
            self.hideActivityIndicator()
            self.loginObj = response.result.value
            if response.response?.statusCode == 200 {
                self.loginObj = response.result.value
                if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
                    if self.loginObj?.data != nil{
                        if let accessToken = self.loginObj?.data?.token{
                           DataManager.instance.accessToken = accessToken
                            DataManager.instance.accountType = self.loginObj?.data?.customerHomeScreens?[0].accountType
                           DataManager.instance.customerId = self.loginObj?.data?.customerHomeScreens?[0].customerId
                           print("\(accessToken)")
                           if let passKey = self.pinTextField.text{
                               let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
                               print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                           }
//                             DataManager.instance.accountTitle = self.loginObj?.data?.customerHomeScreens?[0].firstName
//                            DataManager.instance.accountNo = self.loginObj?.data?.customerHomeScreens?[0].accountNo
//                            DataManager.instance.currentBalance = Double((self.loginObj?.data?.customerHomeScreens?[0].currentBalance)!)
//                            DataManager.instance.balanceDate = self.loginObj?.data?.customerHomeScreens?[0].balanceDate
                           self.saveInDataManager()
                            
                       }
                    }
                }
                else{
                        if let message = self.loginObj?.messages{
                            self.lbl_InvalidPassword.isHidden = false
                            self.lbl_InvalidPassword.text = "Invalid Password Entered"
//                        self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
            else{
                self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
//                if let message = self.loginObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
            }
                print(response.result.value)
                print(response.response?.statusCode)
            }
}
}
extension Login_VC: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
    }
    func textFieldValueChanged(_ textField: PinCodeTextField) {
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        self.loginAction()
//        self.navigateToHome()
        
        return true
    }
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}

//    func Accountencrypy(plaintext : String , password : String) -> String
//    {
//        let data: Data = plaintext.data(using: .utf8)!
//        let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//        let encryptedstring : String = encryptedData.base64EncodedString()
//        print("encryptedstring",encryptedstring)
//        DataManager.AccountNo = encryptedstring
//
//        return encryptedstring
//
//
//    }
//    func FirstNameencrypy(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//           DataManager.FirstNAme = encryptedstring
//
//           return encryptedstring
//
//
//       }
//    func MiddleNameencrypy(plaintext : String , password : String) -> String
//          {
//              let data: Data = plaintext.data(using: .utf8)!
//              let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//              let encryptedstring : String = encryptedData.base64EncodedString()
//              print("encryptedstring",encryptedstring)
//              DataManager.MiddleName = encryptedstring
//
//              return encryptedstring
//
//
//    }
//    var AccountNoDecrypt = ""
//     func AccNodecrypt(encryptedText: String, password: String) -> String{
//            do{
//                let data: Data = Data(base64Encoded: encryptedText)!
//                let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
//                let decryptedString = String(data: decryptedData, encoding: .utf8)
//                print("decryptedString",decryptedString)
//             DataManager.AccountNo  = decryptedString!
//                return decryptedString ?? ""
//            }
//            catch{
//                return "Failed"
//            }
//        }
//
//    func LastNameencrypy(plaintext : String , password : String) -> String
//            {
//                let data: Data = plaintext.data(using: .utf8)!
//                let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                let encryptedstring : String = encryptedData.base64EncodedString()
//                print("encryptedstring",encryptedstring)
//                DataManager.LastName = encryptedstring
//
//                return encryptedstring
//
//
//            }
//    func AccountIdencrypy(plaintext : String , password : String) -> String
//                {
//                    let data: Data = plaintext.data(using: .utf8)!
//                    let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                    let encryptedstring : String = encryptedData.base64EncodedString()
//                    print("encryptedstring",encryptedstring)
//                    DataManager.AccountID  = encryptedstring
//
//                    return encryptedstring
//
//
//                }
//    func AccountAliasencrypy(plaintext : String , password : String) -> String
//                   {
//                       let data: Data = plaintext.data(using: .utf8)!
//                       let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                       let encryptedstring : String = encryptedData.base64EncodedString()
//                       print("encryptedstring",encryptedstring)
//                       DataManager.AccountAlias  = encryptedstring
//
//                       return encryptedstring
//
//
//                   }
//    func BalanceDateencrypy(plaintext : String , password : String) -> String
//                      {
//                          let data: Data = plaintext.data(using: .utf8)!
//                          let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                          let encryptedstring : String = encryptedData.base64EncodedString()
//                          print("encryptedstring",encryptedstring)
//                          DataManager.BalanceDate  = encryptedstring
//
//                          return encryptedstring
//
//
//                      }
//    func CurrentBalanceencrypy(plaintext : String , password : String) -> String
//                         {
//                             let data: Data = plaintext.data(using: .utf8)!
//                             let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                             let encryptedstring : String = encryptedData.base64EncodedString()
//                             print("encryptedstring",encryptedstring)
//                             DataManager.Currentbalanc  = encryptedstring
//
//                             return encryptedstring
//
//
//                         }
//
//    func CoustomerIDencrypy(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//           DataManager.coustomerID = encryptedstring
//
//           return encryptedstring
//
//       }
//
//
//    var AccesstokenAfterDecrypt = ""
//
//    func AccessTokenDecrypt(encryptedText: String, password: String) -> String{
//           do{
//               let data: Data = Data(base64Encoded: encryptedText)!
//               let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
//               let decryptedString = String(data: decryptedData, encoding: .utf8)
//               print("decryptedString",decryptedString)
//            AccesstokenAfterDecrypt = decryptedString!
//               return decryptedString ?? ""
//            print(AccesstokenAfterDecrypt)
//
//           }
//           catch{
//               return "Failed"
//           }
//
//
//       }
//    ------------------- Encrypt data save in datamanger--------
//    func lasttransamtEncrypt(plaintext : String , password : String) -> String
//       {
//
//        let data: Data = plaintext.data(using: .utf8)!
//        let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//        let encryptedstring : String = encryptedData.base64EncodedString()
//        print("encryptedstring",encryptedstring)
//        DataManager.lasttransamt = encryptedstring
//           return encryptedstring
//
//       }
//    func dailyamtlmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.dailyamtlmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func dailytranslmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.dailytranslmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func monthlyamtlmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.monthlyamtlmt = encryptedstring
//
//           return encryptedstring
//
//       }
//
//    func monthlytranslmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.monthlytranslmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func yearlyamtlmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.yearlyamtlmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func yearlytranslmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.yearlytranslmt = encryptedstring
//
//           return encryptedstring
//
//       }
//
//    func levelDescrEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.levelDescr = encryptedstring
//           return encryptedstring
//
//       }
//    func accountPicEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.accountPic = encryptedstring
//
//           return encryptedstring
//
//       }
//    func AccessTokenEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.AccessToken = encryptedstring
//           print(DataManager.AccessToken)
//           return encryptedstring
//
//       }
//
//    func encript(myvalue : String){
//              do {
//
//                  let message = myvalue
//
//                  let aes = try AES(key: "eBfArhcHpZe7jIqS", iv: "7829278610206212") // aes128
//                  let ciphertext = try aes.encrypt(Array(message.utf8))
//                  ecn = Data(ciphertext).base64EncodedString()
//
//                  print("-=-=- Encription -=-=-=")
//                  print("enc is",ecn)
//                DataManager.MiddleName = ecn
//                  print("-=-=- End -=-=-=")
//
//              } catch { }
//
//          }
//
