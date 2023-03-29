//
//  Set_PasswordVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import PasswordTextField
import RNCryptor
class Set_PasswordVC:  BaseClassVC , UITextFieldDelegate {
    var customerID : Int?
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    
    var mainTitle: String?
    var setLoginPinObj : setLoginPinModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        Alert_view.isHidden = true
//        lbl4.isHidden = true
        blur_view.alpha = 0.4
        enterPinTextField.delegate = self
        enterConfirmPinTextField.delegate = self
        enterPinTextField.isUserInteractionEnabled = true
        enterConfirmPinTextField.isUserInteractionEnabled = true
        self.lblMainTitle.text = "Set Password"
        ConvertLanguage()
        dismissKeyboard()
        
        blur_view.isHidden = true
//        btnContinue.isUserInteractionEnabled = false
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(BlurviewTapped(tapGestureRecognizer:)))
        blur_view.isUserInteractionEnabled = true
        blur_view.addGestureRecognizer(tapGestureRecognizers)
        lbl1.textColor = UIColor(hexValue: 0xFF3932)
        lbl2.textColor = UIColor(hexValue: 0xFF3932)
        lbl3.textColor = UIColor(hexValue: 0xFF3932)
        lbl4.textColor = UIColor(hexValue: 0xFF3932)
        
        
        
    }
    //    -------------------------
    //    Outlets
    
    
    @IBOutlet weak var Alert_view: UIView!
    
    @IBOutlet weak var enterPinTextField: PasswordTextField!
    @IBOutlet weak var enterConfirmPinTextField: PasswordTextField!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
   
    @IBOutlet weak var btn_next_arrow: UIButton!
    @IBOutlet weak var lbl4: UILabel!
    
    @IBOutlet weak var blur_view: UIVisualEffectView!
    //    -----------------------------
    
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func Action_confirm(_ sender: UIButton) {

        if enterPinTextField.text?.count == 0 {
            showToast(title: "Please Enter  Password")
        }
        
        if enterConfirmPinTextField.text?.count == 0{
            showToast(title: "Please Enter Confirm Password")

        }

       else if isValidPassword() == true
                
        {
//           let image = UIImage(named: "Confirm")
//           btnContinue.setImage(image, for:.normal)
//           btnContinue.isUserInteractionEnabled = true
            setLoginPin()
//            Alert_view.isHidden = false
//            blur_view.isHidden = false
//            popalert()
        }


    }
    
    func ConvertLanguage()
    {
//    
//        lblMainTitle.text = "Set Password".addLocalizableString(languageCode: languageCode)
//        enterPinTextField.placeholder = "Enter New Passord".addLocalizableString(languageCode: languageCode)
//        enterConfirmPinTextField.placeholder = "Confirm password".addLocalizableString(languageCode: languageCode)
       
          
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField ==  enterPinTextField
        {
            enterConfirmPinTextField.text = ""
                 
        }
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == enterPinTextField{
            return newLength <= 6
//            lbl1.textColor = UIColor.green
        }
        if textField == enterConfirmPinTextField{
            return newLength <= 6
        }
        return newLength <= 6
        
        if textField ==  enterPinTextField
        {
                if textField == self.enterPinTextField {
                    if range.length + range.location > (textField.text?.count)! {
                        return false
                    }
                    let newLength:Int = (textField.text?.count)! + string.count - range.length
                    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                    let numberRegEx  = ".*[0-9]+.*"
                    let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
                    let numberresult = texttest1.evaluate(with: newString)
                    print("\(numberresult)")
    
        }
    }
    }
//        green
//    #00CC96
    
    
//    red
//    #FF3932
    func isValidPassword(textfield: UITextField, lastString: String) -> Bool {
    
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: textfield.text!+lastString)
    }
    
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 6 characters total
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: enterPinTextField.text!)
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == enterPinTextField {
            enterConfirmPinTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == enterConfirmPinTextField {
            textField.resignFirstResponder()
            if isValidPassword() == true{
              
            }
            
        }
  
        if enterPinTextField?.text?.count == 6
        {
            if isValidPassword() == true{
                lbl1.textColor = UIColor(hexValue : 0x00CC96)
                lbl1.textColor = UIColor(hexValue: 0x00CC96)
                lbl2.textColor = UIColor(hexValue: 0x00CC96)
                lbl3.textColor = UIColor(hexValue: 0x00CC96)
            }
            
        }
        else{
            lbl1.textColor = UIColor(hexValue: 0xFF3932)
            lbl2.textColor =  UIColor(hexValue: 0xFF3932)
            lbl3.textColor =  UIColor(hexValue: 0xFF3932)
        }
        
        
        
        if enterPinTextField.text == enterConfirmPinTextField.text{
           
            let image  = UIImage(named: "]greenarrow")
            lbl1.textColor = UIColor(hexValue:  0x00CC96)
            lbl2.textColor = UIColor(hexValue: 0x00CC96)
            lbl3.textColor = UIColor(hexValue: 0x00CC96)
            lbl4.textColor = UIColor(hexValue: 0x00CC96)
            btn_next_arrow.setImage(image, for: .normal)
            btnContinue.isUserInteractionEnabled = true
            
//                lbl4.textColor = UIColor.green
        }
        else
        {
            lbl4.textColor = UIColor(hexValue:  0xFF3932)
            let image = UIImage(named: "grayArrow")
            btn_next_arrow.setImage(image, for: .normal)
            btnContinue.isUserInteractionEnabled = false
        }
        if enterConfirmPinTextField?.text?.count == 0
        {
            lbl4.textColor = UIColor(hexValue:  0xFF3932)
            let image = UIImage(named: "grayArrow")
            btn_next_arrow.setImage(image, for: .normal)
            btnContinue.isUserInteractionEnabled = false
        }
        if enterPinTextField?.text?.count == 0
        {
            lbl1.textColor = UIColor(hexValue:  0xFF3932)
            lbl2.textColor = UIColor(hexValue: 0xFF3932)
            lbl3.textColor = UIColor(hexValue:  0xFF3932)
           let image = UIImage(named: "grayArrow")
            btn_next_arrow.setImage(image, for: .normal)
            btnContinue.isUserInteractionEnabled = false
        }
     
        
    }
  
   

    
   

    func movetonext()
                     {
                      print("move to login")
                         let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
                         self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if enterPinTextField.text?.count == 0 {
            showToast(title: "Please Enter  Password")
        }
        
        if enterConfirmPinTextField.text?.count == 0{
            showToast(title: "Please Enter Confirm Password")

        }

       else if isValidPassword() == true
        {

        }
       
        
       
    }
    
    @IBAction func Action_alert(_ sender: UIButton) {
//        print("doneeeeees")
          movetonext()
        
    }
    
    
    @IBAction func btnNextArrow(_ sender: UIButton) {
        setLoginPin()
        
    }
    
    @objc func BlurviewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("move to login")
//
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    //    MARK: API
        private func setLoginPin() {
            
            if !NetworkConnectivity.isConnectedToInternet(){
                self.showToast(title: "No Internet Available")
                return
            }
            
            showActivityIndicator()
            
            
            if (enterPinTextField.text?.isEmpty)!{
                enterPinTextField = nil
            }
            if (enterConfirmPinTextField.text?.isEmpty)!{
                enterConfirmPinTextField.text = ""
            }
            
            let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/setLoginPin"

            let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo": DataManager.instance.mobNo ,"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)", "cnic": DataManager.instance.userCnic!, "loginPin": enterConfirmPinTextField.text!]
            
            let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
            
            print(parameters)
            
            let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
            let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.AuthToken]
            print(params)
            print(compelteUrl)
            
            NetworkManager.sharedInstance.enableCertificatePinning()
            let sessionManger = APIs.shared.sessionManger(timeOut: 20)
            let error: Error!
            sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
                sessionManger.cancelAllRequests()
                let forecasts = Mapper<setLoginPinModel>().map(JSONObject: response.result)
                self.setLoginPinObj = forecasts
                self.hideActivityIndicator()
//            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<setLoginPinModel>) in
      
//                self.hideActivityIndicator()
//                self.setLoginPinObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.setLoginPinObj?.responsecode == 2 || self.setLoginPinObj?.responsecode == 1 {
                        self.Alert_view.isHidden = false
                        self.blur_view.isHidden = false
                      

                    }
                    else {
                        
                        if let message = self.setLoginPinObj?.messages{
                            self.showDefaultAlert(title: "", message: message)
                        }
                        
                        // Html Parse
                        
                        if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                            if title.contains("Request Rejected") {
                                self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                            }
                        }
                    }
                }
                else {
                    if let message = self.setLoginPinObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    else {
                        self.showDefaultAlert(title: "", message: "\(response.response?.statusCode ?? 500)")
                    }
    //                print(response.result.value)
    //                print(response.response?.statusCode)
                }
            }
        }
        
        
    
    
    
    
    
}
