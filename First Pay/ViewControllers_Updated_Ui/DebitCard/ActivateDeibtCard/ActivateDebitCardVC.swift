//
//  ActivateDebitCardVC.swift
//  First Pay
//
//  Created by Irum Butt on 13/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
var accountDebitCardId : String?
class ActivateDebitCardVC: BaseClassVC {
//    var accountDebitCardId : String?
  
    var getDebitDetailsObj : GetDebitCardModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        button1.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
        button3.setTitle("", for: .normal)
//        view2.isHidden = true
//        view3.isHidden = true
        getDebitCard()
    }
   
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    
    @IBAction func button3(_ sender: UIButton) {
    }
    @IBAction func button2(_ sender: UIButton) {
    }
    @IBAction func button1(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as!  ActivationFourDigitNumberVc
        isFromDeactivate = false
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
   
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    private func getDebitCard() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getDebitCards"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<GetDebitCardModel>().map(JSONObject: response.result)
            self.getDebitDetailsObj = forecasts
                   self.hideActivityIndicator()
            
 //NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GetDebitCardModel>) in
            
            self.hideActivityIndicator()
            
//            self.getDebitDetailsObj = response.result.value
            print(self.getDebitDetailsObj)
        
            if response.response?.statusCode == 200 {
                
                if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                
                    for anObject in self.getDebitDetailsObj?.debitCardData! ?? []
                    {
                        if let name = anObject.debitCardTitle {
                            self.labelName.text = name
                        }
                        if let pan = anObject.pan {
                            self.labelCardNumber.text = pan
                        }
                        if let month = anObject.cardExpiryMonth {
                            if let year = anObject.cardExpiryYear{
                                self.labelDate.text = "\(month)" + "/\(year)"
                            }
                        }
                      
                        if let accountID = anObject.accountDebitCardId{
                            GlobalData.accountDebitCardId = Int(accountID)
            //                self.accountDebitCardId = "\(accountID)"
                        }
                    }
                  
                    self.updateUI()
                    
                }
                
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                      


                    }
                }
            }
            else {
//                if let message = self.genResponse?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                    self.movetonext()
//                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    private func debitCardVerificationCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getDebitCards"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<GetDebitCardModel>().map(JSONObject: response.result)
            self.getDebitDetailsObj = forecasts
        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetDebitCardModel>) in
            
            self.hideActivityIndicator()
            
//            self.getDebitDetailsObj = response.result.value
            print(self.getDebitDetailsObj)
        
            if response.response?.statusCode == 200 {
                
                if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                  
                
                   
                }
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                      

                      
                    }
                }
            }
            else {
//                if let message = self.genResponse?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                    self.movetonext()
//                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    @IBOutlet weak var labelView1: UILabel!
    
    // MARK: - Utility Methods
    
    func updateUI(){
        
        if isfromReactivateCard == true{
            view3.isHidden = true
            labelView1.text = "Re- Activate My Card"
            view2.isHidden = true
          isFromDeactivate = false
            
            
        }
        else
            
        {
            labelView1.text = "Activate My Card"
            view2.isHidden = true
            view3.isHidden = true
        }
        
    }
    
    
    
}
