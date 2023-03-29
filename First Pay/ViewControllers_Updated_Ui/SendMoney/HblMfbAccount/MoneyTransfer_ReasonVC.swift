//
//  MoneyTransfer_ReasonVC.swift
//  First Pay
//
//  Created by Irum Butt on 12/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
var isFromReason : Bool = false
class MoneyTransfer_ReasonVC: BaseClassVC {
    var arrReasonsList : [String]?
    var reasonsObj : GetReasonsModel?
    var reasonID: Int?
    var resonCode : String?
    var reasonsList : [String]?
//    var reasonsList = ["Inquiry","Complaint","Suggestion","Feedback"]
    var getrznid = [myreason]()
    var Seclected_Rzn :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        getReasonsForTrans()
        tableView.rowHeight = 70
        getReasonsForTrans()

    }

    @IBOutlet weak var tableView: UITableView!
    // MARK: - APi Call
    
    
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getFtTransPurpose"
        let header: HTTPHeaders = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<GetReasonsModel>().map(JSONObject: response.result)
            self.reasonsObj = forecasts
                   self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReasonsModel>) in
//            self.hideActivityIndicator()
            if response.response?.statusCode == 200 {
//                self.reasonsObj = response.result.value
                if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                    for i in self.reasonsObj?.reasonsData! ?? []
                    {
                        var temp = myreason()
                        temp.code = (i.code!)
                        temp.name = (i.descr ?? "")
                        temp.id = (i.transactionPurposeId!)
                        self.getrznid.append(temp)
                    }
                    self.reasonsList = self.reasonsObj!.stringReasons
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
       
                    
                }
                
            }
            else {
                
//                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
}

extension MoneyTransfer_ReasonVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reasonsList?.count ?? 0

        
        
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellMoneyTransfer_ReasonVC") as! cellMoneyTransfer_ReasonVC
//        let aRequest = reasonsList?[indexPath.row]

        aCell.lblname.text = reasonsList?[indexPath.row]
//m        aCell.lblcityname.text =
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
        Seclected_Rzn = reasonsList?[indexPath.row]
        for i in getrznid
        {
            if i.name == Seclected_Rzn
            {
                reasonID = i.id
                resonCode = i.code

            }

        }
        
        
//        City_View.isHidden = false
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellMoneyTransfer_ReasonVC") as! cellMoneyTransfer_ReasonVC
        aCell.lblname.textColor = .green
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
        
         GlobalData.money_Reason = Seclected_Rzn!
//        GlobalData.money_Reason = (reasonsList?[0])!
        GlobalData.moneyReasonid = reasonID!
        GlobalData.moneyTransferReasocCode = resonCode!
        print("city id get",  GlobalData.money_Reason)
        isFromReason = true
        self.navigationController?.popViewController(animated: false)
    
    }
}
    class myreason
    {
        var name = ""
        var code = ""
        var id  = 0
    }
