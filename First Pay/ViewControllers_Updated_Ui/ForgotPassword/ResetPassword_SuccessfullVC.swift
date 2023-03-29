//
//  ResetPassword_SuccessfullVC.swift
//  First Pay
//
//  Created by Irum Butt on 14/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import PasswordTextField
import RNCryptor
class ResetPassword_SuccessfullVC: BaseClassVC , UITextFieldDelegate  {
    var customerID : Int?
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    var setLoginPinObj : setLoginPinModel?
    var mainTitle: String?
    var MobNo : String?
    var genericResponseObj : GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        getIMEI()
        getIPAddresss()
        Alert_view.isHidden = true
        blur_view.isHidden = true
        blur_view.alpha = 0.4
        enterPinTextField.delegate = self
        enterConfirmPinTextField.delegate = self
        enterPinTextField.isUserInteractionEnabled = true
        enterConfirmPinTextField.isUserInteractionEnabled = true
        self.lblMainTitle.text = "Reset Password"
        ConvertLanguage()
        lbl1.text = "Password must contain atleast 1 Upper case,numeric and special character."
        
        lbl1.textColor = UIColor.gray
        btnnext.isUserInteractionEnabled = true

        
    }
    @IBOutlet weak var Alert_view: UIView!
    @IBOutlet weak var Main_View: UIView!
    
    @IBOutlet weak var btn_next_arrow: UIButton!
    @IBOutlet weak var enterPinTextField: PasswordTextField!
    @IBOutlet weak var enterConfirmPinTextField: PasswordTextField!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    
    
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var blur_view: UIVisualEffectView!
    @IBAction func Action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_next(_ sender: UIButton) {
        if enterPinTextField.text?.count == 0 {
            UtilManager.showAlertMessage(message: "password should be Alpha Numeric", viewController: self)
        }
        
        if enterConfirmPinTextField.text?.count == 0{
            UtilManager.showAlertMessage(message: "password should be Alpha Numeric", viewController: self)
        }
        if enterPinTextField.text != enterConfirmPinTextField.text! {
//            lbl4.textColor = UIColor.red
            UtilManager.showAlertMessage(message:"Password and Confirm Password not match" , viewController: self)
            return
        }
        
        if isValidPassword() == true
        {
            movetonext()

        }

            
    }
    
    
    @IBAction func Action_loginAgain(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login_VC")
        self.navigationController?.pushViewController(vc, animated: true)
//
        
    }
    
    
    @IBAction func Action_Cancel(_ sender: UIButton) {
        
    
        Alert_view.isHidden = true
        blur_view.isHidden = true
    }
    
        func ConvertLanguage()
        {
//        lblMainTitle.text = "Reset Password".addLocalizableString(languageCode: languageCode)
//        enterPinTextField.placeholder = "Enter New Passord".addLocalizableString(languageCode: languageCode)
//        enterConfirmPinTextField.placeholder = "Confirm password".addLocalizableString(languageCode: languageCode)
        
          
    }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField ==  enterPinTextField
            {
                enterConfirmPinTextField.text = ""
                     
            }
            }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField ==  enterPinTextField
            {
                if enterPinTextField.text?.count ?? 0 < 6
                {
                    
                    lbl1.textColor = UIColor(hexValue: 0xFF3932)
                   
                    if isValidPassword() == true
                        
                    {
                        print("test", enterPinTextField.text)
                        print("test2", enterConfirmPinTextField.text)
                    }
                    else{
//                        lbl1.textColor = UIColor(red: -0/255.0, green: 204/255.0, blue: 150/255.0, alpha: 1.0)
                    }
//
                if isValidPassword() == true
                        {
                    lbl1.textColor = UIColor(hexValue : 0x00CC96)
                    
                }
                   else
                        {
                       lbl1.textColor = UIColor(hexValue: 0xFF3932)
                       
                       
                   }
                        
                       
                    
                    print("test", enterPinTextField.text)
                    print("test2", enterConfirmPinTextField.text)
                    }
                    
                }
    
            
            
            
            if textField == self.enterPinTextField {
                if range.length + range.location > (textField.text?.count)! {
                    return false
                }
                let newLength:Int = (textField.text?.count)! + string.count - range.length
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let numberRegEx  = ".*[0-9]+.*"
                let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
                let numberresult = texttest1.evaluate(with: newString)
                print("\(numberresult)")
                
                if isValidPassword() == true{
                  print("doneee")
                }
              
                else{

                    print("not done")
                    if enterPinTextField.text == enterConfirmPinTextField.text{
//
//                    lbl4.textColor = UIColor.green
                }
                else
                {
                    
//                    lbl4.textColor = UIColor.red
    //
                }
                    
                }
               
                if  numberresult == true /*&& newString.count == 6*/{
    //                callSubmit = true
                   
    //
                }
                else {
    //                callSubmit = false
    //
                }
                
            }
            
            let newLength:Int = (textField.text?.count)! + string.count - range.length
            
            if textField == enterPinTextField{
                return newLength <= 6
            }
            if textField == enterConfirmPinTextField{
                return newLength <= 6
            }
            return newLength <= 6
    //        lbl1.textColor = UIColor.green
            
      }
      
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if textField == enterPinTextField {
                enterConfirmPinTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
            } else if textField == enterConfirmPinTextField {
                textField.resignFirstResponder()
                if isValidPassword() == true{
                  
                }
                
            }
      
            if enterPinTextField.text == enterConfirmPinTextField.text{
                let image  = UIImage(named: "]greenarrow")
                lbl1.textColor = UIColor(hexValue : 0x00CC96)
                
                btn_next_arrow.setImage(image, for: .normal)
                btnnext.isUserInteractionEnabled = true
//                lbl4.textColor = UIColor.green
            }
            else if enterPinTextField.text != enterConfirmPinTextField.text
            {
                 lbl1.textColor = UIColor(hexValue: 0xFF3932)
                let image = UIImage(named: "grayArrow")
                btn_next_arrow.setImage(image, for: .normal)
                btnnext.isUserInteractionEnabled = false
            }
         
            
        }
      
        func isValidPassword() -> Bool {
            // least one uppercase,
            // least one digit
            // least one lowercase
            // least one symbol
            //  min 6 characters total
            let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: enterPinTextField.text!)
        }
        
    func getIPAddresss(){
        
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
        
    }

        func movetonext()
                         {
                             print("doneeeeees")
                             setLoginPin()
//                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
//                             self.navigationController?.pushViewController(vc, animated: true)
            
                             
            }
    private func setLoginPin() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        if (enterPinTextField.text?.isEmpty)!{
            enterPinTextField = nil
        }
        if (enterConfirmPinTextField.text?.isEmpty)!{
            enterConfirmPinTextField.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/resetLoginPin"

        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo": MobNo! ,"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)", "cnic": DataManager.instance.userCnic!, "loginPin": enterConfirmPinTextField.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<setLoginPinModel>) in
  
            self.hideActivityIndicator()
            self.setLoginPinObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.setLoginPinObj?.responsecode == 2 || self.setLoginPinObj?.responsecode == 1 {
                    self.Alert_view.isHidden = false
                    self.blur_view.isHidden = false
                  

                }
                else {
                    
                    if let message = self.setLoginPinObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    
                    // Html Parse
                    
                    if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                        if title.contains("Request Rejected") {
                            self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                        }
                    }
                }
            }
            else {
                if let message = self.setLoginPinObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                else {
                    self.showDefaultAlert(title: "", message: "\(response.response?.statusCode ?? 500)")
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    var viaBio : Bool = false
    var loginObj : LoginActionModel?
    
    
    func login()
    {
    self.showActivityIndicator()
    if !NetworkConnectivity.isConnectedToInternet(){
        self.showToast(title: "No Internet Available")
        return
    }
        
    
    
    var pessi : String?
    var userCnic : String?
    
//        let compelteUrl = GlobalConstants.BASE_URL + "login"
    let compelteUrl = GlobalConstants.BASE_URL + "v2/login"
    
            
    if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
        pessi = KeychainWrapper.standard.string(forKey: "userKey")
    }
    else if let password = self.enterPinTextField.text{
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

    let parameters = ["cnic":userCnic!,"loginPin":pessi!,"imeiNo":DataManager.instance.imei!,"ipAddress":DataManager.instance.ipAddress!,"channelId":"\(DataManager.instance.channelID)","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "")"]
   
    print(parameters)
    
    let result = splitString(stringToSplit: base64EncodedString(params: parameters))

    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
       let header = ["Content-Type":"application/json","Authorization":DataManager.instance.AuthToken]
    
    
    print(params)
    print(compelteUrl)
    NetworkManager.sharedInstance.enableCertificatePinning()
    
    NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
//            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
           
        self.loginObj = response.result.value

        if response.response?.statusCode == 200 {
            self.hideActivityIndicator()
            self.loginObj = response.result.value
            if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
                if self.loginObj?.userData?.customerHomeScreens?[0].riskProfile == "Y"{
//                   let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "RiskProfileVC") as! RiskProfileVC
//                    
//                     if let accessToken = self.loginObj?.userData?.token{
//                        DataManager.instance.accessToken = accessToken
//                        DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
//                        DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
//                        print("\(accessToken)")
//                     }
//                    self.navigationController!.pushViewController(createWalletVC, animated: true)
                }

//
            else{
                
             
                
                 if let accessToken = self.loginObj?.userData?.token{
                    DataManager.instance.accessToken = accessToken
                    DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
                    DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
                    print("\(accessToken)")
                     if let passKey = self.enterPinTextField.text{
                        let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
                        print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                    }
                    self.saveInDataManager()
                }
                    else {
             
                if let message = self.loginObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                // Html Parse
                
                if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                    if title.contains("Request Rejected") {
                        self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                    }
                }
            }
        
        }
    }
        else {
        
                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
//                print(response.result.value)
//                print(response.response?.statusCode)
        }
  
}
}
}
    func AccessTokenEncrypt(plaintext : String , password : String) -> String
       {
           let data: Data = plaintext.data(using: .utf8)!
           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
           let encryptedstring : String = encryptedData.base64EncodedString()
           print("encryptedstring",encryptedstring)
        DataManager.AccessToken = encryptedstring
           print(DataManager.AccessToken)
           return encryptedstring
        
       }
    private func saveInDataManager(){
      
               
               
                AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
                print(self.loginObj?.userData?.token)
        
        
        
        
        if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread

                }
            }
            task.resume()
        }
        var accountName : String?
        if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
            accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
            DataManager.instance.accountTitle = accountName
        }
        DataManager.instance.nanoloan = self.loginObj?.userData?.customerHomeScreens?[0].nanoloan! ?? ""
        print("nanoloan is :" , self.loginObj?.userData?.customerHomeScreens?[0].nanoloan)
        DataManager.instance.riskprofile = self.loginObj?.userData?.customerHomeScreens?[0].riskProfile ?? ""
        self.navigateToHome()
        
    }
private func navigateToHome(){
   
    
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC")
    self.present(vc, animated: true)
     
//    let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//    print("success auto login")
//   self.navigationController!.pushViewController(HomeVC, animated: true)
    
}
    
    
    
    
}
