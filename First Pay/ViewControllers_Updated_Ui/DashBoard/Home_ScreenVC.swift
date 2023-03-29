////
////  Home_ScreenVC.swift
////  First Pay
////
////  Created by Irum Butt on 15/12/2022.
////  Copyright © 2022 FMFB Pakistan. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import ObjectMapper
//import SwiftKeychainWrapper
//import RNCryptor
//import Kingfisher
//import CryptoSwift
//import SDWebImage
//class Home_ScreenVC: BaseClassVC {
//    let pageIndicator = UIPageControl()
//    let encryptionkey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpbWXRfeFXfeb1zVMJi/fcb7K1R42HW8kfdVf1QGVw7wCB1pT+PC8TuQYGG+YR3fZy9+jqfwgE1xkPDMvNdXh6zftG/SpvrmjD2nh1unCkKYGpj2RsCp81rME4pWpy8Nit9JjIiwOs1P+DBTQgAtGi115EkXS49t0JnZPDvPf50QIDAQAB"
////    var checkEmailVerificationObj : checkEmailVerification?
//    var counter = 0
//    var banArray = [UIImage]()
////    var promotion_arr = ["Group 427320661.png","image 283.png"]
//   
//    
//    var Bill_promtion_Arr = [String]()
//    var timer = Timer()
//    var swipeGesture = UISwipeGestureRecognizer()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        banapi()
//        Homebtn.setTitle("", for: .normal)
//        btnmain.setTitle("", for: .normal)
//        btnQuestion.setTitle("", for: .normal)
//        btnProfile.setTitle("", for: .normal)
//        btnNotification.setTitle("", for: .normal)
//        btn_TransactionSend.setTitle("", for: .normal)
//        btn_transactionRecieved.setTitle("", for: .normal)
//        btnRecentTransation.setTitle("SEE ALL", for: .normal)
//
//        btnAddCash.setTitle("", for: .normal)
//        Collectionview_Billpayments.delegate = self
//        Collectionview_Billpayments.dataSource = self
//        COLLECTIONVIEWFavourite.delegate = self
//        COLLECTIONVIEWFavourite.dataSource = self
////        checkEmailVerification()
//    
//    }
//    
//    @IBOutlet weak var Collectionview_Billpayments: UICollectionView!
//    @IBOutlet weak var Homebtn: UIButton!
//    @IBOutlet weak var lbl_Username: UILabel!
//    @IBOutlet weak var lbl_mobileno: UILabel!
//    @IBOutlet weak var lbl_Amount: UILabel!
//    @IBOutlet weak var btnRecentTransation: UIButton!
//    @IBOutlet weak var imgView_UserProfile: UIImageView!
//    @IBOutlet weak var btnAddCash: UIButton!
//    @IBOutlet weak var lbl_Billpayments: UILabel!
//    
//    @IBOutlet weak var img: UIImageView!
//    @IBOutlet weak var COLLECTIONVIEWFavourite: UICollectionView!
//    @IBOutlet weak var lblRecentTransation: UILabel!
//    @IBOutlet weak var homeView: UIView!
//    @IBOutlet weak var btnNotification: UIButton!
//    @IBOutlet weak var notificationView: UIView!
//    @IBOutlet weak var viewQuestionmark: UIView!
//    @IBOutlet weak var btnmain: UIButton!
//    @IBOutlet weak var MainView: UIView!
//    @IBOutlet weak var btn_transactionRecieved: UIButton!
//    @IBOutlet weak var btn_TransactionSend: UIButton!
//   
//    @IBOutlet weak var btnProfile: UIButton!
//    @IBOutlet weak var viewprofile: UIView!
//    @IBOutlet weak var btnQuestion: UIButton!
//    @IBAction func Action_Home(_ sender: UIButton) {
//        homeView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        MainView.backgroundColor = .clear
//    }
//    
//    @IBAction func Action_Notification(_ sender: UIButton) {
//        notificationView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        homeView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        MainView.backgroundColor = .clear
//    }
//    
//
//    @IBAction func Action_Main(_ sender: UIButton) {
//        MainView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        homeView.backgroundColor = .clear
//    }
//    
//
//    @IBAction func Action_QuestionMark(_ sender: UIButton) {
//        viewQuestionmark.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        homeView.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        MainView.backgroundColor = .clear
//    }
//    
//    
//    @IBAction func Action_Profile(_ sender: UIButton) {
//        viewprofile.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        homeView.backgroundColor = .clear
//        MainView.backgroundColor = .clear
//        let storyboard = UIStoryboard(name: "ContactUs", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUSVC")
//        self.present(vc, animated: true)
////        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    @IBAction func Action_AddCash(_ sender: UIButton) {
//    }
//    
//    @IBAction func Action_Seeall_RecenTransation(_ sender: UIButton) {
//        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "OtherServices_VC") as! OtherServices_VC
//        self.present(vc, animated: true)
//        
//        
//        
//    }
//   
//    
//    @objc func changeImage() {
//        
//        if counter < self.banArray.count {
//            
//            let index = IndexPath.init(item: counter, section: 0)
//            
//            
//            img.image = self.banArray[counter]
//            counter += 1
//        } else {
//            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            
//            
//            img.image = self.banArray[counter]
//            counter = 1
//        }
//        //        changeImage()
//    }
//    func banapi ()
//    {
//        
//        // let token = "eWptR0NMbk43RlBINWJCM1JjbWtSc0g1TWFzNFZHVGMgOm1MSzM1WEd3bUtHUFpRclM="
//        
//        ServerManager.GEt_typeWithoutParmsfetchApiData_PostAppJSON(APIMethodName: APIMethods.banner.rawValue, Token: DataManager.instance.accessToken ?? "" ) { [self] (Result : MYBanersModel?) in
//            
//            //== check if api is responding or not
//            guard Result != nil else {
////                UtilManager.showAlertMessage(message: "No Internet Connection...", viewController: self)
//                
//                return
//            }
//            
//            GlobalData.banner = Result!
//            print("Result",Result!)
//            print("token is :",GlobalData.banner.data[0].brandCode)
//            if GlobalData.banner.responsecode == 1 {
//                for data in GlobalData.banner.data {
//                    if data.banner != nil {
////                        if data.banner != "" {
////                            let imgUrl = URL(string:  data.banner!)
////                            print(imgUrl?.absoluteString)
////                            var image = UIImageView()
//////                            image.sd_setImage(with: imgUrl, completed: nil)
////                            image.sd_setImage(with: (imgUrl), placeholderImage: UIImage(named: "path0"))
////                            self.banArray.append(image.image!)
////                        }
//                        
//                        
//                        let profilepic = data.banner
//                        if profilepic != "" {
//                           
//                            let url = URL(string:(profilepic!))
//                            if let url = url {
//                                           KingfisherManager.shared.retrieveImage(with:url as Resource, options: nil, progressBlock: nil ){ (image,error,cache, imageurl) in
//                                               if(error == nil){
//                                                   self.banArray.append(image!)
//                                                   
//                                                   print("done")
//                                                   
//                                               }else{
//                                                   print("error", error)
//                                               }
//                                              
//                                               
//                                           }
//                                       }            //
//                        }
//
//                    }
//                        
//                    }
//                    print("ban array is",banArray)
//                    
//                }
////                self.sliderCollectionView.delegate = self
////                self.sliderCollectionView.dataSource = self
//                
//                DispatchQueue.main.async {
//                    self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//                }
//                
//            }
//            
//        }
//        
//    
//    //
//    
//    
//    
//    
//    
//    
//    private  func checkEmailVerification() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        showActivityIndicator()
//        var userCnic : String?
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//        
//        let compelteUrl = GlobalConstants.BASE_URL + "v2/checkEmailVerification"
//        
//        print(compelteUrl)
////        print("user email already", DataManager.instance.UserEmail)
//        print("user userUUID already", DataManager.instance.userUUID)
//        
//        
//      
//
//        
//         
//        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "channelId" : DataManager.instance.channelID, ] as [String : Any]
//        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        
//        
//        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
//        let paramsencoded = ["ApiAttribute1":  result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\("2")"]
//        print("encryption done",paramsencoded )
//        
//        
//        print(paramsencoded)
//        
//        print(params)
//        print(compelteUrl)
//        print(header)
//        
//        
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<checkEmailVerification>) in
//            
//            
//            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
//            
//            self.hideActivityIndicator()
//            
//            self.checkEmailVerificationObj = response.result.value
//            
//            if response.response?.statusCode == 200 {
//             
//            self.checkEmailVerificationObj = response.result.value
//                if self.checkEmailVerificationObj?.responsecode == 2 || self.checkEmailVerificationObj?.responsecode == 1 {
//                    DataManager.instance.Checkemail = self.checkEmailVerificationObj?.EmailData?.checkEmail
//                    DataManager.instance.CheckEmailVerified = self.checkEmailVerificationObj?.EmailData?.checkEmailVerified
//                    
//        }
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
////    end
//        
//}
//    
//
//
//extension Home_ScreenVC: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//        
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////
////        let size = Collectionview_RecentTransaction.frame.size
////        return CGSize(width: size.width, height: size.height)
////
////    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 0.0
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 0.0
//        
//    }
//    
//    
//}
//extension Home_ScreenVC : UICollectionViewDelegate , UICollectionViewDataSource
//{
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        if
////
////
////
////        let aCell = Collectionview_RecentTransaction.dequeueReusableCell(withReuseIdentifier: "Cell_Recent_TransactionView", for: indexPath) as! Cell_Recent_TransactionView
////       //
////       //
////                   return aCell
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//       
//        if collectionView == Collectionview_Billpayments
//        {
//            return 10
//        }
//        else if collectionView == COLLECTIONVIEWFavourite{
//            return 10
//        }
//        else
//        {
//            return 100
//        }
//
////        print("banner array",banArray.count)
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//         if collectionView == Collectionview_Billpayments
//        {
//            let cella = Collectionview_Billpayments .dequeueReusableCell(withReuseIdentifier: "Cell_Billpayment", for: indexPath) as! Cell_Billpayment
//             cella.btn_BillpaymentPayNow.setTitle("", for: .normal)
//            return cella
//        }
//        else
//        {
//            
//            let cellfav = COLLECTIONVIEWFavourite .dequeueReusableCell(withReuseIdentifier: "CellFavouriteCollectionView", for: indexPath) as! CellFavouriteCollectionView
//            return cellfav
//        
//        }
//    }
//
// 
//
//
//}
//
