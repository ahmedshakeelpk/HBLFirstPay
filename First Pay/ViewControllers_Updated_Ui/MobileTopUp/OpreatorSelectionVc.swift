//
//  OpreatorSelectionVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper

class OpreatorSelectionVc: BaseClassVC, UITextFieldDelegate {
    var parentCompanyID : Int?
    var billCompanyListObj : UtilityBillCompaniesModel?
    var comapniesList = [SingleCompanyList]()
    var seclectedOperator = ""
    var getOperator = [myOperator]()
    var operatorid : Int?
    var operatorcode : String?
    var dummyarr : [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("get parentCompanyID", parentCompanyID!)
      
        tableView.rowHeight = 90
        getCompanies()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func Action_hideoperatorView(_ sender: UIButton) {
    }
   
    
    
    
    private func getCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getCompaniesById/\(self.parentCompanyID ?? 0)"
       
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<UtilityBillCompaniesModel>().map(JSONObject: response.result)
            self.billCompanyListObj = forecasts
            self.hideActivityIndicator()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<UtilityBillCompaniesModel>) in
//
//
//            self.hideActivityIndicator()
//
//            self.billCompanyListObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.billCompanyListObj?.responsecode == 2 || self.billCompanyListObj?.responsecode == 1 {
                    if let companies = self.billCompanyListObj?.companies {
                        self.comapniesList = companies
                        self.dummyarr = self.billCompanyListObj?.stringCompaniesList
                    }
                    
                    for i in self.billCompanyListObj?.companies! ?? []
                    {
                        let temp = myOperator()
                        temp.code = i.code!
                        temp.id = i.ubpCompaniesId!
                        temp.name = i.name!
                        self.getOperator.append(temp)
                    }
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
                else {
                    if let message = self.billCompanyListObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    func img(tag : Int) -> UIImage{
        guard let img = UIImage(named: dummyarr![tag])else {
            return UIImage(named: "11")!
            
        }
        return img
        
    }



}
extension OpreatorSelectionVc: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  dummyarr?.count ?? 0
   
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellOperator") as! cellOperator
       
        let aRequest = dummyarr?[indexPath.row]
//        aCell.backview.dropShadow1()
        aCell.lblOperator.text  = aRequest
//        aCell.imageView?.image = img(tag: indexPath.row)
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
        seclectedOperator = (dummyarr?[indexPath.row])!
        for i in getOperator
        {
            if i.name == seclectedOperator
            {
                operatorid = i.id
                operatorcode = i.code
            }

        }
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellOperator") as! cellOperator
//        aCell.lblcityname.textColor = UIColor(hexValue: 0x00CC96)
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
        GlobalData.Selected_operator = seclectedOperator
        GlobalData.Select_operator_id = operatorid
        GlobalData.Select_operator_code = operatorcode!
        GlobalData.selected_operator_logo = img(tag: indexPath.row)
    
        
        self.navigationController?.popViewController(animated: false)
    }
}
class myOperator
{
    var code = ""
    var id = 0
    var name = ""
}
