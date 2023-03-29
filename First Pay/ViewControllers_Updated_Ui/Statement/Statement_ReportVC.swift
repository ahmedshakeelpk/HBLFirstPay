//
//  Statement_ReportVC.swift
//  First Pay
//
//  Created by Irum Butt on 06/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import MessageUI
class Statement_ReportVC: BaseClassVC,MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            self.showToast(title: "Message canceled")
            print("message canceled")
        case MessageComposeResult.failed.rawValue :
            self.showToast(title: "Message failed")
            print("message failed")
        case MessageComposeResult.sent.rawValue :
            self.showToast(title: "Message sent")
            print("message sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinue.isUserInteractionEnabled = false
        print("fetch transation refference Number",  GlobalData.transRefnum)
        messageTextVieew.delegate = self
        blurView.isHidden = true
        btnSuccessPopUp.isHidden = true
        btn1.setTitle("", for: .normal)
        btn2.setTitle("", for: .normal)
        btn3.setTitle("", for: .normal)
        btn4.setTitle("", for: .normal)
        btn_next_arrow.setTitle("", for: .normal)
        btnBack.setTitle("", for: .normal)
        btnSuccessPopUp.setTitle("", for: .normal)
        btn5.setTitle("", for: .normal)
        btn6.setTitle("", for: .normal)
        btn7.setTitle("", for: .normal)
        messageTextVieew.isUserInteractionEnabled = false
        getDisputes()
        // Do any additional setup after loading the view.
    }
    var genResObj : GenericResponseModel?
    var disputeTypesObj : GetDisputeTypesModel?
    @IBOutlet weak var btnSuccessPopUp: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn_next_arrow: UIButton!
    @IBOutlet weak var messageTextVieew: UITextView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    
    
    
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func updateui()
    {
        
        lbl1.text = disputeTypesObj?.disputeTypes?[0].disputeTypeDescr
        lbl2.text = disputeTypesObj?.disputeTypes?[1].disputeTypeDescr
        lbl3.text = disputeTypesObj?.disputeTypes?[2].disputeTypeDescr
        lbl4.text = disputeTypesObj?.disputeTypes?[3].disputeTypeDescr
        lbl5.text = disputeTypesObj?.disputeTypes?[4].disputeTypeDescr
        lbl6.text = disputeTypesObj?.disputeTypes?[5].disputeTypeDescr
        lbl7.text = disputeTypesObj?.disputeTypes?[6].disputeTypeDescr
        
        
        
        
        
        
    }
    var disputeCode : Int?
    var Comments : String?
    @IBAction func Actionbtn1(_ sender: UIButton) {
        let checked = UIImage(named: "Radio Button")
        btn1.setImage(checked, for: .normal)
        let unchecked = UIImage(named: "Radio Button-1")
        btn2.setImage(unchecked, for: .normal)
        btn3.setImage(unchecked, for: .normal)
        btn4.setImage(unchecked, for: .normal)
//        btn1.frame = CGRect(x: 200, y: 200, width: 60, height: 60)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn5.backgroundColor = UIColor.clear
        btn5.setImage(unchecked, for: .normal)
        btn6.backgroundColor = UIColor.clear
        btn6.setImage(unchecked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        btn7.setImage(unchecked, for: .normal)
        
        btn4.backgroundColor = UIColor.clear
        ShowNextbtn()
//       var a  = disputeTypesObj?.disputeTypes?[0].disputeTypeDescr
        disputeCode = disputeTypesObj?.disputeTypes?[0].disputeTypeId
        print("you select dispute id", disputeCode)
        Comments = disputeTypesObj?.disputeTypes?[0].disputeTypeDescr
    }
    
    @IBAction func ActionBtn2(_ sender: UIButton) {
        let checked = UIImage(named: "Radio Button")
        btn2.setImage(checked, for: .normal)
        let unchecked = UIImage(named: "Radio Button-1")
        btn1.setImage(unchecked, for: .normal)
        btn3.setImage(unchecked, for: .normal)
        btn4.setImage(unchecked, for: .normal)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn4.backgroundColor = UIColor.clear
        btn5.backgroundColor = UIColor.clear
        btn5.setImage(unchecked, for: .normal)
        btn6.backgroundColor = UIColor.clear
        btn6.setImage(unchecked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        btn7.setImage(unchecked, for: .normal)
//        messageTextVieew.text = lbl2.text
        ShowNextbtn()
        disputeCode = disputeTypesObj?.disputeTypes?[1].disputeTypeId
        print("you select dispute id", disputeCode)
        Comments = disputeTypesObj?.disputeTypes?[1].disputeTypeDescr
        
    }
    
    @IBAction func ActionBtn3(_ sender: UIButton) {
        let checked = UIImage(named: "Radio Button")
        btn3.setImage(checked, for: .normal)
        let unchecked = UIImage(named: "Radio Button-1")
        btn2.setImage(unchecked, for: .normal)
        btn1.setImage(unchecked, for: .normal)
        btn4.setImage(unchecked, for: .normal)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn4.backgroundColor = UIColor.clear
        btn5.backgroundColor = UIColor.clear
        btn5.setImage(unchecked, for: .normal)
        btn6.backgroundColor = UIColor.clear
        btn6.setImage(unchecked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        btn7.setImage(unchecked, for: .normal)
//        messageTextVieew.text = lbl3.text
        ShowNextbtn()
        disputeCode = disputeTypesObj?.disputeTypes?[2].disputeTypeId
        print("you select dispute id", disputeCode)
        Comments = disputeTypesObj?.disputeTypes?[2].disputeTypeDescr
        
    }
    
    @IBAction func ActionBtn4(_ sender: UIButton) {
        let checked = UIImage(named: "Radio Button")
        btn4.setImage(checked, for: .normal)
        let unchecked = UIImage(named: "Radio Button-1")
        btn1.setImage(unchecked, for: .normal)
        btn3.setImage(unchecked, for: .normal)
        btn2.setImage(unchecked, for: .normal)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn4.backgroundColor = UIColor.clear
        
        btn5.backgroundColor = UIColor.clear
        btn5.setImage(unchecked, for: .normal)
        btn6.backgroundColor = UIColor.clear
        btn6.setImage(unchecked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        btn7.setImage(unchecked, for: .normal)
        disputeCode = disputeTypesObj?.disputeTypes?[3].disputeTypeId
        Comments = disputeTypesObj?.disputeTypes?[3].disputeTypeDescr
        print("you select dispute id", disputeCode)
        ShowNextbtn()
            
    }
    
    
    @IBAction func Action_btn5(_ sender: UIButton) {
        let checked = UIImage(named: "Radio Button")
        btn5.setImage(checked, for: .normal)
        btn5.backgroundColor = UIColor.clear
        let unchecked = UIImage(named: "Radio Button-1")
        btn1.setImage(unchecked, for: .normal)
        btn2.setImage(unchecked, for: .normal)
        btn3.setImage(unchecked, for: .normal)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn6.backgroundColor = UIColor.clear
        btn6.setImage(unchecked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        btn7.setImage(unchecked, for: .normal)
        btn4.setImage(unchecked, for: .normal)
        btn4.backgroundColor = UIColor.clear
//        messageTextVieew.isUserInteractionEnabled = true
        disputeCode = disputeTypesObj?.disputeTypes?[4].disputeTypeId
        Comments = disputeTypesObj?.disputeTypes?[4].disputeTypeDescr
        ShowNextbtn()
        
    }
    
    
    
    @IBAction func Action_btn6(_ sender: UIButton) {
        
        
        let checked = UIImage(named: "Radio Button")
        btn6.setImage(checked, for: .normal)
        btn6.backgroundColor = UIColor.clear
        let unchecked = UIImage(named: "Radio Button-1")
        btn1.setImage(unchecked, for: .normal)
        btn2.setImage(unchecked, for: .normal)
        btn3.setImage(unchecked, for: .normal)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn4.backgroundColor = UIColor.clear
        btn4.setImage(unchecked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        btn7.setImage(unchecked, for: .normal)
        btn5.setImage(unchecked, for: .normal)
        btn5.backgroundColor = UIColor.clear
        
        disputeCode = disputeTypesObj?.disputeTypes?[5].disputeTypeId
        Comments = disputeTypesObj?.disputeTypes?[5].disputeTypeDescr
        ShowNextbtn()
    }
    
    
    
    @IBAction func Action_btn7(_ sender: UIButton) {
        let checked = UIImage(named: "Radio Button")
        btn7.setImage(checked, for: .normal)
        btn7.backgroundColor = UIColor.clear
        let unchecked = UIImage(named: "Radio Button-1")
        btn1.setImage(unchecked, for: .normal)
        btn2.setImage(unchecked, for: .normal)
        btn3.setImage(unchecked, for: .normal)
        btn1.backgroundColor = UIColor.clear
        btn2.backgroundColor = UIColor.clear
        btn3.backgroundColor = UIColor.clear
        btn4.backgroundColor = UIColor.clear
        btn4.setImage(unchecked, for: .normal)
        btn6.backgroundColor = UIColor.clear
        btn6.setImage(unchecked, for: .normal)
        btn5.setImage(unchecked, for: .normal)
        btn5.backgroundColor = UIColor.clear
        messageTextVieew.isUserInteractionEnabled = true
        disputeCode = disputeTypesObj?.disputeTypes?[6].disputeTypeId
        Comments = disputeTypesObj?.disputeTypes?[6].disputeTypeDescr
        if messageTextVieew.text?.count != 0
        {
            ShowNextbtn()

        }
        else
        {
            Hidenextbtn()
        }
    }
    
    
    
    
    func ShowNextbtn()
    {
        let image = UIImage(named: "]greenarrow")
        btn_next_arrow.setImage(image, for: .normal)
        btn_next_arrow.adjustsImageSizeForAccessibilityContentSizeCategory
        btnContinue.isUserInteractionEnabled = true
    }
    func Hidenextbtn()
    {
        let image = UIImage(named: "grayArrow")
        btn_next_arrow.setImage(image, for: .normal)
        btn_next_arrow.adjustsImageSizeForAccessibilityContentSizeCategory
        btnContinue.isUserInteractionEnabled = false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.rangeOfCharacter(from: .letters) != nil || string == " " {
            return true
        }
        else if !(string == "" && range.length > 0) {
        return false
        
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.rangeOfCharacter(from: .letters) != nil || text == " " {
                   return true
               }
               else if !(text == "" && range.length > 0) {
               return false
               }
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
  
        
               return true
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
     
        messageTextVieew.text = ""
            
       }
   
    
    @IBAction func Action_Submit(_ sender: UIButton) {
//
        
        disputeTransaction()
//        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
//        self.present(vc, animated: true)
       
        
        
        
        
    }
    
    @IBAction func Action_HidePopup(_ sender: UIButton) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Statement_Transaction_HistoryVC") as! Statement_Transaction_HistoryVC
        
        self.navigationController!.pushViewController(vc, animated: false)
        blurView.isHidden = true
        btnSuccessPopUp.isHidden = true
    }
    
    
    // MARK: - API CALL
    
    private func getDisputes() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getDisputeTypes"
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetDisputeTypesModel>) in
            
            
            self.hideActivityIndicator()
            
            self.disputeTypesObj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                if self.disputeTypesObj?.responsecode == 2 || self.disputeTypesObj?.responsecode == 1 {
                    
                    self.updateui()
                    
//                    if let disputes = self.disputeTypesObj?.disputeTypes {
//                        self.disputesList = disputes
//                    }
//                    self.arrDisputesList = self.disputeTypesObj?.stringDisputesList
//                    self.methodDropDownDisputes(Disputes: (self.arrDisputesList)!)
                    
                }
                else {
                    if let message = self.disputeTypesObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                
                if let message = self.disputeTypesObj?.messages{
                self.showDefaultAlert(title: "", message: message)
            }
                
            }
        }
    }
    
    private func disputeTransaction() {

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
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/disputeTransaction"
        
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"comments":Comments!,"transRefNum":GlobalData.transRefnum,"disputeType":("\(self.disputeCode!)")] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in


            self.hideActivityIndicator()

            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    
                    self.blurView.isHidden = false
                    self.btnSuccessPopUp.isHidden = false
                    
                    
//                    self.showAlert(title: "Success", message: self.genResObj!.messages!, completion: {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
                }
                else {
                    if let message = self.genResObj?.messages{
                        UtilManager.showAlertMessage(message: message, viewController: self)
//                        self.showDefaultAlert(title: "", message: "\(message)")
//                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            else {
                if let message = self.genResObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }



//

}
