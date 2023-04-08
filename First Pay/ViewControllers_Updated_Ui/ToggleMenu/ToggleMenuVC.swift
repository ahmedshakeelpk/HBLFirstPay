//
//  ToggleMenuVC.swift
//  First Pay
//
//  Created by Irum Butt on 25/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import SwiftyRSA
import MHWebViewController
import GolootloWebViewLibrary
import RNCryptor
import SwiftKeychainWrapper
import WebKit
import Alamofire
import AlamofireObjectMapper
var CheckLanguage = ""
var ThemeSelection = ""
var  dateString  : String?
class ToggleMenuVC:  BaseClassVC , UITableViewDelegate, UITableViewDataSource , WKNavigationDelegate, UINavigationControllerDelegate{
    var maskingCNic: String?
    var maskingAccountNo : String?
    var availableLimitObj: AvailableLimitsModel?
    var genResObj: GenericResponse?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
         getcnic()
        lblAccountTitle.text = DataManager.instance.accountTitle
        lblAccountNumber.text = DataManager.instance.accountNo
        lblEmail.text = ""
       
//        let date = Date()
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd"
//        dateString = df.string(from: date)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet var tableView: UITableView!
   
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        lblAccountTitle.text = DataManager.instance.accountTitle
        lblAccountNumber.text = DataManager.instance.accountNo
    }
    func masking()
        {
//            37x05xxx10xx4
//
            userCnic = UserDefaults.standard.string(forKey: "userCnic")
            var a = userCnic!
            maskingCNic = a.substring(to: 2)
            var concate = maskingCNic!
            var x = a.substring(with: 2..<3)
            x = x.replacingOccurrences(of: "\(x)", with: "X")
            concate = "\(concate)\(x)"
            var d = a.substring(with: 3..<5)
            concate = "\(concate)\(x)\(d)"
            var x1 = a.substring(with: 5..<8)
            x1 = x1.replacingOccurrences(of: "\(x1)", with: "XXX")
            concate = "\(maskingCNic!)\(x)\(d)\(x1)"
            var x2 = a.substring(with: 8..<10)
            concate = "\(maskingCNic!)\(x)\(d)\(x1)\(x2)"
            var x3 = a.substring(with: 10..<12)
            x3 = x3.replacingOccurrences(of: "\(x3)", with: "XX")
            concate = "\(maskingCNic!)\(x)\(d)\(x1)\(x2)\(x3)"
            var x4 = a.substring(with: 12..<13)
            concate = "\(maskingCNic!)\(x)\(d)\(x1)\(x2)\(x3)\(x4)"
            print("concate",concate)
            maskingCNic = concate
            
//            034064x1xx0
           var b =  DataManager.instance.accountNo!
            maskingAccountNo = b.substring(to: 6)
            var concate1 = maskingAccountNo!
            var y = b.substring(with: 6..<7)
            y = y.replacingOccurrences(of: "\(y)", with: "X")
            concate1 = "\(maskingAccountNo!)\(y)"

            var y1 = b.substring(with: 7..<8)
            concate1 = "\(maskingAccountNo!)\(y)\(y1)"
            var y2 = b.substring(with: 8..<10)
            y2 = y2.replacingOccurrences(of: "\(y2)", with: "XX")
            concate1 = "\(maskingAccountNo!)\(y)\(y1)\(y2)"
            var y3 = b.substring(with: 10..<11)
            concate1 = "\(maskingAccountNo!)\(y)\(y1)\(y2)\(y3)"
            print("concate1",concate1)
            maskingAccountNo = concate1
            
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is ", sideItemsArr.count)
        print("countimg  is ", sideBarImgsArr.count)
        return sideItemsArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
        
        cell.lblLevel.isHidden = true
        cell.btnUpgrade.isHidden = true
        cell.delegate = self
        cell.lblLevel.tag = indexPath.row
        
        if indexPath.row == 1
        {
            
            cell.lblLevel.isHidden = false
            cell.btnUpgrade.isHidden = false
            
        }
        else{
            cell.lblLevel.isHidden = true
            cell.btnUpgrade.isHidden = true
        }
        if indexPath.row == 9
            
        {
            cell.buttonSidebar.setTitleColor(UIColor.red, for: .normal)
        }
        let tag  = indexPath.row
        let languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? "en"
        cell.buttonSidebar.setTitle((sideItemsArr[indexPath.row]), for: .normal)
        
        cell.sideBarImgView.image = UIImage(named: sideBarImgsArr[indexPath.row])
        cell.buttonSidebar.tag = indexPath.row
        cell.buttonSidebar.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
//        self.lblAccountNumber.text = "Account No : \((DataManager.instance.accountNo) ?? "")"

        return cell
    }
    @objc func buttontaped(_sender:UIButton)
    {
        
        let tag = _sender.tag
        
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! SideBarCell
        if cell.buttonSidebar.tag ==  9
        {
            popUpLogout()
        }
        if cell.buttonSidebar.tag == 1
        {
            //            levelapicall
            getAvailableLimits()
            
        }
    
        if cell.buttonSidebar.tag == 2
        {
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        }
        
        if cell.buttonSidebar.tag == 3
        {
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        }
        if cell.buttonSidebar.tag == 4
        {
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        }
        
        if cell.buttonSidebar.tag == 6
        {
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        }
        if cell.buttonSidebar.tag == 7
        {
            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        }
      if cell.buttonSidebar.tag == 8
        {
          let vc = UIStoryboard(name: "ContactUs", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactUSVC") as! ContactUSVC
          self.present(vc, animated: true)
        }
        if cell.buttonSidebar.tag == 5
        {
            let vc = UIStoryboard(name: "MaintenanceCertificate", bundle: Bundle.main).instantiateViewController(withIdentifier: "MaintenenceCertificate") as! MaintenenceCertificate
            vc.documentData = createPDF()

            self.present(vc, animated: true)
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
                          self.showDefaultAlert(title: "", message: message)
                      }
                  }
              }
              else {
                  if let message = self.availableLimitObj?.messages{
                      self.showDefaultAlert(title: "", message: message)
                  }
//                  print(response.result.value)
//                  print(response.response?.statusCode)
              }
          }
      }
    private func updateUI(){
        
        if self.availableLimitObj?.limitsData?.levelLimits?[0].levelCode == "L0"
        {
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
         
            else
            {
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
                
                
            }
            
            self.present(vc, animated: true)
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
  
    var sideMenuOpen = false
    let pickerAccountType = UIPickerView()
    
    let sideItemsArr   :[String] =  ["Login Methods","Account Limit Manager","Branch/ATM Locator","My Transactions","My Approvals", "Maintenance Certificate","FAQ's", "Terms & Conditions","Contact Us","Log Out"]
   //Group 427321287.transactions 1
       var sideBarImgsArr: [String] =   ["FingerPrint 1","user 2","BranchLocator","transactions 1","myApproval","Maintenance Certoficate","FAQ","Terms and","Group 427321287","Logout"]
   
       
    
    
    
    private var plainData =  "UserId=TFMB&Password=vrWgqRccDZWTbTxz&FirstName=Golootlo&LastName=User&Phone=00000000348"
    
    
    private var plainDataLive = "UserId=TFMB&Password=YpBTLdMMkfWQdFSM&FirstName=\(DataManager.instance.firstName ?? "")&LastName=\(DataManager.instance.lastName ?? "")&Phone=\(Int( DataManager.AccountNo) ?? 0)"
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

private func batteryLevelChanged()
{
    UserDefaults.standard.synchronize()
    DataManager.accountPic = ""
    UserDefaults.standard.setValue(nil, forKey: "proImage")
    KeychainWrapper.standard.set(true, forKey: "enableTouchID")
}

    
    
    func accesstablviewcell()
    {
//        let tag = _sender.tag
        let indexPath = IndexPath(row: 0, section:0)
        let aCell = tableView.cellForRow(at: indexPath) as!
        SideBarCell

        print("acess cell")

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        let drawer = self.parent as! KYDrawerController
        let navCtrl = drawer.mainViewController as! UINavigationController
        switch indexPath.row {
        case 0:
//            showAlert(title: "", message: "Coming Soon", completion: nil)
//            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//
//            navCtrl.pushViewController(homeVC, animated: true)
            break
        case 1:
//            showToast(title: "Coming Soon")
//            let enableTouchIDVC = self.storyboard?.instantiateViewController(withIdentifier: "EnableDisableTouchFaceIDVC") as! EnableDisableTouchFaceIDVC
//            navCtrl.pushViewController(enableTouchIDVC, animated: true)
            break
        case 2:
//            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailableLimitsVC") as! AvailableLimitsVC
//            navCtrl.pushViewController(vc, animated: true)
            break
        case 3:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
//            navCtrl.pushViewController(vc, animated: true)
            break
//        case 4:
//            let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//            navCtrl.pushViewController(vc, animated: true)
//            break
        case 4:
//            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//            webVC.forHTML = true
//            webVC.forFaqs = true
//            navCtrl.pushViewController(webVC, animated: true)
            break
          case 5:
//            let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
//            webVC.forHTML = true
//            webVC.forTerms = true
//            self.navigationController?.pushViewController(webVC, animated: true)
            break
        case 6:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LimitManagementMainVc") as! LimitManagementMainVc
//            navCtrl.pushViewController(vc, animated: true)
            break
        case 7:
           
            break
        case 8:
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MaintenanceCertificateVC") as! MaintenanceCertificateVC
//            vc.documentData = createPDF()
//            navCtrl.pushViewController(vc, animated: true)
//
            break

        case 9:
//
////            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialMediaVC") as! SocialMediaVC
////            navCtrl.pushViewController(myDict, animated: true)
//            break
//        case 11:
//
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailSideDrawerVC") as! EmailSideDrawerVC
//            navCtrl.pushViewController(vc, animated: true)
            
            break
        case 10:
//            self.popUpLogout()
            break
        case 11:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThemeSelectionVC") as! ThemeSelectionVC
//             navCtrl.pushViewController(vc, animated: true)
            break
        default:
//
            drawer.setDrawerState(.closed, animated: true)
        }
        drawer.setDrawerState(.closed, animated: true)
    }
    
    
    func createPDF() -> Data {
        masking()
        let html = getHTML()
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 612.2, height: 800.0) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
       
        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        return pdfData as Data
    }

    
    var userCnic : String?
    func getcnic()
    {
    userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
    }
    else{
        userCnic = ""
    }
}
    func getHTML() -> String {
        return """
        <html>
               <body>
               <h3>
               <p style="text-align: center;"><b>ACCOUNT MAINTENANCE </b></p>
                        <p style="text-align: center;"><b>
                  CERTIFICATE </b></p>
               </h3>
              <style>
                       p {
                        font-size: 28px;
                         }
                         </style>
               <p style="text-align: center;" style="font-size: 300px;">
               This is to certify that</p>
               <p style="text-align: center;">
               <b>\(DataManager.instance.accountTitle!)</b></p>
               <p style="text-align: center;">
               having CNIC # <b>\(maskingCNic!)</b></p>
               <p style="text-align: center;">
               is maintaining  account  A/C# </p>
            <p style="text-align: center;">
           <b>\(maskingAccountNo!)</b>
               </p>
               <p style="text-align: center;">
               This certificate is issued on request
               </p>
               <p style="text-align: center;">
               of the customer without taking any
               </p>
               <p style="text-align: center;">
               risk and responsibility
               on
               </p>
               <p style="text-align: center;">
               undersigned and part of the bank.
               </p>
             

               <p style="text-align: center;">
               HBL Microfinance Bank Ltd
               16th & 17th Floor
               </p>
               <p style="text-align: center;">
               HBL Tower,
               Blue Area, Islamabad<br>
               </p>
               <p style="text-align: center;">
               Toll Free 0800-42563 OR 0800-34778<br>
               </p>
               </body>
               
               </html>
        """
    }

    
   
}

extension ToggleMenuVC : SideMenuCellDelegate{
    func MenuTap(tag: Int) {
//        ["Fingerprint Login","My Account & Limits","Branch/ATM Locator","My Transactions","My Approvals","Change Password","Maintenance Certificate","FAQ's", "Terms & Conditions", "Log Out"]

         if sideItemsArr[tag] == "Fingerprint Login"
        {
            self.dismiss(animated: true)
        }
        else if(sideItemsArr[tag] == "My Account & Limit" ){
            
            Switcher.presentPrivacyPolicy(viewController: self)
        }
        else if (sideItemsArr[tag]  == "Branch/ATM Locator")
        {
            Switcher.presentAboutus(viewController: self)
        }
        else if(sideItemsArr[tag]  == "Contact Us")
        {
            Switcher.presentPrivacyPolicy(viewController: self)
        }
                
    }
}
                
                
                
                
                
                
                
                
        
    


