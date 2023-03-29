//
//  WalletToWalletVC.swift
//  First Pay
//
//  Created by Irum Butt on 12/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS

class WalletToWalletVC: BaseClassVC,UITextFieldDelegate {
    private let contactPicker = CNContactPickerViewController()
    var transactionApiResponseObj : FTApiResponse?
    var reasonsObj : GetReasonsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        back.setTitle("", for: .normal)
        btnContactList.setTitle("", for: .normal)
        amountTextField.delegate = self
        btn_next.isUserInteractionEnabled = false
        tfAccountNo.delegate = self
        lblAlertAmount.textColor = .gray
        btnPurposeField.setTitle("", for: .normal)
        btnDropdwonPurpose.setTitle("", for: .normal)
        btnPurposeField.isUserInteractionEnabled = false
        btnDropdwonPurpose.isUserInteractionEnabled = false
        getReasonsForTrans()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        getReasonsForTrans()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//            if amountTextField.text?.count == 0
//            {
//                PurposeTf.text = ""
//            }
//            else{
//                PurposeTf.text = GlobalData.money_Reason
//                if PurposeTf.text?.count != 0
//                {
////                    lblAlertAmount.textColor = .orange
//
//                    let image = UIImage(named:"]greenarrow")
//                    imgnextarrow.image = image
//                    let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
//                                   imgnextarrow.isUserInteractionEnabled = true
//                                   imgnextarrow.addGestureRecognizer(tapGestureRecognizerrr)
//
//                    self.btn_next.isUserInteractionEnabled = true
//                }
//            }
//
//    }
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var PurposeTf: UITextField!
    @IBOutlet weak var btnPurposeField: UIButton!
    @IBAction func dropDownArrow(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoneyTransfer_ReasonVC") as! MoneyTransfer_ReasonVC
        isfromFirstPayWallet = true
        isfromHblMbfAccount = false
        self.navigationController?.pushViewController(vc, animated: false)
        
        
        
        
    }
    var reasonsList : [String]?
    @IBOutlet weak var imgnextarrow: UIImageView!
    
    @IBOutlet weak var btnDropdwonPurpose: UIButton!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var btnContactList: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var tfAccountNo: UITextField!
    @IBOutlet weak var btn_next: UIButton!
    
    @IBOutlet weak var lblMainTitle: UILabel!
    var minvalu  = 100
    var maxvalu = 25000
    @IBOutlet weak var lblAlertAmount: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBAction func Action_showContact(_ sender: UIButton) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_continue(_ sender: UIButton) {
        initiateLocalFT()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == tfAccountNo{
               return newLength <= 11
            
        }
        
        return newLength <= 11
      
       
     
        
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if amountTextField?.text?.count ?? 0 < 0 || tfAccountNo?.text?.count == 0
        {
            lblAlertAmount.textColor = .gray
            imgnextarrow.image = UIImage(named: "grayArrow")
            lblAlertAmount.textColor =  UIColor(hexValue: 0xFF3932)
            imgnextarrow.isUserInteractionEnabled = false
        }
        
        else  if textField == amountTextField
        {
                    if Int(amountTextField.text!) ?? 0  < Int((minvalu) ?? 0) || Int(amountTextField.text!) ?? 0  > Int((maxvalu) ?? 0)

                    {
                        lblAlertAmount.textColor = UIColor(hexValue: 0xFF3932)
                        imgnextarrow.image = UIImage(named: "grayArrow")
                       lblAlertAmount.textColor =  UIColor(hexValue: 0xFF3932)
                        imgnextarrow.isUserInteractionEnabled = false
//

                    }
        
            else
            {
                let image = UIImage(named:"]greenarrow")
                imgnextarrow.image = image
                let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
                imgnextarrow.isUserInteractionEnabled = true
                imgnextarrow.addGestureRecognizer(tapGestureRecognizerrr)
                lblAlertAmount.textColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
                self.btn_next.isUserInteractionEnabled = true
            }
            

            
        }

        
        
        
        
        else if amountTextField?.text?.count != 0 && tfAccountNo.text?.count != 0
        {
            
            let image = UIImage(named:"]greenarrow")
            imgnextarrow.image = image
            let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
            imgnextarrow.isUserInteractionEnabled = true
            imgnextarrow.addGestureRecognizer(tapGestureRecognizerrr)
            lblAlertAmount.textColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
            self.btn_next.isUserInteractionEnabled = true
        }
        
        
        
        
        
        
    }
    
    @objc func PopUpHide(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        self.navigateToConfirmation()
        
        initiateLocalFT()
//
    }
       
    private func initiateLocalFT() {
        
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
//        let compelteUrl = GlobalConstants.BASE_URL + "initiateLocalFT"
//
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/initiateLocalFT"
         
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":tfAccountNo.text!,"amount":self.amountTextField.text!,"transPurpose":"0350","accountType": DataManager.instance.accountType!] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        print(params)
        print(compelteUrl)
//        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<FTApiResponse>().map(JSONObject: response.result)
            self.transactionApiResponseObj = forecasts
            self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FTApiResponse>) in
            
            //         Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundInitiateModel>) in
//            self.hideActivityIndicator()
//            self.transactionApiResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                                if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                                 
                                    
                            self.navigateToConfirmation()
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
    private func navigateToConfirmation(){
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Hblmfb_MoneyTransferVC") as!  Hblmfb_MoneyTransferVC
              vc.number = tfAccountNo.text!
              vc.amount = amountTextField.text!
           vc.ToaccountTitle = self.transactionApiResponseObj?.data?.accountTitle!

              isfromFirstPayWallet = true
              isfromHblMbfAccount = false
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getFtTransPurpose"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
       let error: Error!
       sessionManger.request(compelteUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
           sessionManger.cancelAllRequests()
           let forecasts = Mapper<GetReasonsModel>().map(JSONObject: response.result)
           self.reasonsObj = forecasts
           self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReasonsModel>) in
//            self.hideActivityIndicator()
            if response.response?.statusCode == 200 {
//                self.reasonsObj = response.result.value
                if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                   
//                    self.reasonsList = self.reasonsObj!.stringReasons
//                    self.PurposeTf.text =  self.reasonsObj?.reasonsData?[0].descr
//                    GlobalData.money_Reason = self.PurposeTf.text ?? ""
//                    GlobalData.moneyReasonid =  
                    
                }
                
            }
            else {
                
//                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    

}
extension WalletToWalletVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.tfAccountNo.text = name

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        

        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
            self.tfAccountNo.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
    
    
    
}
