//
//  AddCashMainVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class AddCashMainVc: BaseClassVC {
    var cbsAccountsObj : GetCBSAccounts?
    var LinkedAccountsObj : getLinkedAccountModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        buttonLinkHBLMFBAccount.setTitle("", for: .normal)
        buttonFromLinkAccount.setTitle("", for: .normal)
        buttonViabankTransfer.setTitle("", for: .normal)
        buttonRequestMoney.setTitle("", for: .normal)
        buttonGetLoan.setTitle("", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var buttonFromLinkAccount: UIButton!
    @IBAction func buttonFromLinkAccount(_ sender: UIButton) {
        LinkAccounts()
        
    }
    @IBOutlet weak var buttonLinkHBLMFBAccount: UIButton!
    
    @IBAction func buttonLinkHBLMFBAccount(_ sender: UIButton) {
        getLinkAccounts()
    }
    
    @IBOutlet weak var buttonViabankTransfer: UIButton!
    
    @IBAction func buttonViabankTransfer(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "viaBankTransferStepsVc") as!   viaBankTransferStepsVc
             self.navigationController?.pushViewController(vc,animated: true)
       
    }
    @IBOutlet weak var buttonRequestMoney: UIButton!
    @IBAction func buttonRequestMoney(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyDetailVc") as!   RequestMoneyDetailVc
             self.navigationController?.pushViewController(vc,animated: true)
    }
    @IBOutlet weak var buttonGetLoan: UIButton!
    
    @IBAction func buttonGetLoan(_ sender: UIButton) {
    }
    
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getCbsAccounts"
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<GetCBSAccounts>().map(JSONObject: response.result)
            self.cbsAccountsObj = forecasts
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetCBSAccounts>) in
            
            
            self.hideActivityIndicator()
            
//            self.cbsAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkBankAccountListVC") as! LinkBankAccountListVC
//                        vc.accountTitle = cbsAccountsObj?.accdata[0].cbsAccountTitle
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                       
                    }
                    else{
                       
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoBankAccountFoundVc") as! NoBankAccountFoundVc
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }
                else {
                    self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    private func LinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLinkAccount"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<getLinkedAccountModel>().map(JSONObject: response.result)
            self.LinkedAccountsObj = forecasts
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getLinkedAccountModel>) in
            
            
            self.hideActivityIndicator()
            
//            self.LinkedAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
               
                if self.LinkedAccountsObj?.responsecode == 2 || self.LinkedAccountsObj?.responsecode == 1 {
                    if self.LinkedAccountsObj?.data?.count ?? 0 > 0{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "FromLinkAccountListVc") as! FromLinkAccountListVc
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                       
                }
                    
                }
                else{
                   
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NobankExistsVc") as! NobankExistsVc
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            else {
                self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
            }
        }

    }
    
    
    
    
}
