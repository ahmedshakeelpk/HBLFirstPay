//
//  MobileTopUpVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
class MobileTopUpVC: BaseClassVC, UITextFieldDelegate {
    private let contactPicker = CNContactPickerViewController()
    var parentCompanyID : Int?
    var companyID : String?
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    var arrCompaniesList : [String]?
    var comapniesList = [SingleCompanyList]()
    var sourceCompany: String?
    var companyCode: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        getBillPaymentCompanies()
        imgPostpaid.isHidden = true
        Tf_mobileNumber.delegate = self
        btnContinue.isUserInteractionEnabled = false
        backbtn.setTitle("", for: .normal)
        btnContactList.setTitle("", for: .normal)
        btndropdown.setTitle("", for: .normal)
        img_next_arrow.isUserInteractionEnabled = false
        Tf_mobileNumber.delegate  = self
        selectOperator.delegate = self
        lblMainTitle.textColor = .black
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var btnPostpaid: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btnPrepaid: UIButton!
    @IBOutlet weak var imgPostpaid: UIImageView!
    @IBOutlet weak var imgPrepaid: UIImageView!
    @IBOutlet weak var Tf_mobileNumber: UITextField!
    @IBOutlet weak var btnContactList: UIButton!
    @IBOutlet weak var btndropdown: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var img_next_arrow: UIImageView!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var selectOperator: UITextField!
    @IBAction func Action_next(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
        vc.phoneNumber = Tf_mobileNumber.text!
        self.navigationController?.pushViewController(vc, animated: true)
        
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next_arrow.isUserInteractionEnabled = true
        img_next_arrow.addGestureRecognizer(tapGestureRecognizerr)
      
        

        
    }
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
        vc.phoneNumber = Tf_mobileNumber.text!
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true)
    }
   
    @IBAction func Action_Operator(_ sender: UIButton) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpreatorSelectionVc") as! OpreatorSelectionVc
        vc.parentCompanyID = parentCompanyID
        
        self.navigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Tf_mobileNumber.text?.count != 0
        {
            selectOperator.text = GlobalData.Selected_operator
            let image = UIImage(named:"]greenarrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = true
            btnContinue.isUserInteractionEnabled = true
            
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = false
        }
       
    }
    
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
       
//        let  myDict = [ "name": "DashBoardVC"]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)
    }
    
    @IBAction func ShowContactList(_ sender: UIButton) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    @IBAction func ActionPrepaid(_ sender: UIButton) {
        selectOperator.text = ""
        Tf_mobileNumber.text = ""
        imgPostpaid.isHidden = true
        imgPrepaid.isHidden = false
        companyID = billCompanyObj?.companies?[1].code
        parentCompanyID = billCompanyObj?.companies?[1].ubpCompaniesId
        print("u selected prepaid id", companyID)
        print("u selected prepaidcode ", parentCompanyID)
        if (self.billCompanyObj?.companies?[1].code)! != "MBP"
        {
            GlobalData.topup = "Prepaid"
        }
        
        print("Prepaid",  GlobalData.topup)
      
    }
    
    @IBAction func Action_postpaid(_ sender: UIButton) {
        selectOperator.text = ""
        Tf_mobileNumber.text = ""
        imgPostpaid.isHidden = false
        imgPrepaid.isHidden = true
        companyID = billCompanyObj?.companies?[0].code
        parentCompanyID = billCompanyObj?.companies?[0].ubpCompaniesId
        print("u selected postpaid id", companyID)
        print("u selected postpaid code ", parentCompanyID)
        if (self.billCompanyObj?.companies?[0].code)! == "MBP"
        {
            GlobalData.topup = "Postpaid"
            
        }
        print("Postpaid",  GlobalData.topup)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == Tf_mobileNumber
        {
            return newLength <= 11
        }
        return newLength <= 11
    }

    
    // MARK: - API CALL
    
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL +          "Transactions/v1/getParentTopUpCompanies"

        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<BillPaymentCompanies>().map(JSONObject: response.result)
            self.billCompanyObj = forecasts
            self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompanies>) in
//
//            self.hideActivityIndicator()
//            self.billCompanyObj = response.result.value
            if response.response?.statusCode == 200 {
        
                if self.billCompanyObj?.responsecode == 2 || self.billCompanyObj?.responsecode == 1 {
                 
                    GlobalData.topup = "Prepaid"
                   
                    self.companyID = self.billCompanyObj?.companies?[1].code
                    self.parentCompanyID = self.billCompanyObj?.companies?[1].ubpCompaniesId
                    print("u selected prepaid id", self.companyID)
                    print("u selected prepaidcode ", self.parentCompanyID)
                     
//                    for aCompany in (self.billCompanyObj?.companies)!{
//                        if aCompany.code == "MBP" || aCompany.code == "MTUP"{
//                            self.filteredCompanies.append(aCompany)
//                        }
                     
                }
                else {
                     self.showAlert(title: "", message: (self.billCompanyObj?.messages)!, completion: nil)
                }
            }
            else {
                self.showAlert(title: "", message: (self.billCompanyObj?.messages ?? ""), completion: nil)
//                print(response.result.value)
//                print(response.response?.statusCode)
                
                
            }
        }
    }
    
 
    
    
    
    

}
extension MobileTopUpVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.Tf_mobileNumber.text = name

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        

        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
            self.Tf_mobileNumber.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}
