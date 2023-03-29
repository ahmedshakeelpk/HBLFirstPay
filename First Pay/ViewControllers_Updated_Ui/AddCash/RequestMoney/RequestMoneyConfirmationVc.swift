//
//  RequestMoneyConfirmationVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import MessageUI
class RequestMoneyConfirmationVc: BaseClassVC,MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            self.showToast(title: "Message canceled")
            print("message canceled")
        case MessageComposeResult.failed.rawValue :
            self.showToast(title: "Message failed")
            print("message failed")
        case MessageComposeResult.sent.rawValue :
            self.showToast(title: "Message sent")
            print("message sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    var accountTitle: String?
    var accountNo: String?
    var minValue = 100
    var maxValue = 10000
    var genResponseObj : GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldAmount.delegate = self
        buttonNext.setTitle("", for: .normal)
        buttonback.setTitle("", for: .normal)
        updateUi()
        imageNextArrow.isUserInteractionEnabled = false
        buttonContinue.isUserInteractionEnabled = false
        buttonNext.isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imageNextArrow.addGestureRecognizer(tapGestureRecognizer)
        messageView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var buttonback: UIButton!
    
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var labelAccountName: UILabel!
    
    @IBOutlet weak var labelMobileNumber: UILabel!
    
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var textFieldAmount: UITextField!
    
    @IBAction func textFieldAmount(_ sender: UITextField) {
        
    }
    @IBOutlet weak var messageView: UITextView!
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        requestMoney()
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        requestMoney()
    }
   
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var imageNextArrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldAmount
        {
            return true
        }
        if string.rangeOfCharacter(from: .letters) != nil || string == " " {
            return true
        }
        else if !(string == "" && range.length > 0) {
        return false
        
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.rangeOfCharacter(from: .letters) != nil || text == " " {
                   return true
               }
               else if !(text == "" && range.length > 0) {
               return false
               }
        if text == "\n"
        {
            messageView.resignFirstResponder()
        }

        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {

        if Int(textFieldAmount?.text! ?? "")! < minValue
        {
            let image = UIImage(named:"grayArrow")
            imageNextArrow.image = image
            imageNextArrow.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            buttonNext.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
        }
        if  Int(textFieldAmount?.text! ?? "")! > (maxValue)
        {
            let image = UIImage(named:"grayArrow")
            imageNextArrow.image = image
            imageNextArrow.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            buttonNext.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
        }

        else{
            if messageView.text?.count != 0
            {
                let image = UIImage(named:"]greenarrow")
                imageNextArrow.image = image
                imageNextArrow.isUserInteractionEnabled = true
                labelAlert.textColor =  UIColor(red: 241/255, green: 147/255, blue: 0/255, alpha: 1)
                 textFieldAmount.textColor = .gray
                buttonNext.isUserInteractionEnabled = true
                buttonContinue.isUserInteractionEnabled = true

            }
            else
            {
                let image = UIImage(named:"grayArrow")
                imageNextArrow.image = image
                imageNextArrow.isUserInteractionEnabled = false
                buttonContinue.isUserInteractionEnabled = false
                buttonNext.isUserInteractionEnabled = false

            }

        }

//        messageView.text = ""

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageView.text?.count != 0
        {
            let image = UIImage(named:"]greenarrow")
            imageNextArrow.image = image
            imageNextArrow.isUserInteractionEnabled = true
            labelAlert.textColor =  UIColor(red: 241/255, green: 147/255, blue: 0/255, alpha: 1)
             textFieldAmount.textColor = .gray
            buttonNext.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true

        }
        else
        {
            let image = UIImage(named:"grayArrow")
            imageNextArrow.image = image
            imageNextArrow.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            buttonNext.isUserInteractionEnabled = false

        }
    }
    func updateUi()
    {
        labelAccountName.text = accountTitle
        labelMobileNumber.text = accountNo
    }
    
    
    public func requestMoney(){
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/requestMoney"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"accountNo":accountNo!,"amount":self.textFieldAmount.text!,"comments":self.messageView.text!,"accountType":DataManager.instance.accountType!]
        
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
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            self.genResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneySuccessfullVc") as!   RequestMoneySuccessfullVc
                         self.navigationController?.pushViewController(vc,animated: true)
                }
                else {
                    if let message = self.genResponseObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
                        UtilManager.showAlertMessage(message: message, viewController: self)

                    }
                }
            }
            else {
                if let message = self.genResponseObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
                    UtilManager.showAlertMessage(message: message, viewController: self)

                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    
}
