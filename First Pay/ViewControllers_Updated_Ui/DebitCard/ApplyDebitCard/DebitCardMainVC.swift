//
//  DebitCardMainVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
var debitCardFee : String?
var debitCardFeeDeliveryCharges : String?
var homeAddrss: String?
var userDebitCardName :String?
class DebitCardMainVC: BaseClassVC {

    var checkDebitCardObj : GetDebitCardCheckModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
       
    }
   
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBAction func buttonContinue(_ sender: UIButton) {
        getDebitCardCheck()
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Api Call
    
    private func getDebitCardCheck() {
        
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
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/debitCardEligibilityCheck"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetDebitCardCheckModel>) in
            self.hideActivityIndicator()
            self.checkDebitCardObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.checkDebitCardObj?.responsecode == 2 || self.checkDebitCardObj?.responsecode == 1 {
                    let fullName = self.checkDebitCardObj?.data?.customerName
                    print("phone no",DataManager.instance.mobile_number)
                    //     let fullNameArr = fullName?.components(separatedBy: " ")/*fullName?.split{$0 == " "}.map(String.init)*/
                    debitCardFee = self.checkDebitCardObj?.data?.dcCharges
                    debitCardFeeDeliveryCharges = self.checkDebitCardObj?.data?.dcChargesWithDelivery
                    homeAddrss = self.checkDebitCardObj?.data?.address
                    userDebitCardName = self.checkDebitCardObj?.data?.customerName
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardNameSelectionVC") as!  DebitCardNameSelectionVC
                    vc.fullUserName = fullName!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    
                    if let message = self.checkDebitCardObj?.messages{
                        UtilManager.showAlertMessage(message: message, viewController: self)

                    }
                    
                }
            }
            else {
                if let message = self.checkDebitCardObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                    self.showDefaultAlert(title: "", message: message)
//                    self.movetoback()
                }
                else{
                    if let message = self.checkDebitCardObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                    self.showDefaultAlert(title: "", message: "Failure")
//                    self.movetoback()
                }
                }
                print(response.result.value)
                print(response.response?.statusCode)
//
            }
        }
    }

}
