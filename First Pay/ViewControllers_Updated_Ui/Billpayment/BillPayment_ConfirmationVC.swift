//
//  BillPayment_ConfirmationVC.swift
//  First Pay
//
//  Created by Irum Butt on 30/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class BillPayment_ConfirmationVC: BaseClassVC , UITextFieldDelegate {
    var successmodelobj : FundsTransferApiResponse?
//    var dueDate:String?
//    var totalAmountl:String?
//    var paidAmount:String?
//    var remainingAmount:String?
//    var amountAfterDD:String?
//    var remAmountAftrDD:String?
//    
//    var companyName:String?
//    var utilityBillCompany:String?
//    var utilityConsumerNo:String?
//    var utilityBillCompanyId : Int?
//    var sourceAccount:String?
//    var beneficaryAccount:String?
//    var accountTitle: String?
//    var comments: String?
//    var otpReq: String?
//    var utilityCompanyID : String?
   
    var refferenceNumber:String?
    var company : String?
    var billingMonth : String?
    var amountDue : String?
    var status:String?
    var totalAmount:String?
    var dueDate :String?
    var consumerNumber : String?
    var amountpaid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        TextfieldAmount.delegate = self
        otpTextField.delegate = self
        imageNextArrow.isUserInteractionEnabled = false
        buttonNext.isUserInteractionEnabled = false
         UpdateUi()
        back.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var TextfieldAmount: UITextField!
    
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
   
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var Lbl_BiilingMonth: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblRefferenceNo: UILabel!
    @IBOutlet weak var lb_consumer_name: UILabel!
    @IBOutlet weak var bank_logo: UIImageView!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var imageNextArrow: UIImageView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBAction func buttonNext(_ sender: UIButton) {
       
        billPyment()
        
    }
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func UpdateUi()
    {
       
        lb_consumer_name.text = DataManager.instance.accountTitle
        lblRefferenceNo.text = consumerNumber
        lblCompany.text = company
        Lbl_BiilingMonth.text = billingMonth
        lblAmount.text = amountDue
        lblDate.text = dueDate
        lbl_Status.text = status
        TextfieldAmount.text = totalAmount
    }
    private func billPyment() {
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/billPayment"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":GlobalData.Selected_Company_code!,"beneficiaryAccountTitle":"","utilityConsumerNo":consumerNumber!,"accountType" : DataManager.instance.accountType!,"amountPaid":self.TextfieldAmount.text!,"beneficiaryName":"","beneficiaryMobile":"","beneficiaryEmail":"","otp":otpTextField.text!,"addBeneficiary":"","utilityBillCompanyId":GlobalData.Selected_Company_id!] as [String : Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundsTransferApiResponse>) in
            self.hideActivityIndicator()
             self.successmodelobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                    self.move_to_next()
//                    self.tablleview?.reloadData()
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        UtilManager.showAlertMessage(message: message, viewController: self)
                        self.showDefaultAlert(title: "", message: message)
//                        self.navigateToSuccessVC()
                    }
                }
            }
            else {
                if let message = self.successmodelobj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }

    func move_to_next()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillPayment_SuccessfullVC") as! BillPayment_SuccessfullVC
        vc.refferenceNumber = refferenceNumber
        vc.totalAmount = TextfieldAmount.text!
        vc.company = company
        vc.billingMonth = billingMonth
        vc.amountDue = amountDue
        vc.dueDate = dueDate
        
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == otpTextField
        {
            otpTextField.isUserInteractionEnabled = true
            return newLength <= 4
           
    }
    
        return newLength <= 10
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if TextfieldAmount.text?.count != 0 && otpTextField.text?.count == 4
        {
            imageNextArrow.image = UIImage(named: "]greenarrow")
            imageNextArrow.isUserInteractionEnabled = true
            buttonNext.isUserInteractionEnabled = true
        }
        else
        {
//            let image = UIImage(named:"grayArrow")
            imageNextArrow.image = UIImage(named: "grayArrow")
            imageNextArrow.isUserInteractionEnabled = false
            buttonNext.isUserInteractionEnabled = false
        }
        
        
    }
}
