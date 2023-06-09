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
import AlamofireObjectMapper
import SwiftKeychainWrapper
import SideMenu
var isfromReactivateCard :Bool?
var isFromDeactivate : Bool?
var isFromChangePin : Bool?
var isfromActivate : Bool?
//var isfromServics : Bool?
var isfromATMON : Bool?
var isfromATMOFF : Bool?
var isfromPOSON : Bool?
var isfromPOSOFF: Bool?
var isfromDisableService : Bool?
var isfromServiceOTpVerification : Bool?
var isfromOTPHblmfb : Bool?
class DashBoardVC: BaseClassVC , UICollectionViewDelegate, UICollectionViewDataSource{
    var homeObj : HomeModel?
    var banObj : GenericResponse?
    var getDebitDetailsObj : GetDebitCardModel?
    var availableLimitObj: AvailableLimitsModel?
    var topBtnarr =  ["SendMoney", "Mobile Topup", "PayBill","First Option","DebitCard","SeeAll"]

    @IBOutlet weak var imgSeeAll: UIImageView!
    override func viewDidLoad() {
        FBEvents.logEvent(title: .Homescreen_Landing)
        super.viewDidLoad()
        banapi()
        collectionView.delegate = self
        collectionView.dataSource = self
       
        buttonLevelIcon.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoStatement(tapGestureRecognizer:)))
        lblAmount.isUserInteractionEnabled = true
        lblAmount.addGestureRecognizer(tapGestureRecognizerr)
        AddCash()
//        imgLevel.isHidden = true
        
        homeAction()
        let tapGestureRecognizerrs = UITapGestureRecognizer(target: self, action: #selector(MovetoAccountLevel(tapGestureRecognizer:)))
        imgLevel.isUserInteractionEnabled = true
        imgLevel.addGestureRecognizer(tapGestureRecognizerrs)
        
        
        let tapGestureRecognizr = UITapGestureRecognizer(target: self, action: #selector(moveToDebitCard(tapGestureRecognizer:)))
        viewDebitCard.isUserInteractionEnabled = true
        viewDebitCard.addGestureRecognizer(tapGestureRecognizr)
        
        let tapGestureRecognizrz = UITapGestureRecognizer(target: self, action: #selector(moveToInviteFriend(tapGestureRecognizer:)))
        imgInviteFriend.isUserInteractionEnabled = true
        imgInviteFriend.addGestureRecognizer(tapGestureRecognizrz)
        
        let tapGestureRecognizrzSeeAll = UITapGestureRecognizer(target: self, action: #selector(moveToSeeAll(tapGestureRecognizer:)))
        imgSeeAll.isUserInteractionEnabled = true
        imgSeeAll.addGestureRecognizer(tapGestureRecognizrzSeeAll)
        
//        getActiveLoan()
    }
    @IBOutlet weak var toggleMenu: UIImageView!
    @IBOutlet weak var imageAddCash: UIImageView!
    @IBOutlet weak var buttonLevelIcon: UIButton!
    @IBOutlet weak var viewDebitCard: UIImageView!
    
    
    @IBAction func buttonLevelIcon(_ sender: UIButton) {
        getAvailableLimits()
    }
    @IBAction func buttonInvite(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteAFriendsNAvigation")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    func AddCash(){
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(btnAddCash(tapGestureRecognizer:)))
        imageAddCash.isUserInteractionEnabled = true
        imageAddCash.addGestureRecognizer(tapGestureRecognizer3)
    }

    @objc func btnAddCash(tapGestureRecognizer: UITapGestureRecognizer) {
        FBEvents.logEvent(title: .Homescreen_addcash_click)
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
    
    @objc func buttontaped(_sender:UIButton) {
        let tag = _sender.tag
        
        let cell = collectionView.cellForItem(at: IndexPath(row: tag, section: 0)) as! cellmainfourTransaction
        if tag == 0 {
            FBEvents.logEvent(title: .Homescreen_sendmoney_click)
            let storyboard = UIStoryboard(name: "SendMoney", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SendMoney_MainVc")
            self.present(vc, animated: true)
        }
        else if tag == 1 {
            FBEvents.logEvent(title: .Homescreen_topup_click)
            let storyboard = UIStoryboard(name: "TopUp", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "movtToTopUp")
            self.present(vc, animated: true)
            
        }
        else if tag == 2 {
            FBEvents.logEvent(title: .Homescreen_paybills_click)
            let storyboard = UIStoryboard(name: "BillPayment", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "moveToBillpayment")

            self.present(vc, animated: true)
        }
        else if tag == 3 {
            FBEvents.logEvent(title: .Homescreen_getloan_click)
            getActiveLoan()
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if tag == 4 {
            getDebitCard()
        }
       
    }
    
    var modelNanoLoanEligibilityCheck: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? {
      didSet {
            if modelNanoLoanEligibilityCheck?.responsecode ?? 0 == 0 {
                showAlertCustomPopup(title: "Alert", message: modelNanoLoanEligibilityCheck?.messages ?? "", iconName: .iconError)
            }
            else {
                openNanoLoan()
            }
        }
    }
    
    func nanoLoanEligibilityCheck() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .nanoLoanEligibilityCheck, parameters: parameters) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? = APIs.decodeDataToObject(data: responseData)
            self.modelNanoLoanEligibilityCheck = model
        }
    }
    
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            
            if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
                self.openNanoLoan()
            }
            else {
                nanoLoanEligibilityCheck()
            }
        }
    }
    func getActiveLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .getActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelGetActiveLoan = model
        }
    }
    
    func openNanoLoan() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanContainer") as! NanoLoanContainer
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    var comabalanceLimit : String?
    func CommaSepration()
    {
        var number = Double(self.getCurrentBal!)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        comabalanceLimit = (formatter.string(from: NSNumber(value: number)))!
    }
    
    let pageIndicator = UIPageControl()
    var counter = 0
    var banArray = [UIImage]()
    var timer = Timer()
    var banaryyString =  [String]()
    
    @IBOutlet weak var buttonInvite: UIButton!
    
    @IBOutlet weak var imgLevel: UIImageView!
    
    @IBOutlet weak var imgInviteFriend: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var LblMobNo: UILabel!
    @IBOutlet weak var img: UIImageView!
   
    @objc func changeImage() {
        
        if counter < self.banaryyString.count {
            
            let index = IndexPath.init(item: counter, section: 0)
            
            let url = self.banaryyString[counter].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            let url = self.banaryyString[counter].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
            counter = 1
        }
        
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
//
        getCurrentBal =  homeObj?.userData?[0].currentBalance
        CommaSepration()
        lblAmount.text =   "Rs.\(comabalanceLimit!)"
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
            DataManager.instance.accountLevel = "LEVEL 1"
            imgLevel.image = UIImage(named: "Verified 24x")
        }
        else
        {
            imgLevel.isHidden = false
            DataManager.instance.accountLevel = "LEVEL 0"
            imgLevel.image = UIImage(named: "Un-Verified 24x")
        }
        
     
        //        NotificationCenter.default.addObserver(self, selector: #selector(updateProfilePhoto), name: Notification.Name("batteryLevelChanged"), object: nil)
    }
    
    func banapi ()
    {
//<<<<<<< HEAD
//=======
////        getActiveLoan()
//>>>>>>> f3b7f8f (ui fixex)
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
      
    @objc func moveToDebitCard(tapGestureRecognizer: UITapGestureRecognizer)
    {
        getDebitCard()
    }
    
    
    @objc func moveToInviteFriend(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendsAddNumber") as! InviteFriendsAddNumber
        self.present(vc, animated: true)
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToSeeAll(tapGestureRecognizer: UITapGestureRecognizer) {
        FBEvents.logEvent(title: .Homescreen_seeall_click)

    }
    
    @objc func MovetoAccountLevel(tapGestureRecognizer: UITapGestureRecognizer) {
        getAvailableLimits()
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
                        
                        if self.getDebitDetailsObj?.newCarddata != nil{
                            if
                                self.getDebitDetailsObj?.newCarddata?.apiFlow == "NewCard"
                            {
                                let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "moveToDebitCard")
                                self.present(vc, animated: true)
                            }
                            else if self.getDebitDetailsObj?.newCarddata?.apiFlow == "DeactivateCard"
                            {
                                
                                let storyboard = UIStoryboard(name: "DebitCard", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "movetoCardDeactivation")
                                self.present(vc, animated: true)
                                
                            }
                        }
                        
                    }
                    
                }
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)


                    }
                }
            }
            else {
                if let message = self.getDebitDetailsObj?.messages{
                    self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    ////    ----------getaccountlimits
        private func getAvailableLimits() {
      //
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
            userCnic = UserDefaults.standard.string(forKey: "userCnic")
      
      //        let compelteUrl = GlobalConstants.BASE_URL + "getAccLimits"
              let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLevelLimits"
      
              let parameters : Parameters = ["cnic":userCnic!, "accountType" : DataManager.instance.accountType ?? "20", "imeiNo": DataManager.instance.imei!,"channelId": DataManager.instance.channelID ]
      
              print(parameters)
      
      
              let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
      
              let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
      
      
              let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
      
              print(params)
              print(compelteUrl)
      
      
              NetworkManager.sharedInstance.enableCertificatePinning()
      
      
              NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<AvailableLimitsModel>) in
      
                  self.hideActivityIndicator()
      
                  self.availableLimitObj = response.result.value
      
                  if response.response?.statusCode == 200 {
      
                      if self.availableLimitObj?.responsecode == 2 || self.availableLimitObj?.responsecode == 1 {
      
                          self.updateUI()
      //                                    self.fromlevel1()
                      }
                      else {
                          if let message = self.availableLimitObj?.messages{
                              self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                          }
                      }
                  }
                  else {
                      if let message = self.availableLimitObj?.messages{
                          self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                      }
    //                  print(response.result.value)
    //                  print(response.response?.statusCode)
                  }
              }
          }
    private func updateUI(){
        
        if DataManager.instance.accountLevel == "LEVEL 0" {
            FBEvents.logEvent(title: .Homescreen_Myaccount_click)

            let vc = UIStoryboard(name: "AccountLevel", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountLimitsVc") as! MyAccountLimitsVc
            if let balnceLimit = self.availableLimitObj?.limitsData?.levelLimits?[0].balanceLimit{
                vc.balanceLimit = Int(balnceLimit)
                print("balnceLimit",balnceLimit)
            }
            if let balnceLimit1 = self.availableLimitObj?.limitsData?.levelLimits?[1].balanceLimit{
                vc.balanceLimit1 = Int(balnceLimit1)
                print("balnceLimit",balnceLimit1)
            }
            
            if let dailyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitCr{
                vc.totalDailyLimitCr = Int(dailyTotalCr)
            }
            if let dailyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitCr{
                vc.totalDailyLimitCr1 = Int(dailyTotalCr1)
            }
            if let monthlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr = Int(monthlyTotalCr)
            }
            if let monthlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr1 = Int(monthlyTotalCr1)
            }
            if let yearlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitCr{
                vc.totalYearlyLimitCr = Int(yearlyTotalCr)
            }
            if let yearlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitCr{
                vc.totalYearlyLimitCr1 = Int(yearlyTotalCr1)
            }
            if let  totalDailyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitDr{
                vc.totalDailyLimitDr = Int(totalDailyLimitDr)
            }
            if let  totalDailyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitDr{
                vc.totalDailyLimitDr1 = Int(totalDailyLimitDr1)
            }
            if let  totalMonthlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr = Int(totalMonthlyLimitDr)
            }
            if let totalMonthlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr1 = Int(totalMonthlyLimitDr1)
            }
            if let totalYearlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitDr{
                vc.totalYearlyLimitDr = Int(totalYearlyLimitDr)
            }
            if let  totalYearlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitDr{
                vc.totalYearlyLimitDr1 = Int(totalYearlyLimitDr1)
            }
            self.present(vc, animated: true)
        }
        else if DataManager.instance.accountLevel == "LEVEL 1" {
            FBEvents.logEvent(title: .Homescreen_Myaccount_click)
            let vc = UIStoryboard(name: "AccountLevel", bundle: Bundle.main).instantiateViewController(withIdentifier: "VerifiedAccountVC") as! VerifiedAccountVC
            if let balnceLimit = self.availableLimitObj?.limitsData?.levelLimits?[0].balanceLimit{
                vc.balanceLimit = Int(balnceLimit)
                print("balnceLimit",balnceLimit)
            }
            if let balnceLimit1 = self.availableLimitObj?.limitsData?.levelLimits?[1].balanceLimit{
                vc.balanceLimit1 = Int(balnceLimit1)
                print("balnceLimit",balnceLimit1)
            }
            
            if let dailyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitCr{
                vc.totalDailyLimitCr = Int(dailyTotalCr)
            }
            if let dailyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitCr{
                vc.totalDailyLimitCr1 = Int(dailyTotalCr1)
            }
            
            
            if let monthlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr = Int(monthlyTotalCr)
            }
            if let monthlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitCr{
                vc.totalMonthlyLimitCr1 = Int(monthlyTotalCr1)
            }
            
            
            if let yearlyTotalCr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitCr{
                vc.totalYearlyLimitCr = Int(yearlyTotalCr)
            }
            if let yearlyTotalCr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitCr{
                vc.totalYearlyLimitCr1 = Int(yearlyTotalCr1)
            }
            
            //        dr
            if let  totalDailyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalDailyLimitDr{
                vc.totalDailyLimitDr = Int(totalDailyLimitDr)
            }
            if let  totalDailyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalDailyLimitDr{
                vc.totalDailyLimitDr1 = Int(totalDailyLimitDr1)
            }
            if let  totalMonthlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr = Int(totalMonthlyLimitDr)
            }
            if let  totalMonthlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalMonthlyLimitDr{
                vc.totalMonthlyLimitDr1 = Int(totalMonthlyLimitDr1)
            }
            if let  totalYearlyLimitDr = self.availableLimitObj?.limitsData?.levelLimits?[0].totalYearlyLimitDr{
                vc.totalYearlyLimitDr = Int(totalYearlyLimitDr)
            }
            if let  totalYearlyLimitDr1 = self.availableLimitObj?.limitsData?.levelLimits?[1].totalYearlyLimitDr{
                vc.totalYearlyLimitDr1 = Int(totalYearlyLimitDr1)
            }
            self.present(vc, animated: true)
        }
    }
    
//class end
}
    
    

    
    

