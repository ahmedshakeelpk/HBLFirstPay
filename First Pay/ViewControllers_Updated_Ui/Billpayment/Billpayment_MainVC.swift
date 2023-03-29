//
//  Billpayment_MainVC.swift
//  First Pay
//
//  Created by Irum Butt on 30/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class Billpayment_MainVC: BaseClassVC {
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    var BillcompanyID : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 80
        back.setTitle("", for: .normal)
        getBillPaymentCompanies()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var lblmainTitle: UILabel!
    
    let ItemsArr   :[String] =  ["internet Bill Payment","Land Line","Electricity Bill Payment","Gass Bill Payment","Water / Sanitaion Bill","Investment", "Insurance", "Goverment","1 Bill"]
    
    
    var ImgsArr: [String] =   ["internetbillpayment","landline","electricitybillpayment","gassbillpayment","watersanitaionbill", "investment","insurance","goverment","1bill"]
    
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
//
      let cell = tableview.cellForRow(at: IndexPath(row: tag, section: 0)) as! cell_BillPyement_MainVC
      
        self.BillcompanyID =  self.billCompanyObj?.companies?[tag].ubpCompaniesId
        GlobalData.SelectedCompanyname = self.billCompanyObj?.companies?[tag].name
        GlobalData.SelectedCompanydecr = self.billCompanyObj?.companies?[tag].descr
        print("u selected company id", self.BillcompanyID)
         let vc = self.storyboard!.instantiateViewController(withIdentifier: "Billpayment_ListAllItemsVC") as! Billpayment_ListAllItemsVC
        vc.BillComapnyid = BillcompanyID!
//        vc.utilityBillCompany =  self.billCompanyObj?.companies?[tag].desc
        
//        print("utility id is", self.utilityBillCompany)
        
        
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getParentCompanies"
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompanies>) in
            
            self.hideActivityIndicator()
            
            self.billCompanyObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.billCompanyObj?.responsecode == 2 || self.billCompanyObj?.responsecode == 1 {
                    
                    for aCompany in (self.billCompanyObj?.companies)!{
                        if aCompany.code != "MBP" && aCompany.code != "MTUP"{
                            self.filteredCompanies.append(aCompany)
                        }
                    }
                    self.tableview.reloadData()
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
}

    

extension Billpayment_MainVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCompany = self.filteredCompanies[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell_BillPyement_MainVC", for: indexPath) as! cell_BillPyement_MainVC
        
        if ImgsArr.count > indexPath.row{

            if aCompany.code == "1Bill"{
                cell.img.image = UIImage(named: "1bill")
            }
            if aCompany.code == "BBP"{
                cell.img.image = UIImage(named: "1bill")

            }
            if aCompany.code == "CAREEM"{
                cell.img.image = UIImage(named: "1bill")

            }
            if aCompany.code == "EP"{
                cell.img.image = UIImage(named: "electricitybillpayment")

            }
            if aCompany.code == "EBP"{
                cell.img.image = UIImage(named: "gassbillpayment")

            }
            if aCompany.code == "GBP"{
                cell.img.image = UIImage(named: "1bill")

            }
            if aCompany.code == "GOV"{
                cell.img.image = UIImage(named: "goverment")

            }
            if aCompany.code == "IP"{
                cell.img.image = UIImage(named: "insurance")

            }
            if aCompany.code == "IBP"{
                cell.img.image = UIImage(named: "investment")

            }
            if aCompany.code == "LBP"{
                cell.img.image = UIImage(named: "landline")

            }
            if aCompany.name == "Online Shopping"{
                cell.img.image = UIImage(named: "1bill")

            }
            if aCompany.code == "WBP"{
                cell.img.image = UIImage(named: "watersanitaionbill")

            }
        }
        else{
            cell.img.image = UIImage(named: "1bill")

        }
        cell.btn_Next.tag = indexPath.row
        cell.btn.setTitle(aCompany.name, for: .normal)
        cell.btn_Next.setTitle("", for: .normal)
        cell.btn_Next.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)

       
        
        
        
        
        
        
        
        
        
        
        
        
//        cell.btn_Next.setTitle("", for: .normal)
//        cell.img.image = UIImage(named: ImgsArr[indexPath.row])
//        cell.btn.setTitle(ItemsArr[indexPath.row], for: .normal)
//
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showToast(title: "done work")
    }
}
