//
//  LinkBankAccountOTPVerificationVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import OTPTextField
import Alamofire
import ObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
class LinkBankAccountOTPVerificationVc: BaseClassVC ,UITextFieldDelegate  {
    var totalSecond = 60
    var ForTransactionConsent:Bool = false
    var timer = Timer()
    var counter = 0
    var count = 0
    var verifyOtpObj : VerifyOTP?
    var mothrnameobj: GetVerifyOTp?
    var Fetch_MobNo : String?
    var genResponseObj : GenericResponseModel?
    var fundsTransSuccessObj: FundsTransferApiResponse?
    var TotalAmount : String?
    var userAccountNo : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        otptextField.delegate = self
        buttonBack.setTitle("", for: .normal)
        labelMobNo.text = DataManager.instance.accountNo
        
        buttonResendOtP.setTitle("", for: .normal)
        buttonResendOtVCall.setTitle("", for: .normal)
        buttonNext.setTitle("", for: .normal)
        buttonNext.isUserInteractionEnabled = false
        buttonCoontinue.isUserInteractionEnabled = false
        startTimer()
        getIMEI()
        // Do any additional setup after loading the view.
    }
    @objc func timerAction() {
             counter += 1
             labelCount.text = "\(counter)"
         }
    func startTimer() {
        totalSecond = 60
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.labelCount.text = "\(self.timeFormatted(self.totalSecond))s"
        print(timeFormatted(totalSecond))
        
        if totalSecond < 1  {
            endTimer()
            
        } else {
            
            totalSecond -= 1
    
//            endTimer()
            
        }
    }
    func endTimer()
    {
        buttonResendOtP.isUserInteractionEnabled = true
        count +=  1
        buttonResendOtP.setTitleColor(.black, for: .normal)
        timer.invalidate()
        if count < 3
        {
//            btnResendOtp.isHidden = true
//            resendopt
        }
        else{
//            buttonResendOtP.isHidden = true
           buttonResendOtVCall.isHidden = false
//
            
        }
        
       
//
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == otptextField
        {
            otptextField.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return newLength <= 4
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let image  = UIImage(named: "]greenarrow")
        buttonNext.setImage(image, for: .normal)
        buttonCoontinue.isUserInteractionEnabled = true
        buttonNext.isUserInteractionEnabled = true
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
      

        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }
    
    
    @IBOutlet weak var buttonBack: UIButton!
  
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       
    }
    @IBAction func otptextField(_ sender: OTPTextField) {
        if otptextField?.text?.count == 4
        {
            buttonNext.setImage(UIImage(named: "]greenarrow"), for: .normal)
            buttonNext.isUserInteractionEnabled = true
            buttonCoontinue.isUserInteractionEnabled = true
                   }
        else
        {
                buttonNext.setImage(UIImage(named: "grayArrow"), for: .normal)
                buttonNext.isUserInteractionEnabled = false
                buttonCoontinue.isUserInteractionEnabled = false
            
            
        }
        
    }
    
    @IBOutlet weak var otptextField: OTPTextField!
    @IBOutlet weak var labelMobNo: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonCoontinue: UIButton!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var buttonResendOtP: UIButton!
    @IBAction func buttonResendOtP(_ sender: UIButton) {
    }
    @IBOutlet weak var buttonResendOtVCall: UIButton!
    @IBAction func buttonResendOtVCall(_ sender: UIButton) {
    }
    
    @IBAction func buttonCoontinue(_ sender: UIButton) {
        if isfromPullFund == true{
            addCashFT()
//           api calling
           
        }
        else{
            
            verifyOtpResetPass()
        }
    }
    private func verifyOtpResetPass() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        var otpType : String?

        
        if (otptextField.text?.isEmpty)! {
            otptextField.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/linkAccount"
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"mobileNo":(DataManager.instance.accountNo!),"imei":DataManager.instance.imei!,"accountNo":DataManager.instance.accountNo!,"otpRequired": GlobalData.otpRequired! ,"otp": otptextField.text!,"accountType": DataManager.instance.accountType! ,"accountTitle": DataManager.instance.accountTitle!,"branchCode": GlobalData.branchCode!
                          ,"branchName": GlobalData.branchName!] as [String : Any]
        
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in
            
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "POPUPSuccessfullVc") as! POPUPSuccessfullVc
                    self.navigationController?.pushViewController(vc, animated: true)
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
    private func addCashFT() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        var requestMoneyId : String?
        
        if let iD = DataManager.instance.requesterMoneyId {
            requestMoneyId = iD
        }
        else{
            requestMoneyId = ""
        }
//        if addBeneValue == "N"{
//            self.nickNameTextField.text = ""
//        }
//
        
        showActivityIndicator()
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferLocal"
        
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/addCashFT"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"narration":"","cnic":userCnic!,"accountNo":GlobalData.userAcc!,"amount":TotalAmount!,"transPurpose":"miscellaneous","accountTitle": DataManager.instance.accountTitle!,"transactionType":"PULL","otp":otptextField.text!] as [String : Any]
 
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundsTransferApiResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.fundsTransSuccessObj = response.result.value
            if response.response?.statusCode == 200 {

                if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                    self.movetonext()
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showToast(title: message)
//                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.messages ?? "") ")
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    self.showToast(title: message)
//                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
   func movetonext()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransactionSuccessfullVc") as! TransactionSuccessfullVc
    
        vc.transactionAmount = TotalAmount
        vc.transactionId = fundsTransSuccessObj?.data?.authIdResponse
        vc.transactionType = "Add Cash Linked Account"
        vc.beneficiaryAccount = GlobalData.userAcc
        vc.sourceAccount = DataManager.instance.accountNo!
        vc.dateTime = fundsTransSuccessObj?.data?.transDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
