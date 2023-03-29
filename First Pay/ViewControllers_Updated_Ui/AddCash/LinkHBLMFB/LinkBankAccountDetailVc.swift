//
//  LinkBankAccountDetailVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class LinkBankAccountDetailVc: BaseClassVC, UITextFieldDelegate {
    var genericresponseObj : otpVerificationModel?
    var accountList = [CbsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldMobileNo.delegate = self
        buttonback.setTitle("", for: .normal)
       
        buttonContinue.isUserInteractionEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imgNext.addGestureRecognizer(tapGestureRecognizer)
       
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    
    
    @IBAction func textFieldMobileNo(_ sender: UITextField) {
        if textFieldMobileNo?.text?.count == 11
        {
            imgNext.image = UIImage(named: "]greenarrow")
            buttonContinue.isUserInteractionEnabled = true
            
        }
        else
        {
            imgNext.image = UIImage(named: "grayArrowrrow")
            buttonContinue.isUserInteractionEnabled = false

        }
        
        
    }
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        sendOtpForLinkAccount()
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        sendOtpForLinkAccount()
    }
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var textFieldMobileNo: UITextField!
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == textFieldMobileNo {
            
            return newLength <= 11 // Bool
        }
        else {
            
            return newLength <= 11
        }
    }
    
    // MARK: - API CALL
    
    private func sendOtpForLinkAccount() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/sendOtpForLinkAccount"
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"mobileNo":textFieldMobileNo.text!]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let error: Error!
        
        let sessionManger = APIs.shared.sessionManger(timeOut: 410)
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()


//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<otpVerificationModel, AFError>) in
            
            
            self.hideActivityIndicator()
            
            //let forecasts = Mapper<otpVerificationModel>().mapArray(JSONObject: response.result)
            
            let forecasts = Mapper<otpVerificationModel>().map(JSONObject: response.result)
//            self.genericresponseObj = response.result
            self.genericresponseObj = forecasts

            
            if response.response?.statusCode == 200 {
                
                if self.genericresponseObj?.responsecode == 2 || self.genericresponseObj?.responsecode == 1 {
                    GlobalData.otpRequired = self.genericresponseObj?.data?.oTPREQ
                
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkBankAccountOTPVerificationVc") as! LinkBankAccountOTPVerificationVc
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                else {
                    if let messsage = self.genericresponseObj?.messages{
                        UtilManager.showToast(message: messsage)
                        self.showToast(title: messsage)
                        
                    }
                    
                }
            }
            else {
                if let messsage = self.genericresponseObj?.messages{
                    self.showToast(title: messsage)
                    UtilManager.showToast(message: messsage)
                    
                }
                print(response.result)
                print(response.response?.statusCode)
                
            }
        }
    }
    
    
}
