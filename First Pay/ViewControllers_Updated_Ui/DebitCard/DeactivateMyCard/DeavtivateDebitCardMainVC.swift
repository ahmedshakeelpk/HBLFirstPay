//
//  DeavtivateDebitCardMainVC.swift
//  First Pay
//
//  Created by Irum Butt on 15/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class DeavtivateDebitCardMainVC: BaseClassVC {
    var getDebitDetailsObj : GetDebitCardModel?
    @IBOutlet weak var buttonBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonChangePin.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        buttonDeactivate.setTitle("", for: .normal)
        getDebitCard()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var buttonDeactivate: UIButton!
    
    @IBAction func buttonChangePin(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
        isFromChangePin = true
        isFromDeactivate = false
        isfromReactivateCard = false
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func buttonDeactivate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeactivateConfirmationVC") as! DeactivateConfirmationVC
        isFromDeactivate = true
        isFromChangePin = false
       
        isfromReactivateCard = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBOutlet weak var labeldate: UILabel!
    @IBOutlet weak var buttonChangePin: UIButton!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    
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
        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GetDebitCardModel>) in
            
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
                                self.labeldate.text = "\(month)" + "/\(year)"
                            }
                        }
                      
                        if let accountID = anObject.accountDebitCardId{
                            GlobalData.accountDebitCardId = Int(accountID)
            //                self.accountDebitCardId = "\(accountID)"
                        }
                    }
                  
//                    self.updateUI()
                    
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
 
}
