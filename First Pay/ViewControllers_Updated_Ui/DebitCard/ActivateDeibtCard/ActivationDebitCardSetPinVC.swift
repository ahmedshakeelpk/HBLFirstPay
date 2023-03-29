//
//  ActivationDebitCardSetPinVC.swift
//  First Pay
//
//  Created by Irum Butt on 13/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import PasswordTextField
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import SwiftyRSA
class ActivationDebitCardSetPinVC: BaseClassVC,UITextFieldDelegate {
    var genResponse : GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        TextFieldEnterPin.delegate = self
        TextFieldConfirmPin.delegate = self
        imgeNextArrow.isUserInteractionEnabled = false
        buttonback.setTitle("", for: .normal)
        CheckStatus()
        buttonContinue.isUserInteractionEnabled = false
        imagePopup.isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imagePopup.isUserInteractionEnabled = true
        imagePopup.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(move(tapGestureRecognizer:)))
        
        imgeNextArrow.addGestureRecognizer(tapGesture)
    }
    @IBAction func textfieldConfirm(_ sender: PasswordTextField) {
        
        if TextFieldEnterPin.text?.count == 4 &&  TextFieldConfirmPin.text?.count == 4
         {
             if TextFieldEnterPin.text ==  TextFieldConfirmPin.text
             {
                 let image = UIImage(named:"]greenarrow")
                 imgeNextArrow.image = image
                 buttonContinue.isUserInteractionEnabled = true
                 imgeNextArrow.isUserInteractionEnabled = true
             }
             else{
                 let image = UIImage(named:"grayArrow")
                 imgeNextArrow.image = image
                 buttonContinue.isUserInteractionEnabled = false
                 imgeNextArrow.isUserInteractionEnabled = false
             }
             
             
         }
         else
         {
             let image = UIImage(named:"grayArrow")
             imgeNextArrow.image = image
             buttonContinue.isUserInteractionEnabled = false
             imgeNextArrow.isUserInteractionEnabled = false
         }

        
    }
    func CheckStatus()
    {
       
        
        if isfromReactivateCard == true
        {
            LabelMainTitle.text = "ACTIVATE MY CARD"
           
            self.blurView.isHidden = false
            self.imagePopup.isHidden = false
        }
        else if isFromChangePin == true
        {
            LabelMainTitle.text = "UPDATE MY PIN"
            self.blurView.isHidden = true
            self.imagePopup.isHidden = true
        }
        else
        {
            LabelMainTitle.text = "ACTIVATE MY CARD"
            self.blurView.isHidden = true
            self.imagePopup.isHidden = true
        }
        
       
        
    }
    @IBOutlet weak var LabelMainTitle: UILabel!
    @IBOutlet weak var TextFieldEnterPin: PasswordTextField!
    
    @IBOutlet weak var TextFieldConfirmPin: PasswordTextField!
    
    
    @IBOutlet weak var buttonback: UIButton!
    
    @IBAction func buutonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
   
    @IBOutlet weak var imgeNextArrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        createDCPin()
    }
    @objc func move(tapGestureRecognizer: UITapGestureRecognizer)
    {
          createDCPin()
    
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var imagePopup: UIImageView!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == TextFieldEnterPin
        { TextFieldEnterPin.isUserInteractionEnabled = true
            return newLength <= 4
       
         }
        
        
        return newLength <= 4
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       
    }
    
    
    private func createDCPin() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/createDCPin"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":GlobalData.accountDebitCardId!,"confirmPin" : TextFieldConfirmPin.text!,"pin":TextFieldEnterPin.text!] as [String : Any]
       
        
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
            let forecasts = Mapper<GenericResponse>().map(JSONObject: response.result)
            self.genResponse = forecasts
        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
//            self.genResponse = response.result.value
            print(self.genResponse)
        
            if response.response?.statusCode == 200 {
                
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                  
                    self.blurView.isHidden = false
                    self.imagePopup.isHidden = false
                    if isFromChangePin == true{
                        let img = UIImage(named: "Group 427321154-7")
                        self.imagePopup.image = img
                    }
                    if isfromReactivateCard == true{
                        let image = UIImage(named: "Group 427321154-5")
                        self.imagePopup.image = image
                    }
                    
                      if isFromDeactivate == true
                    {
                          let img = UIImage(named: "Group 427321154-5")
                          self.imagePopup.image = img
                      }
                    else
                    {
                        
//                        let image = UIImage(named: "Group 427321154-5")
//                        self.imagePopup.image = image
                    }
                    
                }
                else {
                    if let message = self.genResponse?.messages{
                      
                        UtilManager.showAlertMessage(message: message, viewController: self)

                    }
                }
            }
            else {
                if let message = self.genResponse?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
  
    
    
    
    
    
}
