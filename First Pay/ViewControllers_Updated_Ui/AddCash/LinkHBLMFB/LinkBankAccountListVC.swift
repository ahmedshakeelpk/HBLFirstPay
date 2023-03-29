//
//  LinkBankAccountListVC.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class LinkBankAccountListVC: BaseClassVC {
//    var  accountTitle :String?
//    var  accountNumber :String?
//    var  bankName :String?
   
    var cbsAccountsObj : GetCBSAccounts?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getLinkAccounts()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        buttonback.setTitle("", for: .normal)
        self.tableView.rowHeight = 120
        // Do any additional setup after loading the view.
    }
 
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getCbsAccounts"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
//
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GetCBSAccounts>) in
        let error: Error!
        
        let sessionManger = APIs.shared.sessionManger(timeOut: 410)
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            
            self.hideActivityIndicator()
            
//            self.cbsAccountsObj = response.result.value
            
            let forecasts = Mapper<GetCBSAccounts>().map(JSONObject: response.result)
//            self.genericresponseObj = response.result
            self.cbsAccountsObj = forecasts
            
            if response.response?.statusCode == 200 {
            
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
                        GlobalData.branchName = self.cbsAccountsObj?.accdata?[0].accountBranch
                        GlobalData.branchCode = self.cbsAccountsObj?.accdata?[0].accountBranchCode
                        
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.tableView.rowHeight = 120

                    }
                   
                }
                else {
                    self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {

        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkBankAccountDetailVc") as! LinkBankAccountDetailVc
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func buttoncellback(_ sender: UIButton) {
        
      let tag =  sender.tag
      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellLinkedAccount
      cell.backView.borderColor = .green
       let a = UIImage(named: "teenyicons_tick-circle-solid")
       cell.img.image = a
        cell.buttonImgChecked.isUserInteractionEnabled = true
//       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
//        cell.img.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    @IBAction func buttonImgChecked(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkBankAccountDetailVc") as! LinkBankAccountDetailVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension LinkBankAccountListVC :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.cbsAccountsObj?.accdata?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellLinkedAccount") as! cellLinkedAccount
        
        let aRequest =  self.cbsAccountsObj?.accdata?[indexPath.row]
        aCell.LabelName.text = aRequest?.accountTitle
        aCell.labelAccNo.text = aRequest?.accountNumber
        aCell.backView.borderColor = .gray
        aCell.labelBankName.text = aRequest?.accountBranch
        aCell.buttonback.setTitle("", for: .normal)
        aCell.buttonImgChecked.setTitle("", for: .normal)
        aCell.buttonImgChecked.isUserInteractionEnabled = false

        return aCell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    
//        let tag =  indexPath.row
//      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellLinkedAccount
//        cell.buttonChecked.isUserInteractionEnabled = true
//        cell.buttonChecked.setBackgroundImage(UIImage(named: "teenyicons_tick-circle-solid"), for: .normal)
//        cell.backView.borderColor = .green
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkBankAccountDetailVc") as! LinkBankAccountDetailVc
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
