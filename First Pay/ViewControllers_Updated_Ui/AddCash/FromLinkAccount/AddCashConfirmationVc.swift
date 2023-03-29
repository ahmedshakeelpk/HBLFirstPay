//
//  AddCashConfirmationVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
var isfromPullFund :Bool = false
class AddCashConfirmationVc: BaseClassVC {
    var accounttilte : String?
    var accontNo : String?
    var bankName :String?
    var TotalAmount : String?
    var FirstPayNo : String?
    var transactionApiResponseObj : FTApiResponse?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUi()
        buttonViewLine.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next.isUserInteractionEnabled = true
        img_next.addGestureRecognizer(tapGestureRecognizerr)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        self.initiateAddCashFT()
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        initiateAddCashFT()
    }
    
    @IBOutlet weak var img_next: UIImageView!
    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var labelFirstPayNo: UILabel!
    @IBOutlet weak var labelTotalTransationAmount: UILabel!
    @IBOutlet weak var labelTransactionFee: UILabel!
    @IBOutlet weak var buttonViewLine: UIButton!
    @IBOutlet weak var labelAccountTitle: UILabel!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelAccountNo: UILabel!
     func UpdateUi()
    {
       
        
        labelTransactionFee.text = "0.00"
        labelAccountTitle.text = accounttilte
        labelAccountNo.text = accontNo
        labelBankName.text = bankName
        labelFirstPayNo.text = FirstPayNo
        labelTotalTransationAmount.text = TotalAmount
        amounttextfield.text = TotalAmount
    }
    private func initiateAddCashFT() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        
        else{
            userCnic = ""
        }
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/initiateAddCashFT"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":DataManager.instance.accountNo!,"amount":TotalAmount!] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        print(params)
        print(compelteUrl)
//        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FTApiResponse>) in
            
            //         Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundInitiateModel>) in
          
            self.hideActivityIndicator()
            self.transactionApiResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                        if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                           
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkBankAccountOTPVerificationVc") as! LinkBankAccountOTPVerificationVc
                            vc.TotalAmount = self.TotalAmount
                            vc.userAccountNo = self.transactionApiResponseObj?.data?.accountNo
                            isfromPullFund = true
                            self.navigationController?.pushViewController(vc, animated: true
                            )
                            
                            
                            
                }
                else {
                    if let message = self.transactionApiResponseObj?.messages{
                        UtilManager.showAlertMessage(message: message, viewController: self)
                    }
                     
                }
            }
            else {
                if let message = self.transactionApiResponseObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    

}
