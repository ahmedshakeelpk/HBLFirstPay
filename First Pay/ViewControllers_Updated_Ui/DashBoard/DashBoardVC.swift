//
//  DashBoardVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import RNCryptor
import Kingfisher
import CryptoSwift
import SDWebImage
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import SideMenu
var isfromReactivateCard :Bool?
var isFromDeactivate : Bool?
var isFromChangePin : Bool?
var isfromActivate : Bool?
class DashBoardVC: BaseClassVC , UICollectionViewDelegate, UICollectionViewDataSource{
    var homeObj : HomeModel?
    var banObj : GenericResponse?
    var getDebitDetailsObj : GetDebitCardModel?
   
    var topBtnarr =  ["SendMoney", "Mobile Topup", "PayBill","First Option","DebitCard","SeeAll"]

    override func viewDidLoad() {
        super.viewDidLoad()
        banapi()
        collectionView.delegate = self
        collectionView.dataSource = self
        btnPageControl.setTitle("", for: .normal)
       
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoStatement(tapGestureRecognizer:)))
        lblAmount.isUserInteractionEnabled = true
        lblAmount.addGestureRecognizer(tapGestureRecognizerr)
        AddCash()
        imgLevel.isHidden = true
        
        homeAction()
//       tapGestures()
//        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoadCustom), name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
//        
    }
    @IBOutlet weak var toggleMenu: UIImageView!
    
    @IBOutlet weak var imageAddCash: UIImageView!
    
    func AddCash(){
        
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(btnAddCash(tapGestureRecognizer:)))
        imageAddCash.isUserInteractionEnabled = true
        imageAddCash.addGestureRecognizer(tapGestureRecognizer3)
    }

    @objc func btnAddCash(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyBoard = UIStoryboard(name: Storyboard.AddCash.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "navigateToAddCash")
        self.present(vc, animated: true)
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topBtnarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cella = collectionView .dequeueReusableCell(withReuseIdentifier: "cellmainfourTransaction", for: indexPath) as! cellmainfourTransaction
        cella.btn.setTitle("", for: .normal)
        cella.btn.tag = indexPath.row
        cella.img.image = UIImage(named: topBtnarr[indexPath.row])
        cella.btn.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
        //        cella.img.image = topBtnarr[indexPath.row
        return cella
    }
    
    @objc func buttontaped(_sender:UIButton)
    {
        
        let tag = _sender.tag
        
        let cell = collectionView.cellForItem(at: IndexPath(row: tag, section: 0)) as! cellmainfourTransaction
        if tag == 0
        {
            let storyboard = UIStoryboard(name: "SendMoney", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SendMoney_MainVc")
          
            self.present(vc, animated: true)
        }
        else if tag == 1
        {
//            movtToTopUp
//            let  myDict = [ "name": "MobileTopUpVC"]
//                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)
//            let storyboard = UIStoryboard(name: "TopUp", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "MobileTopUpVC")
//            self.present(vc, animated: true)
            
            
            
            let storyboard = UIStoryboard(name: "TopUp", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "movtToTopUp")
            self.present(vc, animated: true)
            
        }
        else if tag == 2
        {
            
            let storyboard = UIStoryboard(name: "BillPayment", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "moveToBillpayment")

            self.present(vc, animated: true)
        }
        
        else if tag == 4
        {
            
            getDebitCard()
            
        }
       
    }
    
    let pageIndicator = UIPageControl()
    var counter = 0
    var banArray = [UIImage]()
    var timer = Timer()
    var banaryyString =  [String]()
    
    
    @IBOutlet weak var imgLevel: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var LblMobNo: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnPageControl: UIButton!
    override func viewWillAppear(_ animated: Bool) {
       
        
//        homeAction()
    }
    @objc func changeImage() {
        
        if counter < self.banaryyString.count {
            
            let index = IndexPath.init(item: counter, section: 0)
            
            let url = self.banaryyString[counter]
            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "HomeBanner"))
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            let url = self.banaryyString[counter]
            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "HomeBanner"))
            counter = 1
        }
        
    }

    @objc func viewDidLoadCustom() {
        

        
        
    }
    func homeAction() {
        showActivityIndicator()
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        //        showActivityIndicator()
        
        //        let compelteUrl = GlobalConstants.BASE_URL + "home"
        //
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/home"
        // IPA Paramsself    FirstPay.DashBoardVC    0x00007fbba2061000
        let params = ["":""] as [String : Any]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken  ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<HomeModel>) in
            
            self.homeObj = response.result.value
            
            if response.response?.statusCode == 200 {
                self.homeObj = response.result.value
                if self.homeObj?.responsecode == 2 || self.homeObj?.responsecode == 1 {
                    
                    self.saveInDataManager(index: 0)
                    self.hideActivityIndicator()
//                    banapi()
//
                }
                else {
                    if let message = self.homeObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                //                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
                                print(response.result.value)
                                print(response.response?.statusCode)
            }
        }
    }
    var getCurrentBal : Double?
    private func saveInDataManager(index : Int){
        getCurrentBal = homeObj?.userData?[0].currentBalance
        
        lblAmount.text =   "\(getCurrentBal!)"
        
        lblName.text =  homeObj?.userData?[0].accountTitile
        LblMobNo.text =  homeObj?.userData?[0].accountNo
        DataManager.instance.mobile_number = homeObj?.userData?[0].accountNo
        DataManager.instance.accountTitle =
        homeObj?.userData?[0].accountTitile
        DataManager.instance.accountNo =
        homeObj?.userData?[0].accountNo
                DataManager.instance.balancedate = homeObj?.userData?[0].balanceDate
       
                DataManager.instance.lastamount = Int(self.homeObj?.userData?[index].lasttransamt ?? 0)
                DataManager.instance.customerId = self.homeObj?.userData?[index].customerId
                DataManager.instance.firstName = self.homeObj?.userData?[index].firstName
                DataManager.instance.lastName = self.homeObj?.userData?[index].lastName
                DataManager.instance.middleName = self.homeObj?.userData?[index].middleName
                DataManager.instance.accountId = self.homeObj?.userData?[index].accountId
                DataManager.instance.accountAlias = self.homeObj?.userData?[index].accountAlias
                DataManager.instance.accountNo = self.homeObj?.userData?[index].accountNo
                DataManager.instance.balanceDate = self.homeObj?.userData?[index].balanceDate
                DataManager.instance.currentBalance = self.homeObj?.userData?[index].currentBalance
                DataManager.instance.accountType = self.homeObj?.userData?[index].accountType
                DataManager.instance.serverAccountTitile = self.homeObj?.userData?[index].accountTitile
                DataManager.instance.insured = self.homeObj?.userData?[index].insured
        
        
        var accountName : String?
        if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
            accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
            DataManager.instance.accountTitle = accountName
            var accountype : String?
            if KeychainWrapper.standard.hasValue(forKey: "accounttype"){
                DataManager.instance.accountType = accountype
            }
            
            
        }
        else {
            DataManager.instance.accountTitle = self.homeObj?.userData?[index].accountTitile
        }
        DataManager.instance.accountType = self.homeObj?.userData?[index].accountType
        print("Account Type is ",  DataManager.instance.accountType as Any)
        if self.homeObj?.userData?[index].levelDescr == "LEVEL 1"
        {
            imgLevel.isHidden = false
            imgLevel.image = UIImage(named: "Group 427321140")
        }
     
        //        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePhoto), name: Notification.Name("batteryLevelChanged"), object: nil)
    }
    
    func banapi ()
    {
        
        // let token = "eWptR0NMbk43RlBINWJCM1JjbWtSc0g1TWFzNFZHVGMgOm1MSzM1WEd3bUtHUFpRclM="
        
        ServerManager.GEt_typeWithoutParmsfetchApiData_PostAppJSON(APIMethodName: APIMethods.banner.rawValue, Token: DataManager.instance.accessToken ?? "" ) { [self] (Result : MYBanersModel?) in
            
            //== check if api is responding or not
            guard Result != nil else {
                //                UtilManager.showAlertMessage(message: "No Internet Connection...", viewController: self)
                
                return
            }
            
            GlobalData.banner = Result!
            print("Result",Result!)
            print("token is :",GlobalData.banner.data[0].brandCode)
            if GlobalData.banner.responsecode == 1 {
                for data in GlobalData.banner.data {
                    if data.banner != nil {
                        self.banaryyString.append(data.banner!) //step2
                        
                    }
                    
                }
                print("ban array is",banaryyString)
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                
            }
           
            
            
        }
        
    }
    
    @objc func MovetoStatement(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let storyboard = UIStoryboard(name: "MiniStatement", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MinistatemnetMainVc")
        self.present(vc, animated: true)
    }
       
    
    // MARK: - Api Call
    var checkDebitCardObj : GetDebitCardCheckModel?
    private func getDebitCardCheck() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/debitCardEligibilityCheck"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetDebitCardCheckModel>) in
            self.hideActivityIndicator()
            self.checkDebitCardObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.checkDebitCardObj?.responsecode == 2 || self.checkDebitCardObj?.responsecode == 1 {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "moveToDebitCard")
                            self.present(vc, animated: true)
                }
                  else
                    {
                      if let message = self.checkDebitCardObj?.messages
                      {
                          if message == "Debit Card Already Exists"
                          {
                              let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                              let vc = storyboard.instantiateViewController(withIdentifier: "movetoDebitCardActivate")
                              self.present(vc, animated: true)
                          }

                  }
                      
                  }
                      
                  
              
                }
              
                }
            
        
    }
    
    private func getDebitCard() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getDebitCards"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetDebitCardModel>) in
            
            self.hideActivityIndicator()
            
            self.getDebitDetailsObj = response.result.value
            print(self.getDebitDetailsObj)
        
            if response.response?.statusCode == 200 {
               
                if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                    if self.getDebitDetailsObj?.debitCardData != nil{
                        GlobalData.accountDebitCardId = self.getDebitDetailsObj?.debitCardData?[0].accountDebitCardId
                       
                        if self.getDebitDetailsObj?.debitCardData?[0].apiFlow == "ActivateCard"
                        {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "movetoDebitCardActivate")
                            self.present(vc, animated: true)
                        }
                        else if self.getDebitDetailsObj?.debitCardData?[0].apiFlow == "DeactivateCard"
                        {
                            
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "movetoCardDeactivation")
                           isFromDeactivate  = true
                            self.present(vc, animated: true)
                            
                            
                        }
                        else if self.getDebitDetailsObj?.debitCardData?[0].apiFlow == "ReactivateCard"
                        {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "movetoDebitCardActivate")
                            isfromReactivateCard = true
                            self.present(vc, animated: true)
                        }
         
                    }
                    else
                    {
                        if
                            self.getDebitDetailsObj?.newCarddata?.apiFlow == "NewCard"
                        {
                            let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "moveToDebitCard")
                            self.present(vc, animated: true)
                        }
                    }
                    
                }
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                        UtilManager.showToast(message: message)


                    }
                }
            }
            else {
                if let message = self.getDebitDetailsObj?.messages{
                    UtilManager.showToast(message: message)
                    
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
//class end
}
    
    

    
    

