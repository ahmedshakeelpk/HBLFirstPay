//
//  Fetcing_OTP_VC.swift
//  First Pay
//
//  Created by Irum Butt on 01/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class Fetcing_OTP_VC: BaseClassVC {
    var mobileRegistrationObj : mobileRegistrationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPhoneNo.text = DataManager.instance.mobNo
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let OTPVerifyVC = self.storyboard?.instantiateViewController(withIdentifier: "OTP_Mobile_VerificationVC") as! OTP_Mobile_VerificationVC
            self.navigationController?.pushViewController(OTPVerifyVC, animated: true)
        }

//        getIMEIAddress()
//        getWiFiAddress()
//        getIPAddressmac()
//        mobileRegistration()
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var lblPhoneNo: UILabel!
    //MARK: - Get IP Address
    
    override func getWiFiAddress() -> [String] {
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    // MARK: - Get IMEI
    func getIMEIAddress(){

        let str = String(describing: UIDevice.current.identifierForVendor!)
        let replacedImei = str.replacingOccurrences(of: "-", with: "")
        DataManager.instance.imei = replacedImei
//        print(replacedImei)

        _ = KeyChainUtils.getUUID()!
//         print(udid)

    }
    func getIPAddressmac(){
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
    }
    private func  mobileRegistration() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        
        

        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/mobileRegistration"

        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo":(DataManager.instance.mobNo),"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
//
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<mobileRegistrationModel>) in
  
            self.hideActivityIndicator()
            
            self.mobileRegistrationObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.mobileRegistrationObj?.responsecode == 2 || self.mobileRegistrationObj?.responsecode == 1 {
                    let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTP_Mobile_VerificationVC") as! OTP_Mobile_VerificationVC
                   
                    if let accessToken = self.mobileRegistrationObj?.data?.token{
                        DataManager.instance.AuthToken = accessToken
                    }
                    self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                }
                else {
                    if let message = self.mobileRegistrationObj?.messages{
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
                if let message = self.mobileRegistrationObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                else {
                    self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
}
