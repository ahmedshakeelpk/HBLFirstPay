//
//  TransferAmountConfirmationVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper

class TransferAmountConfirmationVc: BaseClassVC {
 
    var successmodelobj : FundsTransferApiResponse?
    var amount :String?
    var phoneNumber  : String?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        back.setTitle("", for: .normal)
        nextBtn.setTitle("", for: .normal)
        updateUi()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblRecipientPhoneNumber: UILabel!
    @IBOutlet weak var lblOperator: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTransationId: UILabel!
    @IBOutlet weak var lblSendTo: UILabel!
    @IBOutlet weak var lblSendBy: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    func updateUi()
    {
        lblAmount.text = "\(amount!)"
        lblTotalAmount.text = "\(amount!)"
        lblFee.text = "Rs. 0.00"
        lblRecipientPhoneNumber.text = phoneNumber
        lblOperator.text = GlobalData.Selected_operator
        lblTransactionType.text = GlobalData.topup
        
    }
    
    
    
    
    @IBOutlet weak var back: UIButton!
    @IBAction func Action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func Continue(_ sender: UIButton) {
        payTopUp()
//
        
        
        
    }
    
    
    @IBAction func ActionFavourite(_ sender: UIButton) {
    }
    
    
    
    @IBAction func ActionDownloadShare(_ sender: UIButton) {
        
        
        
    }
    
    
    private func payTopUp() {
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/billPayment"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":GlobalData.Select_operator_code,"beneficiaryAccountTitle":"","utilityConsumerNo":phoneNumber!,"accountType" : DataManager.instance.accountType!,"amountPaid":self.amount!,"beneficiaryName":"","beneficiaryMobile":"","beneficiaryEmail":"","otp":"","addBeneficiary":"","utilityBillCompanyId":GlobalData.Select_operator_id] as [String : Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<FundsTransferApiResponse>().map(JSONObject: response.result)
            self.successmodelobj = forecasts
                   self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundsTransferApiResponse>) in
//            self.hideActivityIndicator()
//             self.successmodelobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                    self.navigateToSuccessVC()
//                    self.tablleview?.reloadData()
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                        self.navigateToSuccessVC()
                    }
                }
            }
            else {
                if let message = self.successmodelobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//    --------------
    
    
    private func navigateToSuccessVC(){
           
           let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountSuccessfulVC") as! TransferAmountSuccessfulVC
        vc.phoneNumber = phoneNumber
        vc.amount = amount
        vc.Trascationid = successmodelobj?.data?.authIdResponse
        vc.TransactionDate = successmodelobj?.data?.transDate
        
        
        
        self.navigationController!.pushViewController(vc, animated: true)
     
    
    }
    
    
}
