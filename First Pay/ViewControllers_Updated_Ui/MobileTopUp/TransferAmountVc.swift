//
//  TransferAmountVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class TransferAmountVc: BaseClassVC , UITextFieldDelegate{
    var arrAmount = ["Rs.100","Rs.250","Rs.500","Rs.1000"]
    var IsSelectedAmount = true
    var selectedAmount:String?
    var myarr = [amount]()
    var fundsTransSuccessObj: TopUpApiResponse?
    var phoneNumber  : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        btnContinue.isUserInteractionEnabled = false
        amountTextField.delegate = self
        backbtn.setTitle("", for: .normal)
        btn.setTitle("", for: .normal)
        btn.isUserInteractionEnabled = false
        img_next_arrow.isUserInteractionEnabled = false
        appendArray()
        updateui()

        // Do any additional setup after loading the view.
    }
    var minValue = 100
    var maxValue = 10000
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var imgoperator: UIImageView!
    @IBOutlet weak var lblAmountLimit: UILabel!
   
    @IBOutlet weak var img_next_arrow: UIImageView!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func Action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_Continue(_ sender: UIButton) {
        initiateTopUp()
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next_arrow.isUserInteractionEnabled = true
        img_next_arrow.addGestureRecognizer(tapGestureRecognizerr)
        
        
    }
    @IBOutlet weak var btn: UIButton!
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
                initiateTopUp()
    
        
//        self.present(vc, animated: true)
    }
      
    func appendArray(){
        for i in  arrAmount{

            myarr.append(amount(valueamount: i, isSeleccted: false))
        }
    }
    
    func updateui()
    {
//        imgoperator.image = GlobalData.selected_operator_logo
        lblMobileNumber.text =  phoneNumber
        
    }

    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        self.amountTextField.textColor = .gray
                let cell = collectionView.cellForItem(at: IndexPath(row: tag, section: 0)) as! cellAmount
                for i in  myarr{
                    i.isSeleccted = false
                }
        
                self.myarr[tag].isSeleccted = true
             cell.btnAmount.setTitleColor(.white, for: .normal)
        ///set title color here to white
           let setimg = UIImage(named: "")
        cell.backView.backgroundColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
//        cell.btnAmount.borderColor = .clear
        let a = cell.btnAmount.currentTitle
        let x = a?.substring(from: 3)
          amountTextField.text = x
       
            cell.btnAmount.setImage(setimg, for: .normal)
            btnContinue.isUserInteractionEnabled = true
            btn.isUserInteractionEnabled = true
            let image = UIImage(named:"]greenarrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = true
            lblAmountLimit.textColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
            self.collectionView.reloadData()
    
        
        
}
    func textFieldDidEndEditing(_ textField: UITextField) {
        if amountTextField?.text ?? "" < "\(minValue)" ||  amountTextField?.text  ?? "" > "\(maxValue)"
        {
            let image = UIImage(named:"grayArrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = false
            btnContinue.isUserInteractionEnabled = false
            btn.isUserInteractionEnabled = false
            lblAmountLimit.textColor = UIColor(hexValue: 0xFF3932)
            amountTextField.textColor = UIColor(hexValue: 0xFF3932)

        }
        else{
            let image = UIImage(named:"]greenarrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = true
            lblAmountLimit.textColor =  UIColor(red: 241/255, green: 147/255, blue: 0/255, alpha: 1)
            amountTextField.textColor = .gray
            self.collectionView.reloadData()
            
    
        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == amountTextField{
            return newLength <= 5
//            lbl1.textColor = UIColor.green
        }
        if textField == amountTextField{
            return newLength <= 5
        }
        return newLength <= 5
        
    
}
    
    private func initiateTopUp() {
        
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
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "topUp"
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/topUp"
        
       
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany":   GlobalData.Select_operator_code,"utilityConsumerNo":self.phoneNumber!, "accountType": DataManager.instance.accountType!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
                NetworkManager.sharedInstance.enableCertificatePinning()
        let error: Error!
        let sessionManger = APIs.shared.sessionManger(timeOut: 410)
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<TopUpApiResponse>().map(JSONObject: response.result)
            self.fundsTransSuccessObj = forecasts
            self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<TopUpApiResponse>) in
//            self.hideActivityIndicator()
            
//            self.fundsTransSuccessObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                    self.navigatezToConfirmationVC()
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.messages ?? "") ")
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    func navigatezToConfirmationVC()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountConfirmationVc") as! TransferAmountConfirmationVc
        vc.amount =  (amountTextField.text!)
        vc.phoneNumber = phoneNumber
        
        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    
    
    
    
    
    
}
extension TransferAmountVc: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "cellAmount", for: indexPath) as! cellAmount
         
        if(myarr[indexPath.row].isSeleccted == true)
        {
            cell.btnAmount.setTitleColor(.white, for: .normal)
            ///
         
            cell.backView.backgroundColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
//            cell.btnAmount.borderColor = .clear
            let setimg = UIImage(named: "")
            cell.btnAmount.setImage(setimg, for: .normal)

            
        }
        else
        {
            cell.btnAmount.setTitleColor(.black, for: .normal)
            cell.btnAmount.backgroundColor = .clear
            cell.backView.backgroundColor = .clear
            let setimg = UIImage(named: "")
            cell.btnAmount.setImage(setimg, for: .normal)
        
            
        }
        
        
        cell.btnAmount.tag = indexPath.row
        cell.btnAmount.setTitle(myarr[indexPath.row].valueamount, for: .normal)
        cell.btnAmount.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
  
        return cell

    }

   
    
}
class amount
{
    var valueamount : String
    var isSeleccted : Bool
    init(valueamount : String , isSeleccted : Bool ){
        self.valueamount = valueamount
        self.isSeleccted = isSeleccted
    }
    
}
