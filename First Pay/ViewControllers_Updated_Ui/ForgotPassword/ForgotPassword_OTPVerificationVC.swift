//
//  ForgotPassword_OTPVerificationVC.swift
//  First Pay
//
//  Created by Irum Butt on 14/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import OTPTextField
class ForgotPassword_OTPVerificationVC: BaseClassVC ,UITextFieldDelegate {
    var totalSecond = 60
    var ForTransactionConsent:Bool = false
    var timer = Timer()
    var counter = 0
    var count = 0
    var verifyOtpObj : VerifyOTP?
    var mothrnameobj: GetVerifyOTp?
    var Fetch_MobNo : String?
    var genResponseObj : GenericResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("fetch successfully mob no", Fetch_MobNo)
        lblMobNo.text = Fetch_MobNo
        TF_otp.delegate = self
        btnVerify.isUserInteractionEnabled = false
        btnResendOtp.isUserInteractionEnabled = false
        btnResendotpCall.isHidden = true
        startTimer()
        back.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        IMG_NEXT_ARROW.isUserInteractionEnabled = true
        IMG_NEXT_ARROW.addGestureRecognizer(tapGestureRecognizerr)
        getIMEI()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblMobNo: UILabel!
    @IBOutlet weak var IMG_NEXT_ARROW: UIImageView!
    @IBOutlet weak var lbl_countResendotptime: UILabel!
    @IBOutlet weak var Main_view: UIView!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var TF_otp: OTPTextField!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnResendotpCall: UIButton!
    //    -------------------------------
    @IBAction func Action_ResendOTP(_ sender: UIButton) {
//    showToast(title: "OTP send")
    btnResendOtp.isUserInteractionEnabled = false
        btnResendOtp.setTitleColor(.gray ,for: .normal)
        
    startTimer()
    }
    
    @IBAction func Action_OTPcall(_ sender: UIButton) {
//        showToast(title: "OTP send via Call")
        startTimer()
//        OTVCall()
    }
    
    @objc func timerAction() {
             counter += 1
             lbl_countResendotptime.text = "\(counter)"
         }
    func startTimer() {
        totalSecond = 60
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lbl_countResendotptime.text = "\(self.timeFormatted(self.totalSecond))s"
        print(timeFormatted(totalSecond))
        
        if totalSecond < 1  {
            endTimer()
            
        } else {
            
            totalSecond -= 1
    
//            endTimer()
            
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
      

        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }
    
    
    
    @IBAction func Action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)    }
    @IBOutlet weak var back: UIButton!
    func endTimer()
    {
        btnResendOtp.isUserInteractionEnabled = true
        count +=  1
        btnResendOtp.setTitleColor(.black, for: .normal)
        timer.invalidate()
        if count < 3
        {
//            btnResendOtp.isHidden = true
//            resendopt
        }
        else{
           btnResendOtp.isHidden = true
           btnResendotpCall.isHidden = false
//
            
        }
        
       
//
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == TF_otp
        {
            TF_otp.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return newLength <= 4
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let image  = UIImage(named: "]greenarrow")
        IMG_NEXT_ARROW.image = image
        btnVerify.isUserInteractionEnabled = true
        
    }
    
    @IBAction func Action_Verify(_ sender: UIButton) {
        if TF_otp.text?.count == 0
        {
            showToast(title: "Please Enter OTP")
        }
//        if DataManager.instance.forgotPassword == true || DataManager.instance.registerNewDevice == true {
//            self.verifyOTPCallForRegForgot()
//        }
//        else if ForTransactionConsent == true {
////            self.saveConsent()
//        }
        else{
            verifyOtpResetPass()
//            let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "ResetPassword_SuccessfullVC") as! ResetPassword_SuccessfullVC
//
//            self.navigationController!.pushViewController(enterPinVC, animated: true)

        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        verifyOtpResetPass()
    }
    
    private func verifyOtpResetPass() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        var otpType : String?

        
        if (TF_otp.text?.isEmpty)! {
            TF_otp.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/verifyOtpResetPass"
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
//        {"osVersion": "15.5", "appVersion": "3.1.2", "deviceModel": "iPhone", "channelId": "1", "mobileNo": "03406401050", "imeiNo": "B0749FED5A5D48A38C9DBFF01F4A5663", "cnic": "3740526510394", "otpin": "4231"}
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":DataManager.instance.userCnic!,"mobileNo":(Fetch_MobNo!),"imeiNo":DataManager.instance.imei!,"appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel, "otpin": TF_otp.text!] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        
        print(params)
        print(compelteUrl)
        
       
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in
            
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    
                    if self.genResponseObj?.messages == "OTP not verified"
                    {
                        self.showToast(title: (self.genResponseObj?.messages)!)
                    }
                    
                    else{
                        let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "ResetPassword_SuccessfullVC") as! ResetPassword_SuccessfullVC
                        if let cnic = DataManager.instance.userCnic {
                            let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                            print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
//                        }
                            enterPinVC.MobNo  = self.Fetch_MobNo!
                        
                        //custAllID
                        self.navigationController!.pushViewController(enterPinVC, animated: true)
                    }
                        
                    }
                }
                
                else {
                    if let message = self.genResponseObj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.genResponseObj?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
//    private func saveConsent() {
//
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//
//        showActivityIndicator()
//
//        var userCnic : String?
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//
//
//        let compelteUrl = GlobalConstants.BASE_URL + "saveTransConsents"
//
//         let parameters = ["transaction":"IBFT","channel":"MOBAPP","status":"Y","otp":self.TF_otp.text!,"cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)"]
//
//        print(parameters)
//
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken ?? "nil")"]
//
//        print(params)
//        print(compelteUrl)
//        print(header)
//
//        NetworkManager.sharedInstance.enableCertificatePinning()
//
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
//
//            self.hideActivityIndicator()
//
//            self.genResponseObj = response.result.value
//            if response.response?.statusCode == 200 {
//
//                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                else {
//                    if let message = self.genResponseObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
//                }
//            }
//            else {
//                if let message = self.genResponseObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
////                print(response.result.value)
////                print(response.response?.statusCode)
//            }
//        }
//    }
    
//    private func verifyOTPCall() {
//
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        showActivityIndicator()
//
//        if (TF_otp.text?.isEmpty)! {
//            TF_otp.text = ""
//        }
//
////
//
//
//
//        let compelteUrl = GlobalConstants.BASE_URL + "otpBioVerification"
//
//        let parameters = ["channelId":"\(DataManager.instance.channelID)","mobileNo":DataManager.instance.mobile_number!,"otpin":TF_otp.text!,"cnic":DataManager.instance.userCnic!,"issueDate": DataManager.instance.cnicIssueDate!,"imeiNo": DataManager.instance.imei!]
//
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//        print(parameters)
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//
//
//         print(params)
//        print(compelteUrl)
//
//            NetworkManager.sharedInstance.enableCertificatePinning()
//
//         NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GetVerifyOTp>) in
//
//
//     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
//
//             self.hideActivityIndicator()
//
//            self.mothrnameobj = response.result.value
//            if response.response?.statusCode == 200 {
//                if self.mothrnameobj?.responsecode == 2 || self.mothrnameobj?.responsecode == 1 {
//
//                    self.showToast(title: (self.mothrnameobj?.messages)!)
//
//                    if let cnic = DataManager.instance.userCnic {
//                        let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
//                        print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
//                    }
//                    if  mothrnameobj?.datalist != nil {
//                        let temp = my_list()
//                          temp.firstname = mothrnameobj?.datalist.firstName ?? ""
//                        temp.mddlname = mothrnameobj?.datalist.middleName ?? ""
//                      temp.lstname = mothrnameobj?.datalist.lastName ?? ""
//                        if mothrnameobj?.datalist.motherNamesList?.count ?? 0 > 0 {
//                            let motherNameList = mothrnameobj?.datalist.motherNamesList!
//                            for tempName in motherNameList! {
//                                temp.mothrname.append(tempName)
//                            }
//                        }
//                        my_arry.append(temp)
//                    }
//
//                    let personalDataVC = self.storyboard!.instantiateViewController(withIdentifier: "PersonalDataVC") as! PersonalDataVC
//                    personalDataVC.my_arry2 = self.my_arry
//                    self.navigationController?.pushViewController(personalDataVC, animated: true)
//                }
//                else {
//                    if let message = self.mothrnameobj?.messages {
//                        self.showAlert(title: "", message: message, completion: nil)
//                    }
//                }
//            }
//            else {
//                if let message = self.mothrnameobj?.messages {
//                    self.showAlert(title: "", message: message, completion: nil)
//                }
////                print(response.result.value)
////                print(response.response?.statusCode)
//
//            }
//        }
//    }
    
}
