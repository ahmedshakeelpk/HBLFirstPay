//
//  New_User_ProfileVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import iOSDropDown
var City_flag = ""
var cnic_flag = ""
var cinc_issuedateFlag = ""

//protocol myprotocol: NSObjectProtocol
//{
//    func setValueback(city: String)
//
//
//}
class New_User_ProfileVC: BaseClassVC, UITextFieldDelegate, UISearchBarDelegate{
    var get_Seclected_City : String?
    var getCnic_value = ""
    var getCnic_issueDateValue = ""
    var Selected_Mother_name = ""
    var flagMother_nameselected  : Bool = true
    var cnicVerificationObj : cnicVerficationModel?
    let datePicker = UIDatePicker()
    var genericObj : GenericResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("fetch city", get_Seclected_City)
        TF_CnicNo.delegate = self
        TF_CityList.delegate = self
        TF_IssueDate.delegate = self
        View_mothername.isHidden = true
        lbl_InvalidCnic.isHidden = true
        blurView.backgroundColor = UIColor.gray
        dismissKeyboard()
        TF_CnicNo.mode = .cnic
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        blurView.alpha = 0.6
        blurView.isHidden = true
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
        popviewView.isUserInteractionEnabled = true
        popviewView.addGestureRecognizer(tapGestureRecognizerr)
       
        let tapGestureRecognizerrr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizerrr)
        btn_next.isUserInteractionEnabled = true
        TF_CnicNo.addDoneButtonOnKeyboardWithAction { [self] in
            print("end editing")
           
            if self.TF_CnicNo.text?.count ?? 0 < 13
                    {
                self.lbl_InvalidCnic.isHidden = false
                self.lbl_InvalidCnic.text = "Invalid Cnic"
                        
                    }

            else if self.TF_CnicNo.text == ""
                    {
                self.lbl_InvalidCnic.isHidden = true
                    }
                
                else
                {
                    self.lbl_InvalidCnic.isHidden = true
                    cnic_flag = "true"
                    self.getCnic_value = self.TF_CnicNo.text!
                }
 
            self.TF_CnicNo.resignFirstResponder()
        }
    }
   
//    -------------------------
//    Outlet
//    -------------------------
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

      TF_IssueDate.inputAccessoryView = toolbar
        TF_IssueDate.inputView = datePicker

     }
    
    @objc func donedatePicker(){

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      TF_IssueDate.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
   
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var popviewView: UIView!
    @IBOutlet weak var View_mothername: UIView!
    @IBOutlet weak var lbl_CreateNewWallet: UILabel!
    @IBOutlet weak var lbl_Cnic_issuedate: UILabel!
    @IBOutlet weak var lbl_CniccardNumber: UILabel!
    @IBOutlet weak var TF_CnicNo: NumberTextField!
    @IBOutlet weak var lbl_InvalidCnic: UILabel!
    @IBOutlet weak var TF_IssueDate: DisableEditingTextfield!
    @IBOutlet weak var TF_CityList: UITextField!
    @IBOutlet weak var btnMore_info: UIButton!
    @IBOutlet weak var lbl_ClickingContinue: UILabel!
    @IBOutlet weak var btnTermsCon: UIButton!
    @IBOutlet weak var btn_Mname1: UIButton!
    @IBOutlet weak var btn_Mname4: UIButton!
    @IBOutlet weak var btn_Mname3: UIButton!
    @IBOutlet weak var btn_Mname2: UIButton!
    @IBOutlet weak var lbl_SelectMName: UILabel!
    @IBOutlet weak var lbl_CnicVerify: UILabel!

    @IBOutlet weak var btnContinue: UIButton!
    
    
    
    //    -------------------------
    //    Actions
    //    -------------------------
    
    
    @IBOutlet weak var btn_next: UIButton!
    @IBAction func Action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Actions_info(_ sender: UIButton) {
        
    
        AnimIn(Popview: popviewView)
//        View_mothername.isHidden = false
    }
    
    @IBAction func Action_MothernameNext(_ sender: UIButton) {
        blurView.isHidden = true
        View_mothername.isHidden = true
           
        motherName()
        
        
        
        
        
    }
    
    @IBAction func Action_entercnic(_ sender: UITextField) {
    }
    
    @IBOutlet weak var btn_next_arrow: UIButton!
    
    
    @IBAction func btnnextArrow(_ sender: UIButton) {
        if TF_CnicNo.text?.count == 0{
            self.showToast(title: "Please Enter CNIC NO")
            return

        }
        if TF_IssueDate.text?.count == 0{
            self.showToast(title: "Please Enter Cnic Issue Date")
            return

        }
        if TF_CityList.text?.count == 0{
            self.showToast(title: "Please Select City")
            return

        }
//
        else{
            if flagMother_nameselected == true
            {
                cnicVerification()
            }
            else{
                self.View_mothername.isHidden = true
                self.blurView.isHidden = true
            }
            
        }
        
    }
    @IBAction func Action_Continue(_ sender: UIButton) {
     
        if TF_CnicNo.text?.count == 0{
            self.showToast(title: "Please Enter CNIC NO")
            return

        }
        if TF_IssueDate.text?.count == 0{
            self.showToast(title: "Please Enter Cnic Issue Date")
            return

        }
        if TF_CityList.text?.count == 0{
            self.showToast(title: "Please Select City")
            return

        }
//
        else{
            
                cnicVerification()
            
          
        }
    
    }
   
    @IBAction func Action_Mname1(_ sender: UIButton) {
        let image = UIImage(named: "Rectangle Orange")
        let emptyimage = UIImage(named: "Rectangle")
       
        btn_Mname1.setBackgroundImage(image, for: .normal)
        btn_Mname1.setTitleColor(.white, for: .normal)
        btn_Mname2.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname3.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname4.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname2.setTitleColor(.black, for: .normal)
        btn_Mname3.setTitleColor(.black, for: .normal)
        btn_Mname4.setTitleColor(.black, for: .normal)
        Selected_Mother_name = btn_Mname1.currentTitle ?? ""
        print("Selected_Mother_name", Selected_Mother_name)
        let backimage = UIImage(named: "]greenarrow")
        btn_next.setImage(backimage, for: .normal)
    }
    
    @IBAction func Action_Mname2(_ sender: UIButton) {
        let image = UIImage(named: "Rectangle Orange")
        let emptyimage = UIImage(named: "Rectangle")
        btn_Mname2.setBackgroundImage(image, for: .normal)
        btn_Mname2.setTitleColor(.white, for: .normal)
        btn_Mname1.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname3.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname4.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname1.setTitleColor(.black, for: .normal)
        btn_Mname3.setTitleColor(.black, for: .normal)
        btn_Mname4.setTitleColor(.black, for: .normal)
        Selected_Mother_name = btn_Mname2.currentTitle ?? ""
        let backimage = UIImage(named: "]greenarrow")
        btn_next.setImage(backimage, for: .normal)
    }
    
    @IBAction func Action_Mname3(_ sender: UIButton) {
        let image = UIImage(named: "Rectangle Orange")
        let emptyimage = UIImage(named: "Rectangle")
       
        btn_Mname3.setBackgroundImage(image, for: .normal)
        btn_Mname3.setTitleColor(.white, for: .normal)
        btn_Mname1.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname2.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname4.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname1.setTitleColor(.black, for: .normal)
        btn_Mname2.setTitleColor(.black, for: .normal)
        btn_Mname4.setTitleColor(.black, for: .normal)
        Selected_Mother_name =  btn_Mname3.currentTitle ?? ""
        let backimage = UIImage(named: "]greenarrow")
        btn_next.setImage(backimage, for: .normal)
    }
    
    @IBAction func Action_Mname4(_ sender: UIButton) {
      
        let image = UIImage(named: "Rectangle Orange")
        let emptyimage = UIImage(named: "Rectangle")
       
        btn_Mname4.setBackgroundImage(image, for: .normal)
        btn_Mname4.setTitleColor(.white, for: .normal)
        btn_Mname1.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname2.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname3.setBackgroundImage(emptyimage, for: .normal)
        btn_Mname1.setTitleColor(.black, for: .normal)
        btn_Mname2.setTitleColor(.black, for: .normal)
        btn_Mname3.setTitleColor(.black, for: .normal)
        Selected_Mother_name = btn_Mname4.currentTitle ?? ""
        let backimage = UIImage(named: "]greenarrow")
        btn_next.setImage(backimage, for: .normal)
    }
    
    @IBAction func Action_HideMother_view(_ sender: UIButton) {
        
   
//        View_mothername.isHidden = true
//        blurView.isHidden = true
    }
    
    @IBAction func Action_issuedate(_ sender: UITextField) {
//           showDatePicker()
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        datePickerObj.maximumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
//        dd-MM-yyy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: datePickerObj.date)

        cinc_issuedateFlag = "true"
        getCnic_issueDateValue = self.TF_IssueDate.text!
        print("cnic issue date", self.getCnic_issueDateValue)
//        Animout(Popview: popviewView)
//
//
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        TF_IssueDate.text = dateFormatter.string(from: sender.date)
        //   DataManager.instance.cnicIssueDate =  sender.date as NSDate
        DataManager.instance.cnicIssueDate =  TF_IssueDate.text
        cinc_issuedateFlag = "true"
        getCnic_issueDateValue = self.TF_IssueDate.text!
        print("cnic issue date", self.getCnic_issueDateValue)
        
    }
    
    
    @IBAction func Dropdown_CityList(_ sender: DropDown) {
       
        
    }
    
    @IBAction func Action_termsCon(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RegistrationProcess", bundle: nil)
       //        let vc = storyboard.instantiateViewController(withIdentifier: "WebView_VC")
       //        self.present(vc, animated: true)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "WebView_VC") as! WebView_VC
      vc.forHTML = true
        vc.forFaqs = false
        vc.forTerms = true
//        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //    -------------------------
    //    Functions
    //    -------------------------
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        
        if textField == TF_CnicNo{
            TF_CnicNo.isUserInteractionEnabled = true
            return newLength <= 13
        }
        
        else {
            TF_IssueDate.isUserInteractionEnabled = true
            return newLength <= 16
            
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == TF_CnicNo
        {
            lbl_InvalidCnic.isHidden = true
        }
//        if textField == TF_IssueDate
////        {
////            AnimIn(Popview: popviewView)
//
//
////        }
//        if textField == TF_CityList
//        {
////
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "City_selectionVC") as! City_selectionVC
//
////            self.present(vc, animated: true)
//            self.navigationController?.pushViewController(vc, animated: false)
//
//
//
//        }
        
        
        return true
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == TF_CnicNo
        {
            if TF_CnicNo.text?.count ?? 0 < 13
            {
                lbl_InvalidCnic.isHidden = false
                lbl_InvalidCnic.text = "Invalid Cnic"
                
            }

            else if TF_CnicNo.text == ""
            {
                lbl_InvalidCnic.isHidden = true
            }
        }
        else
        {
            lbl_InvalidCnic.isHidden = true
            cnic_flag = "true"
            getCnic_value = TF_CnicNo.text!
        }
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if (TF_CnicNo.text?.count == 0) && (TF_IssueDate?.text?.count == 0)
            
        {
            self.TF_CityList.text = ""
        }
        else{
            self.TF_CityList.text = GlobalData.user_City
            print("city value fetch")
            self.View_mothername.isHidden = true
            self.blurView.isHidden = true
            let image = UIImage(named: "]greenarrow")
            btn_next_arrow.setImage(image, for: .normal)
        }
       
    }
   
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if TF_CnicNo.text == ""
        {
            lbl_InvalidCnic.isHidden = true
        }
    }
    

    @objc func PopUpHide(tapGestureRecognizer: UITapGestureRecognizer)
    {
        Animout(Popview: popviewView)
        blurView.isHidden = true
    }
    
    
    @objc func City_view_show(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
//              Animout(Popview: City_View)
//
//                blurView.isHidden = true
    }
    
    @IBAction func Action_dropdwon(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "City_selectionVC") as! City_selectionVC

//            self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @IBAction func Action_tfcity(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "City_selectionVC") as! City_selectionVC
        
//                    self.present(vc, animated: true)
                self.navigationController?.pushViewController(vc, animated: false)
////
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if TF_CnicNo.text?.count == 0{
            self.showToast(title: "Please Enter CNIC NO")
            return
           
        }
        if TF_IssueDate.text?.count == 0{
            self.showToast(title: "Please Enter Cnic Issue Date")
            return
           
        }
        if TF_CityList.text?.count == 0{
            self.showToast(title: "Please Select City")
            return

        }
        
        else{
//            if flagMother_nameselected == true{
                cnicVerification()
//            }
//            else
//            {
//                self.View_mothername.isHidden = true
//                self.blurView.isHidden = true
//            }
            
            
        }
        
        
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "WebView_VC") as! WebView_VC
//      vc.forHTML = true
//       vc.forFaqs = true
//        vc.forTerms = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let storyboard = UIStoryboard(name: "Stroyboard2_sub", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WebView_VC")
//        self.present(vc, animated: true)
       
    }
    
    
    private func  cnicVerification() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        if (TF_CnicNo.text?.isEmpty)!{
            TF_CnicNo = nil
        }
        if (TF_IssueDate.text?.isEmpty)!{
            TF_IssueDate.text = ""
        }
        let a = TF_CnicNo.text!
        var cnicNumber = a.replacingOccurrences(of: "-", with: "")
        cnicNumber = cnicNumber.replacingOccurrences(of: "_", with: "")
        DataManager.instance.userCnic = cnicNumber
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/cnicVerification"
        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo": DataManager.instance.mobNo ,"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)", "cnic": cnicNumber , "issueDate": TF_IssueDate.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.AuthToken]
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<cnicVerficationModel>) in
  
            self.hideActivityIndicator()
            self.cnicVerificationObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cnicVerificationObj?.responsecode == 2 || self.cnicVerificationObj?.responsecode == 1 {
                    if cnicVerificationObj?.data != nil{
                       
                        self.View_mothername.isHidden = false
                        self.blurView.isHidden = false
                        flagMother_nameselected = false
                       btn_Mname1.setTitle(cnicVerificationObj?.data?.motherNamesList?[0], for: .normal)
                        btn_Mname2.setTitle(cnicVerificationObj?.data?.motherNamesList?[1], for: .normal)

                          btn_Mname3.setTitle(cnicVerificationObj?.data?.motherNamesList?[2], for: .normal)

                        btn_Mname4.setTitle(cnicVerificationObj?.data?.motherNamesList?[3], for: .normal)
                    }
                    else{
                        if let message = self.cnicVerificationObj?.messages{
                            self.showDefaultAlert(title: "", message: message)
                        }
                    }


                }
                else{
                    
                    if let message = self.cnicVerificationObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
                    
                   
        }
        }
    }
            
    
    
//    MARK: API
    private func  motherName() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        if (TF_CnicNo.text?.isEmpty)!{
            TF_CnicNo = nil
        }
        if (TF_IssueDate.text?.isEmpty)!{
            TF_IssueDate.text = ""
        }
        let a = TF_CnicNo.text!
        var cnicNumber = a.replacingOccurrences(of: "-", with: "")
        cnicNumber = cnicNumber.replacingOccurrences(of: "_", with: "")
        DataManager.instance.userCnic = cnicNumber
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/customerKyc"

        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo": DataManager.instance.mobNo ,"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)", "cnic":      DataManager.instance.userCnic , "issueDate": TF_IssueDate.text!, "motherName": Selected_Mother_name,"cityId": GlobalData.User_CityId! as Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.AuthToken]
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in
            self.hideActivityIndicator()
            self.genericObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                    if let message = self.genericObj?.messages {
                        
                    self.showAlert(title: message, message: "", completion: {
//                        if message == "Customer Registered successfully"
//                        if self.genericObj?.data != nil{
                        
                        UserDefaults.standard.set(DataManager.instance.userCnic!, forKey: "userCnic")
                        print("Save user cnic  is ",DataManager.instance.userCnic)
                        DataManager.instance.userCnic = DataManager.instance.userCnic!
                        print("get cnic",DataManager.instance.userCnic)
                        
                        
                        
                        
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Set_PasswordVC") as! Set_PasswordVC
                            UserDefaults.standard.set("true", forKey: "FirstTimeLogin")
                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
                        
                           
//                        }
                        
                  
               })
                    
                }
                }
                else{
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                   
                }
                }
            }
    
           
        print(genericObj?.data)
        print(genericObj?.responsecode)
            }
    
    
}
extension New_User_ProfileVC
{
    func AnimIn(Popview:UIView)
    {
        self.View_mothername.isHidden = true
        self.blurView.isHidden = true
        view.addSubview(Popview)
        blurView.isHidden = false
        Popview.center = self.view.center
        Popview.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        Popview.alpha=0
        //  blurView.alpha = 0
        UIView.animate(withDuration: 0.6)
        {
            //   self.blurView.alpha = 1
            Popview.alpha = 1
            Popview.transform = CGAffineTransform.identity
        }
    }
    
    func Animout(Popview:UIView)
    {
        self.View_mothername.isHidden = true
        self.blurView.isHidden = true
        blurView.isHidden = true
        Popview.alpha = 1
        //   blurView.alpha = 1
        UIView.animate(withDuration: 0.6)
        {
            //   self.blurView.alpha = 0
            Popview.alpha=0
            Popview.transform = CGAffineTransform.identity
        }
        
    }
    
}
//extension New_User_ProfileVC :myprotocol
//{
//
//
//    func setValueback(city: String) {
//        TF_CityList.text = city
//    }
//}
