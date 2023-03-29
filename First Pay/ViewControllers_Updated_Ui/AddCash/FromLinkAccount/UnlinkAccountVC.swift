//
//  UnlinkAccountVC.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class UnlinkAccountVC: BaseClassVC {
    var flag = "false"
    var genericResponseObj : GenericResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
//        blurView.alpha = 0.4
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizers)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Delink(tapGestureRecognizer:)))
        imgUnlinkAccount.isUserInteractionEnabled = true
        imgUnlinkAccount.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        imgCancel.isUserInteractionEnabled = true
        imgCancel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imgUnlinkAccount: UIImageView!
    @IBOutlet weak var imgCancel: UIImageView!
    
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var labelDelink: UILabel!
    @objc func Delink(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imgUnlinkAccount.image = image
            labelDelink.textColor = UIColor(hexValue: 0xCC6801)
            flag  = "false"
            
        }
        
        
        else{
            let image = UIImage(named: "Rectangle Orange")
            imgUnlinkAccount.image = image
            labelCancel.textColor = .white
            imgUnlinkAccount.contentMode =  .scaleToFill
            
            let emptyimage = UIImage(named: "Rectangle 6")
            imgCancel.image = emptyimage
            labelCancel.textColor =  UIColor(hexValue: 0xCC6801)
            flag = "true"
//            api cslling
            getLinkAccounts()
        }
     
    }
    
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/deLinkAccount"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!,"accountNo":DataManager.instance.accountNo!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GenericResponseModel>) in
            
            
            self.hideActivityIndicator()
            self.genericResponseObj = response.result.value
            if response.response?.statusCode == 200 {
            
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "DelinkSuccessfullVC") as! DelinkSuccessfullVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.showAlert(title: "", message: (self.genericResponseObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }

    
    
}
