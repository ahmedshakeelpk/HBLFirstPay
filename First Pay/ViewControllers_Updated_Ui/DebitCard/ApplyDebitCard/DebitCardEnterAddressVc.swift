//
//  DebitCardEnterAddressVc.swift
//  First Pay
//
//  Created by Irum Butt on 09/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class DebitCardEnterAddressVc: BaseClassVC, UITextFieldDelegate {
    var Address : String?
    var genericObj:GenericResponse?
    var fullUserName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonBack.setTitle("", for: .normal)
        buttonEdit.setTitle("", for: .normal)
        textFieldAddress.delegate  = self
        buttonContinue.isUserInteractionEnabled = false
        imageNextArrow.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToNext(tapGestureRecognizer:)))
        imageNextArrow.isUserInteractionEnabled = true
        imageNextArrow.addGestureRecognizer(tapGesture)
        labelName.text = fullUserName
        
        
        // Do any additional setup after loading the view.
    }
    @objc func moveToNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardPostalAddressConfirmationVC") as!  DebitCardPostalAddressConfirmationVC
        vc.fullUserName = self.fullUserName!
        vc.address = self.textFieldAddress.text!
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldAddress.text?.count != 0
        {
            buttonContinue.isUserInteractionEnabled = true
            imageNextArrow.image = UIImage(named: "]greenarrow")
            imageNextArrow.isUserInteractionEnabled = true
            Address  = textFieldAddress.text
            
        }
        else
        {
            buttonContinue.isUserInteractionEnabled = false
            imageNextArrow.image = UIImage(named: "grayArrow")
            imageNextArrow.isUserInteractionEnabled = false
        }
    }

    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBAction func ButtonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonEdit(_ sender: UIButton) {
        textFieldAddress.text = ""
        Address  = textFieldAddress.text
    }
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBOutlet weak var ButtonBack: UIButton!
    
    @IBOutlet weak var imageNextArrow: UIImageView!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardPostalAddressConfirmationVC") as!  DebitCardPostalAddressConfirmationVC
        vc.fullUserName = self.fullUserName!
        vc.address = self.textFieldAddress.text!
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    // MARK: - Api Call
   
   private func debitCardRequest() {
       
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
       
       
       let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getResponseOfDebitCardCreation"
       userCnic = UserDefaults.standard.string(forKey: "userCnic")
       let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"otp":"","channelId":"\(DataManager.instance.channelID)","NameonCard":fullUserName!,"deliveryType": "H","deliveryAddress":textFieldAddress.text!, "branchCode":""]

       let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
       print(result.apiAttribute1)
       print(result.apiAttribute2)
       
       let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
       
       let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
       print(params)
       print(compelteUrl)
       
       NetworkManager.sharedInstance.enableCertificatePinning()
       let sessionManger = APIs.shared.sessionManger(timeOut: 20)
       let error: Error!
       sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
           sessionManger.cancelAllRequests()
           let forecasts = Mapper<GenericResponse>().map(JSONObject: response.result)
           self.genericObj = forecasts
//       NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
           
           
           self.hideActivityIndicator()
           
//           self.genericObj = response.result.value
           if response.response?.statusCode == 200 {
               
               if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardPostalAddressConfirmationVC") as!  DebitCardPostalAddressConfirmationVC
                   vc.fullUserName = self.fullUserName!
                   vc.address = self.textFieldAddress.text!
        
                   self.navigationController?.pushViewController(vc, animated: true)
                   
               }
               else {
                   if let message = self.genericObj?.messages{
                       self.showDefaultAlert(title: "", message: message)
                   }
               }
           }
           else {
               if let message = self.genericObj?.messages{
                   self.showDefaultAlert(title: "", message: message)
               }
//
           }
       }
   }
    
    
}
