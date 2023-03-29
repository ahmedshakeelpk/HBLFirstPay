//
//  FromLinkAccountListVc.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class FromLinkAccountListVc: BaseClassVC {
    var LinkedAccountsObj : getLinkedAccountModel?
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
    @IBOutlet weak var tableView: UITableView!
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLinkAccount"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getLinkedAccountModel>) in
            
            
            self.hideActivityIndicator()
            
            self.LinkedAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
            
                if self.LinkedAccountsObj?.responsecode == 2 || self.LinkedAccountsObj?.responsecode == 1 {
                    if self.LinkedAccountsObj?.data?.count ?? 0 > 0{
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.tableView.rowHeight = 120
   
                }
                }
                else {
                    self.showAlert(title: "", message: (self.LinkedAccountsObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    
    @IBAction func buttonDelink(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnlinkAccountVC") as! UnlinkAccountVC
//                        vc.accountTitle = cbsAccountsObj?.accdata[0].cbsAccountTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func buttonpress(_ sender:UIButton)
    {
        let tag = sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
        as! cellFromLinkedAccountListVc
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AddCashVC") as!   AddCashVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension FromLinkAccountListVc :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.LinkedAccountsObj?.data?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellFromLinkedAccountListVc") as! cellFromLinkedAccountListVc
        let aRequest =  self.LinkedAccountsObj?.data?[indexPath.row]
        aCell.labelName.text = aRequest?.cbsAccountTitle
        aCell.labelAccountNo.text = aRequest?.cbsAccountNo
        aCell.labelBankName.text = aRequest?.branchName
        aCell.buttonBackView.setTitle("", for: .normal)
        aCell.buttonBackView.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
        
        aCell.buttonDotedIcon.setTitle("", for: .normal)
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
//    AddCashVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    
      let tag =  indexPath.row
      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellFromLinkedAccountListVc
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "  AddCashVC") as!   AddCashVC
        self.navigationController?.pushViewController(vc, animated: true)
        

}
}
