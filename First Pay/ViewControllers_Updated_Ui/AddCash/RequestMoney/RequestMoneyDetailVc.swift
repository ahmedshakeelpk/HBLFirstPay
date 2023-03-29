//
//  RequestMoneyDetailVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS

class RequestMoneyDetailVc: BaseClassVC, UITextFieldDelegate, UITextViewDelegate {
    private let contactPicker = CNContactPickerViewController()
    var titleFetchObj : TitleFetchModel?
    var genResponseObj : GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        buttonContactList.setTitle("", for: .normal)
        buttonContinue.isUserInteractionEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imageNextArrow.addGestureRecognizer(tapGestureRecognizer)
        textFieldMobileNumber.delegate =  self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    
    @IBAction func textFieldMobileNumber(_ sender: UITextField) {
        if textFieldMobileNumber.text!.count < 11
        {
        let img = UIImage(named: "grayArrow")
        imageNextArrow.image = img
        buttonContinue.isUserInteractionEnabled = false
            imageNextArrow.isUserInteractionEnabled = false
      }
  else
   {
    let img = UIImage(named: "]greenarrow")
    imageNextArrow.image = img
     buttonContinue.isUserInteractionEnabled = true
      imageNextArrow.isUserInteractionEnabled = true
     }
}
                       
@IBOutlet weak var buttonContactList: UIButton!
                           
 @IBAction func buttonContactList(_ sender: UIButton) {
contactPicker.delegate = self
   self.present(contactPicker, animated: true, completion: nil)
    }
@objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
{
    requestMoneyTitleFetch()
}
@IBOutlet weak var buttonContinue: UIButton!
                           
  @IBAction func buttonContinue(_ sender: UIButton) {
//
    requestMoneyTitleFetch()
                }
   @IBOutlet weak var imageNextArrow: UIImageView!
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    
     let newLength = (textField.text?.count)! + string.count - range.length
    if textField == textFieldMobileNumber
        {
       return newLength <= 11
          }
      return newLength <= 11
    }
  
    // MARK: - API call
      
      public func requestMoneyTitleFetch(){
          
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
          userCnic = UserDefaults.standard.string(forKey: "userCnic")
          let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/titleFetchForRequestMoney"
          
          let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"mobileNo":self.textFieldMobileNumber.text!]
          
          let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
          print(result.apiAttribute1)
          print(result.apiAttribute2)
          
          let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
          let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
          print(params)
          print(parameters)
          print(compelteUrl)
          print(header)
          NetworkManager.sharedInstance.enableCertificatePinning()
          
          
          let sessionManger = APIs.shared.sessionManger(timeOut: 20)
          let error: Error!
          sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
              sessionManger.cancelAllRequests()
              let forecasts = Mapper<TitleFetchModel>().map(JSONObject: response.result)
              self.titleFetchObj = forecasts
//          NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<TitleFetchModel>) in
              
              self.hideActivityIndicator()
              
//              self.titleFetchObj = response.result.value
              if response.response?.statusCode == 200 {
                  if self.titleFetchObj?.responsecode == 2 || self.titleFetchObj?.responsecode == 1 {
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyConfirmationVc") as!   RequestMoneyConfirmationVc
                      vc.accountNo = self.titleFetchObj?.accountNo!
                      vc.accountTitle = self.titleFetchObj?.accountTitle!
                      self.navigationController?.pushViewController(vc, animated: true)
                  }
                  else {
                      if let message = self.titleFetchObj?.messages{
//                          self.showDefaultAlert(title: "", message: message)
                          UtilManager.showAlertMessage(message: message, viewController: self)
                        
                      }
                  }
              }
              else {
                  if let message = self.titleFetchObj?.messages{
//                      self.showDefaultAlert(title: "", message: message)
                      UtilManager.showAlertMessage(message: message, viewController: self)

                  }
  //                print(response.result.value)
  //                print(response.response?.statusCode)
              }
          }
      }
}
extension RequestMoneyDetailVc: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.textFieldMobileNumber.text = name

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
            self.textFieldMobileNumber.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}
