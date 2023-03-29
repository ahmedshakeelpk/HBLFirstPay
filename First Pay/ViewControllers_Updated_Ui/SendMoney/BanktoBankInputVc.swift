//
//  BanktoBankInputVc.swift
//  First Pay
//
//  Created by Irum Butt on 13/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
import SwiftyRSA
class BanktoBankInputVc: BaseClassVC,UITextFieldDelegate {
    private let contactPicker = CNContactPickerViewController()
    var transactionApiResponseObj : FTApiResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        walletNumberTf.delegate = self
        selectWallettf.delegate = self
        dropdownPurpose.setTitle("", for: .normal)
        back.setTitle("", for: .normal)
        dropdownWallet.setTitle("", for: .normal)
        btncontactNo.setTitle("", for: .normal)
        img_next.isUserInteractionEnabled = false
        lbl1.isHidden = true
        lbl2.isHidden = true
        lbl3.isHidden = true
        amountTextField.delegate = self
        lblWalletName.text  = ""
        btn_continue.isUserInteractionEnabled = false
        amountTextField.isUserInteractionEnabled = false
//        getReasonsForTrans()
        UpdateUi()
        // Do any additional setup after loading the view.
    }
    
    func UpdateUi()
    {
        if isfromBanktoBank == true{
            walletNumberTf.placeholder = "Enter Wallet Number"
            lbl1.isHidden = true
            lbl2.isHidden = true
            lbl3.isHidden = true
            lblsubTitle.text = "Wallet Number"
            lblWalletName.text = "Wallet Name"
            selectWallettf.placeholder = "Select Wallet"
            iconAccountNo.image = UIImage(named: "Walletno")
            
        }
        else{
            walletNumberTf.placeholder = "Enter IBAN or Account Number"
            lblsubTitle.text = "IBAN or Account Number"
            lbl1.isHidden = false
            lbl2.isHidden = false
            lbl3.isHidden = false
            btncontactNo.isHidden = true
            lblWalletName.text = "Bank Name"
            selectWallettf.placeholder = "Select Bank"
            iconAccountNo.image = UIImage(named: "ProfileBlack")
            
        }
    }
    
    
    
    @IBOutlet weak var iconAccountNo: UIImageView!
    
    
    @IBOutlet weak var lblsubTitle: UILabel!
    
    @IBOutlet weak var lblWalletName: UILabel!
    override func viewWillAppear(_ animated: Bool) {
 
        selectWallettf.text =  GlobalData.Selected_bank
        
        
        
//            purposeTf.text =  GlobalData.money_Reason
//            selectWallettf.text =  GlobalData.Selected_bank
//
//                if purposeTf.text?.count != 0
//                {
////                    lblAlert.textColor = .orange
//
//                    let image = UIImage(named:"]greenarrow")
//                    img_next.image = image
//                    let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
//                    img_next.isUserInteractionEnabled = true
//                    img_next.addGestureRecognizer(tapGestureRecognizerrr)
//
//                    img_next.isUserInteractionEnabled = true
//                }
//            }
        
    }
    func clearAll()
    {
        purposeTf.text = ""
        selectWallettf.text =  ""
        amountTextField.text = ""
        
    }
    
    var minvalu  = 100
    var maxvalu = 25000
    @IBOutlet weak var selectWallettf: UITextField!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dropdownPurpose: UIButton!
    @IBOutlet weak var purposeTf: UITextField!
    @IBOutlet weak var btncontactNo: UIButton!
    @IBOutlet weak var dropdownWallet: UIButton!
    @IBOutlet weak var walletNumberTf: UITextField!
    @IBOutlet weak var lblAlert: UILabel!
    @IBOutlet weak var img_next: UIImageView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    var reasonsObj : GetReasonsModel?
    var reasonsList : [String]?
    
    @IBAction func seelctWallet(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectWalletVC") as! SelectWalletVC

//            self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func ContactList(_ sender: UIButton) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    @IBOutlet weak var btn_continue: UIButton!
    
    @IBAction func Action_continue(_ sender: UIButton) {
        initiateIBFT()
     
    }
    
    @IBAction func Purpose(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoneyTransfer_ReasonVC") as! MoneyTransfer_ReasonVC
        isfromFirstPayWallet = false
        isfromHblMbfAccount = false
        isfromBanktoBank = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        clearAll()
        self.dismiss(animated: true)
    }
    @objc func PopUpHide(tapGestureRecognizer: UITapGestureRecognizer)
    {
        initiateIBFT()
//       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == walletNumberTf{
            if  isfromBanktoBank  == true{
                return newLength <= 11
            }
            else{
                return newLength <= 16
                amountTextField.isUserInteractionEnabled = true
            }
            
        }
        else if textField == amountTextField
        {
            return newLength <= 6
        }
       
        return newLength <= 24
        amountTextField.isUserInteractionEnabled = true
       
     
        
    }

    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getFtTransPurpose"
        let header = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReasonsModel>) in
            self.hideActivityIndicator()
            if response.response?.statusCode == 200 {
                self.reasonsObj = response.result.value
                if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                   
//                    self.reasonsList = self.reasonsObj!.stringReasons
//                    self.purposeTf.text =  self.reasonsObj?.reasonsData?[0].descr
//                    GlobalData.money_Reason = self.purposeTf.text ?? ""
                    
                }
                
            }
            else {
                
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    private func initiateIBFT() {
        
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
        
//            let compelteUrl = GlobalConstants.BASE_URL + "initiateIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/initiateIbft"
        
//
    userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":self.walletNumberTf.text!,"accountIMD":GlobalData.Selected_bank_code,"amount":self.amountTextField.text!,"transPurpose":"0350","accountType":DataManager.instance.accountType!] as [String : Any]
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FTApiResponse>) in
            
            self.hideActivityIndicator()
            
            self.transactionApiResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                    if isfromBanktoBank == true{
                        self.navigateToConfirmation()
                    }
                    else
                    {
                        self.movetonext()
                    }
                    
//
                }
                else {
                    if let message = self.transactionApiResponseObj?.messages{
                        UtilManager.showAlertMessage(message: message, viewController: self)
//                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.transactionApiResponseObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                    print(response.result.value)
//                    print(response.response?.statusCode)
            }
        }
    }
    
    
    
    private func navigateToConfirmation(){
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Hblmfb_MoneyTransferVC") as!  Hblmfb_MoneyTransferVC
              vc.number = walletNumberTf.text!
              vc.amount = amountTextField.text!
              isfromFirstPayWallet = false
              isfromHblMbfAccount = false
               isfromBanktoBank = false
               isfromOtherLocalBank = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    private func movetonext(){
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Hblmfb_MoneyTransferVC") as!  Hblmfb_MoneyTransferVC
              vc.number = walletNumberTf.text!
              vc.amount = amountTextField.text!
        vc.ToaccountTitle = transactionApiResponseObj?.data?.accountTitle!
              isfromFirstPayWallet = false
              isfromHblMbfAccount = false
               isfromBanktoBank = true
        vc.bankname = selectWallettf.text!
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
  
    

    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if amountTextField?.text?.count ?? 0 < 0 || selectWallettf?.text?.count == 0 || walletNumberTf?.text?.count == 0
        {
           img_next.image = UIImage(named: "grayArrow")
            img_next.isUserInteractionEnabled = false
            lblAlert.textColor =  UIColor(hexValue: 0xFF3932)
            img_next.isUserInteractionEnabled = false
            btn_continue.isUserInteractionEnabled = false
        }
        
       if textField == amountTextField
        {
           if Int(amountTextField.text!) ?? 0  < (minvalu) || Int(amountTextField.text!) ?? 0 > (maxvalu)

                    {
                        lblAlert.textColor = .gray
                        img_next.image = UIImage(named: "grayArrow")
                        img_next.isUserInteractionEnabled = false
                      lblAlert.textColor =  UIColor(hexValue: 0xFF3932)
                        btn_continue.isUserInteractionEnabled = false

                    }
           else
           {
               let image = UIImage(named:"]greenarrow")
               img_next.image = image
               let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
               img_next.isUserInteractionEnabled = true
               img_next.addGestureRecognizer(tapGestureRecognizerrr)
               lblAlert.textColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
               btn_continue.isUserInteractionEnabled = true
               
           }
    
        }
       
        else if amountTextField?.text?.count != 0 && selectWallettf.text?.count != 0 && walletNumberTf?.text?.count != 0
        {
            
            let image = UIImage(named:"]greenarrow")
            img_next.image = image
            let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
            img_next.isUserInteractionEnabled = true
            img_next.addGestureRecognizer(tapGestureRecognizerrr)
            lblAlert.textColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
            btn_continue.isUserInteractionEnabled = true

            
        }
            }

   
    
    
    
}
extension BanktoBankInputVc: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.walletNumberTf.text = name

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
            self.walletNumberTf.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}
