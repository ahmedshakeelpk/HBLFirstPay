//
//  DebitCardPostalAddressConfirmationVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class DebitCardPostalAddressConfirmationVC: BaseClassVC {
    var fullUserName : String?
    var genericObj:GenericResponse?
    var address : String?
    var cardFee : String?
    var totalFee: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBack.setTitle("", for: .normal)
        blurview.isHidden = true
        imagePopup.isHidden = true
        blurview.alpha = 0.7
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToNext(tapGestureRecognizer:)))
        imagePopup.isUserInteractionEnabled = true
        imagePopup.addGestureRecognizer(tapGesture)
       updateui()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var labelTotalFee: UILabel!
    @IBOutlet weak var labelCardFee: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageNextArrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBOutlet weak var imagePopup: UIImageView!
    @IBOutlet weak var blurview: UIView!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        
        debitCardRequest()
        
    }
    
    
    
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func moveToNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
    
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }
    func updateui()
    {
        labelName.text = GlobalData.debitCardUserFullName
        labelAddress.text = address
        labelCardFee.text = debitCardFee
        labelTotalFee.text = debitCardFeeDeliveryCharges
        labelMobileNumber.text = DataManager.instance.accountNo
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
       let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"otp":"","channelId":"\(DataManager.instance.channelID)","NameonCard":fullUserName!,"deliveryType": "H","deliveryAddress":address!, "branchCode":""]

       let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
       print(result.apiAttribute1)
       print(result.apiAttribute2)
       
       let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
       
       let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
       print(params)
       print(compelteUrl)
       
       NetworkManager.sharedInstance.enableCertificatePinning()
       
       NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
           
           
           self.hideActivityIndicator()
           
           self.genericObj = response.result.value
           if response.response?.statusCode == 200 {
               
               if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                   self.blurview.isHidden = false
                   self.imagePopup.isHidden = false
                  
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
