//
//  Hblmfb_MoneyTransferVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
import ObjectMapper
import MapKit
import ContactsUI
import libPhoneNumber_iOS
import  SwiftKeychainWrapper
class Hblmfb_MoneyTransferVC: BaseClassVC, UITextFieldDelegate {
    var fundsTransSuccessObj: FundsTransferApiResponse?
//    var fundsTransSuccessObj: FundsTransferApiResponse?
    var transactionApiResponseObj : FTApiResponse?
    var amount: String?
    var number: String?
    var ToaccountTitle : String?
    var bankname : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GlobalData.money_Reason",  number)
        back.setTitle("", for: .normal)
        btn_Next.isUserInteractionEnabled = false
        otpTextField.delegate = self
        btndropdown.setTitle("", for: .normal)
        amountTextField.delegate = self
        lblAlertAmount.textColor = .gray
        linebtn.setTitle("", for: .normal)
        
        updateUI()
        
//        otpView.isHidden = true
        
    
//        lblAlertAmount.isHidden = true
       
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var img_next_arrow: UIImageView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblAccName: UILabel!
    var minvalu  = 100
    var maxvalu = 10000
    @IBOutlet weak var lblAlertAmount: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lblMobno: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblReason: UILabel!
   
    
    @IBOutlet weak var linebtn: UIButton!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var btndropdown: UIButton!
    @IBOutlet weak var bankLogo: UIImageView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var sourceAccountno: UILabel!
    @IBOutlet weak var PurposeTf: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    func updateUI()
    {
        amountTextField.text = "Rs \(amount!)"
        totalAmount.text = "Rs \(amount!)"
        if  isfromFirstPayWallet == true{
            
               
                lblMobno.text = number
                lblname.text = ToaccountTitle!
//                sourceAccountno.text = ToaccountTitle!
                totalAmount.text = amount
//                PurposeTf.text = ""
            lblAccName.text = "FirstPay Wallet"
            bankLogo.image = UIImage(named: "First Pay")
//            otpView.isHidden = false
            
        }
        else  if isfromHblMbfAccount == true{
//            PurposeTf.text = GlobalData.money_Reason
          
            lblMobno.text = number
            lblname.text = ToaccountTitle!
//            sourceAccountno.text = ToaccountTitle!
            lblAccName.text = "HBL MFB Account"
            bankLogo.image = UIImage(named: "unnamed 2")
//            otpView.isHidden = falseo
            
        }
        else if isfromBanktoBank == true{
            
            
            lblMobno.text = number
            lblname.text = ToaccountTitle!
//            sourceAccountno.text = ToaccountTitle!
            totalAmount.text = amount
//            PurposeTf.text = GlobalData.money_Reason

            lblAccName.text = bankname!
//            otpView.isHidden = true
            let img = GlobalData.selected_bank_logo
            bankLogo.image = img
            
            
        }
        else{
           
            lblMobno.text = number
            lblname.text = ToaccountTitle!
//            sourceAccountno.text = ToaccountTitle!
            totalAmount.text = amount
//            PurposeTf.text = GlobalData.money_Reason
            
            lblAccName.text = bankname!
//            otpView.isHidden = true
            let img = GlobalData.selected_bank_logo
            bankLogo.image = img
        }
 
    }
    override func viewWillAppear(_ animated: Bool) {

        if isFromReason == true{
            PurposeTf.text = GlobalData.money_Reason
        }
        else {
            PurposeTf.text = ""
        }
 
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == otpTextField
        {
            otpTextField.isUserInteractionEnabled = true
            return newLength <= 4
           
    }
    
        return newLength <= 4
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if otpTextField.text?.count == 4
        {
            
            img_next_arrow.image = UIImage(named: "]greenarrow")
         
            btn_Next.isUserInteractionEnabled = true
        }
        else
        {
//            let image = UIImage(named:"grayArrow")
            img_next_arrow.image = UIImage(named: "grayArrow")
            btn_Next.isUserInteractionEnabled = false
        }
        
        
    }
 
    @IBOutlet weak var reasonbtn: UIButton!
    @IBAction func ReasonDropdown(_ sender: UIButton) {
         
       let vc = storyboard?.instantiateViewController(withIdentifier: "MoneyTransfer_ReasonVC") as! MoneyTransfer_ReasonVC
//        isfromFirstPayWallet = true
//        isfromHblMbfAccount = false
        self.navigationController?.pushViewController(vc, animated: false)
    
    }
   
    @IBAction func TF_PURPOSE(_ sender: UITextField) {
      let vc = storyboard?.instantiateViewController(withIdentifier: "MoneyTransfer_ReasonVC") as! MoneyTransfer_ReasonVC
//        isfromFirstPayWallet = true
//        isfromHblMbfAccount = false
       self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
        if isfromBanktoBank == true || isfromOtherLocalBank == true
        {
           
            FundTransferIBFT()
        }
        else
        {
            fundsTransferLocal()
        }
       
        
        
       
    }
    
    private func clearAll(){
        
//        self.lblSourceAccount.text = ""
//        self.lblBeneficaryAccount.text = ""
//        self.lblAccountTitle.text = ""
//        self.lblTransAmount.text = ""
        //        self.lblFee.text = ""
        //        self.lblFed.text = ""
        
    }
    private func fundsTransferLocal() {
        
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/fundsTransferLocal"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"narration":"","cnic":userCnic!,"accountNo":number!,"amount":amount!,"transPurpose":GlobalData.moneyTransferReasocCode,"accountTitle": DataManager.instance.accountTitle!,"beneficiaryName":"","beneficiaryMobile":
                        "","beneficiaryEmail":"","addBeneficiary":"N","otp": otpTextField.text!,"requestMoneyId":GlobalData.moneyReasonid!,"accountType": DataManager.instance.accountType!] as [String : Any]
 
       
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
                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.messages ?? "") ")
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    func movetonext()
    {
        if otpTextField?.text?.count != 0
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Hblmfb_MoneyTransfer_SuccessfullVC") as! Hblmfb_MoneyTransfer_SuccessfullVC
            vc.amount = Double(amount!)
            vc.TransactionId = fundsTransSuccessObj?.data?.authIdResponse
            vc.TransactionDate = fundsTransSuccessObj?.data?.transDate
            vc.number = number!
            vc.Toaccounttitle = ToaccountTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    // MARK: - API CALL
    
    private func FundTransferIBFT() {

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


//        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/fundsTransferIbft"

        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"accountNo":number!,"accountIMD":GlobalData.Selected_bank_code,"amount":amount!,"transPurpose":GlobalData.moneyTransferReasocCode,"accountTitle":DataManager.instance.accountTitle!,"benificiaryIBAN":DataManager.instance.accountNo!,"otp": otpTextField.text!,"accountType":DataManager.instance.accountType!]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

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
                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.data?.responseCode ?? 90)  \(self.fundsTransSuccessObj?.data?.responseDescr ?? "") ")
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//
//
    
    
    
    
    
    
    
}
