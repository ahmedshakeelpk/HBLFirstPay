//
//  BaseClassVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import Toaster
import Alamofire
import ObjectMapper
import GolootloWebViewLibrary
import SwiftyRSA
import SafariServices
var rootVC:UIViewController?
class BaseClassVC: UIViewController {
    
   
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnInviteFriend: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    var rootVC:UIViewController?
    var miniStatementObj:MiniStatementModel?
    var  genRespBaseObj: GenericResponse?
    @NSManaged public var ignoreUnknownCharacters: NSSet?

     private var plainDataLive = "UserId=TFMB&Password=YpBTLdMMkfWQdFSM&FirstName=\(DataManager.instance.firstName ?? "")&LastName=\(DataManager.instance.lastName ?? "")&Phone=\(DataManager.instance.accountNo ?? "")"
    
    private var golootloController:GolootloWebController!
    func Changelanguage()
   {
       
       
       
//        btnHome.setTitle("HOME".localizeString(), for: .normal)
//        btnInviteFriend.setTitle("INVITE FRIENDS".localizeString(), for: .normal)
//        btnTickets.setTitle("TICKETS".localizeString(), for: .normal)
//        btnContact.setTitle("CONTACT US".localizeString(), for: .normal)
      
         
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguage()
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.rootVC = delegate.window?.rootViewController
        DataManager.instance.Longitude = 41.40338
        DataManager.instance.Latitude = 2.17403
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
       
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
       }
    
    @IBAction func menuPressed(_ sender: UIButton){
        
        if let drawerController = self.parent?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
       // self.logoutUser()
        self.popUpLogout()
    }
    
    @IBAction func otvCallPressed(_ sender: Any) {
        self.OTVCall()
        
    }
    
    func setDrawerState(state: DrawerState, animated: Bool){
        
    }
    
    
    // MARK: - Activity Indicator
    
    public func showActivityIndicator() {
        customActivityIndicatory(self.view, startAnimate: true)
//            ESActivityIndicator.startAnimatingIndicator(self.view)
      
    }
    
    public func hideActivityIndicator() {
        customActivityIndicatory(self.view, startAnimate: false)
//            ESActivityIndicator.stopAnimatingIndicator(<#T##ESActivityIndicator#>)
    }
    
//    // MARK: - BottomBar
//
//    public func showBottomBar(vc: UIViewController) {
//
//        let bottomBarView = BottomViewVC(nibName: "BottomViewVC", bundle: nil)
//        vc.view.addSubview(bottomBarView.view)
//        vc.view.frame = CGRect(x: 0, y: 100, width: vc.view.frame.size.width, height: vc.view.frame.size.height)
//        vc.addChildViewController(bottomBarView)
//    }
    
    
    // MARK: - Get IMEI
    func getIMEI(){

        let str = String(describing: UIDevice.current.identifierForVendor!)
        let replacedImei = str.replacingOccurrences(of: "-", with: "")
        DataManager.instance.imei = replacedImei
//        print(replacedImei)

        _ = KeyChainUtils.getUUID()!
//         print(udid)

    }
    
    
    // MARK: - replace Spaces
    func replaceSpaceWithEmptyString(aStr:String) -> String {
        let replacedString = aStr.replacingOccurrences(of: " ", with: "")

        return replacedString
    }
    
    // MARK: - Email Validition
    
    func isValidEmail(testStr:String) -> Bool {
        
//        print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }

    // MARK: - Tab Bar Actions
    
    @IBAction func bookMePressed(_ sender: Any) {
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction func careemPressed(_ sender: Any) {
        ///self.goToCareem()
//        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
//        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    @IBAction func golootloPressed(_ sender: Any) {
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        self.golootlo()
       
    }

    
    @IBAction func debitcardpressed(_ sender: UIButton) {
  
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DebitCardActDeActVC") as! DebitCardActDeActVC
//        self.navigationController!.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    @IBAction func contactUSPressed(_ sender: Any) {
//        let conUsVC = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//        self.navigationController!.pushViewController(conUsVC, animated: true)
    }
    
    // MARK: - Base64 Encoded String
    
    func base64EncodedString( params : [String : Any]) -> String {
      
        let base64EncodedString : String
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decodedString = String(data: jsonData, encoding: .utf8)!
        
        //          let encoder = JSONEncoder()
        //          let jsonData = (try? encoder.encode(params))!
        //          let jsonString = String(data: jsonData, encoding: .utf8)
        //            print(jsonString!)
        
        base64EncodedString = decodedString.toBase64()
        return base64EncodedString
    }
    
    // MARK: - Split String by Length
    
    func splitString(stringToSplit : String) -> (apiAttribute1:String,apiAttribute2:String) {
        
        let varLength : Int?
        var attr1 : String?
        var attr2 : String?
        
        varLength = stringToSplit.count/2
        
        let splitString = stringToSplit.split(by: varLength!)
        let arr = Array(splitString).map { String($0) }
//        print(arr)
        
        if arr.count == 0 {
            return ("","")
        }
        
        attr1 = arr[0]
        if arr.count%2 == 0{
            attr2 = arr[1]
        }
        else{
            attr2 = arr[1] + arr[2]
        }
        
        return (attr1!,attr2!)
        
        
    }
    
   
    
    
    //MARK: - Get IP Address
    
    func getWiFiAddress() -> [String] {
        
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
    
    
    // MARK: - Convert Currency
    
    public func convertToCurrrencyFormat(amount:String) -> String{
        
        let amountReal = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier:"en_PK")
        numberFormatter.generatesDecimalNumbers = true
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        let formattedNumber = numberFormatter.string(from: Float(amountReal)! as NSNumber)
        return ("\(formattedNumber!)")
    }
    
    
    // MARK: - Show Alert
    
    public func showAlert (title:String, message:String, completion:CompletionBlock?){
        
        let customAlertVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertVC") as! CustomAlertVC
        customAlertVC.titleStr = title
        customAlertVC.desStr = message
        
        if completion != nil {
            customAlertVC.completionBlock = completion
        }
      
        else {
            customAlertVC.completionBlock = {
                self.dismiss(animated: true, completion:nil)
            }
        }
        customAlertVC.modalPresentationStyle = .overCurrentContext;
        self.rootVC?.present(customAlertVC, animated: true, completion: nil)
        
    }
        public func showDefaultAlert(title:String , message:String){


        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        // show the alert
        self.rootVC?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Show Toast
    
    public func showToast(title:String){
        Toast(text:title, duration: Delay.long).show()
    }
    
    // MARK: - Log Out User
    
    public  func  popUpLogout(){
   
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//            firsttimenanoloan = "false"
//            firsttimeemailCheck = "false"

            self.logoutUser()
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
//                       self.navigationController?.pushViewController(vc, animated: true)
//            NotificationCenter.default.post(name: Notification.Name("batteryLevelChanged"), object: nil)
//            print("Handle Ok logic here")
        }))
            
        consentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
//        UserDefaults.standard.set()
        self.present(consentAlert, animated: true, completion: nil)
        
        
        
    }
    
        public func logoutUser() {
        UserDefaults.standard.synchronize()
//            firsttimeemailCheck = "false"
//            firsttimenanoloan = "false"
//        languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
        DataManager.instance.accessToken = nil
        DataManager.instance.accountTitle = nil
        DataManager.instance.imei = nil
        DataManager.instance.Latitude = nil
        DataManager.instance.Longitude = nil
        CheckLanguage = UserDefaults.standard.string(forKey: "language-Code") ?? "en"
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
//            self.navigationController?.pushViewController(vc, animated: true)
            reloadStoryBoard()
           
//        UserDefaults.standard.setValue(nil, forKey: "proImage")
    }
    
    // MARK: - Encode and Decode Image
    
    public func ConvertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = UIImageJPEGRepresentation(img, 0.50)! as NSData 
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    public func ConvertBase64StringToImage (imageBase64String:String) -> UIImage {
        
        let imageData = Data.init(base64Encoded: imageBase64String, options: .ignoreUnknownCharacters)
 
        if let imagePhoto = imageData{
            let image = UIImage(data: imagePhoto)
            if image != nil {
                return image!
            }
            return #imageLiteral(resourceName: "image_preview")
        }
        return #imageLiteral(resourceName: "image_preview")
        
    }
    
    
    public func reloadStoryBoard() {
        
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard(name: storyBoardName,bundle: nil)
       
        delegate.window?.rootViewController = storyBoard.instantiateInitialViewController()
//        languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? ""
        
        
    }
    
    
    // MARK: - Careem For Home
       
     func goToCareem() {

//        let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UbilityBillPaymentListVC") as! UbilityBillPaymentListVC
//        utilityInfoVC.parentCompanyID = 67
//        utilityInfoVC.isFromHome = true
//        utilityInfoVC.companiesTitle = "CAREEM"
//
//        self.navigationController!.pushViewController(utilityInfoVC, animated: true)
        
    }
    
    // MARK: - Get OTV Call
    
 private func OTVCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        
        let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":GlobalOTPTypes.OTP_BILL_PAYMENT,"channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
     let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
//
//        print(params)
//        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
     let sessionManger = APIs.shared.sessionManger(timeOut: 20)
     let error: Error!
     sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
         sessionManger.cancelAllRequests()
         let forecasts = Mapper<GenericResponse>().map(JSONObject: response.result)
         self.genRespBaseObj = forecasts
         self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
//            self.hideActivityIndicator()
//
//            self.genRespBaseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                    
                    self.showDefaultAlert(title: "", message: self.genRespBaseObj!.messages!)
                    
                }
                else {
                    if let message = self.genRespBaseObj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.genRespBaseObj?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    // MARK: - Get Mini Statement
    
    public func getMiniStatement(completionHandler: @escaping (_ result:MiniStatementModel) -> Void) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            UtilManager.showToast(message: "No Internet Available")
//            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
//        let compelteUrl = GlobalConstants.BASE_URL + "miniStatement"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/miniStatement"
        
                
        
        
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","acountId":"\(DataManager.instance.accountId!)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
//        print(params)
//        print(compelteUrl)
//        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<MiniStatementModel>().map(JSONObject: response.result)
            self.miniStatementObj = forecasts
            self.hideActivityIndicator()
        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
//
//            self.hideActivityIndicator()
//
//            self.miniStatementObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.miniStatementObj?.responsecode == 2 || self.miniStatementObj?.responsecode == 1 {
                    if self.miniStatementObj != nil {
                        completionHandler(self.miniStatementObj!)
                    }
                }
                else {
                    if let message = self.miniStatementObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.miniStatementObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
     // MARK: - Golootlo
    
        func golootlo(){
    
//           guard let url = getUrl() else{return}
//            let vc = SFSafariViewController(url: url)
//            present(vc, animated: true, completion: nil)
    
//            guard let url = getUrl() else{return}
//
//            let vc = GolootloWebController.init(webURL: url, delegate: self)
//
//            self.present(vc, animated: true, completion: nil)
            
            
            guard let url = getUrl() else{return}
            
            //let hash = url.valueOf("Hash")
            
            //print("url = \(url)")
            //print("hash = \(hash!)")
            
            golootloController = GolootloWebController.init(webURL: url, delegate: self)
            //Note: Please remember that the back button belongs to the the source ViewController and not to the destination ViewController. Thus, the modification needs to be done in the source VC, which is reflected to all the view in the navigation controller
            golootloController.navigationAttributedTitle = NSMutableAttributedString(string:"GOLOOTLO", attributes:[
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)])

            /*** If needed Assign Title Here ***/
            let backbutton = UIBarButtonItem.init(title: "Go Back", style: .done, target: self, action:#selector(goBack))
             let refreshButton = UIBarButtonItem.init(title: "Refresh", style: .done, target: self, action: #selector(refresh))
            
            
            golootloController.addNavigationBar(leftButtons: [backbutton], rightButtons: [refreshButton])
            self.navigationController?.navigationBar.barTintColor = .red
            self.navigationController?.navigationBar.tintColor = .white
            
            self.navigationController?.pushViewController(golootloController, animated: true)
    
    
        }
    
    @objc func goBack(){
           print("test")
           if(golootloController?.webView!.canGoBack ?? false) {
               //Go back in webview history
               golootloController?.webView?.goBack()
           } else {
               //Pop view controller to preview view controller
               self.navigationController?.popViewController(animated: true)
           }
           
           
       }
       
       @objc func refresh(){
           golootloController.refreshWebView()
           print("test")
       }
        
        func getUrl()->URL?{
    
            guard let  encodedData = getEncoded(data:plainDataLive) else{ return nil}
    
            //let webUrl = URL.init(string: "https://webview.staging.golootlo.pk/home?data=\(encodedData)")!
            let liveWebURL = URL.init(string: "https://webview.golootlo.pk/home?data=\(encodedData)")!
    
//            print(liveWebURL)
            return liveWebURL
        }
        
        func getEncoded(data:String)->String?{
    
            do{
    
                //   let publicKey = try PublicKey.init(pemNamed:"Golootlo-Staging-Public-Key" , in: Bundle.main)
                let publicKey = try PublicKey.init(pemNamed:"Golootlo-Public-Key-Prod" , in: Bundle.main)
                let clear = try ClearMessage(string: data, using: .utf8)
                let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
    
                // Then you can use:
                //    let data = encrypted.data
                let base64String = encrypted.base64String
    
    
    
                let allowedCharacterSet = CharacterSet.init(charactersIn: "!*'();:@&=+$,/?#[]").inverted
                let encodedData = base64String.addingPercentEncoding(withAllowedCharacters:allowedCharacterSet)!
    
                return encodedData
    
            }catch{
                print(error)
            }
    
            return nil
        }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
    
}

extension BaseClassVC: GolootloEventDelegate{
    func golootloViewDidLoad(animated: Bool) {
        
    }

    func golootloViewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func golootloViewDidAppear(_ animated: Bool) {
        
    }
    
    func golootloViewDidDisappear(_ animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func golootloViewWillDisappear(_ animated: Bool) {
        
      //  self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func golootloWillMoveFromParent() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func golootloViewDidLoadWith(animated: Bool) {
        
    }
    
    
    func golootlo(event: String) {
        print("delegate = \(event)")
    }
    
    
}

extension UIDevice {
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    var isJailBroken: Bool {
        get {
            if UIDevice.current.isSimulator { return false }
            if JailBrokenHelper.hasCydiaInstalled() { return true }
            if JailBrokenHelper.isContainsSuspiciousApps() { return true }
            if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
            return JailBrokenHelper.canEditSystemFiles()
        }
    }
}
    
private struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }
    
    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Add more paths here to check for jail break
     */
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
