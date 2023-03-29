//
//  Billpayment_ListAllItemsVC.swift
//  First Pay
//
//  Created by Irum Butt on 30/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class Billpayment_ListAllItemsVC: BaseClassVC , UISearchBarDelegate{
    var BillComapnyid : Int?
    var utilityBillCompany : String?
    var billCompanyListObj : UtilityBillCompaniesModel?
    var comapniesList = [SingleCompanyList]()
    var getClassBillComapny = [BillCompany]()
    var Bill_id : Int?
    var Bill_code : String?
    var bill_arr : [String]?
    var Selected_Company = ""
    var Selected_Company_id : Int?
    var Selected_Company_code : String?
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("u get id", BillComapnyid)
       
        tableView.rowHeight = 70
        searchBar.delegate = self
        getCompanies()
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoStatement(tapGestureRecognizer:)))
        blurViewtap.isUserInteractionEnabled = true
        blurViewtap.addGestureRecognizer(tapGestureRecognizerr)
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var blurViewtap: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @objc func MovetoStatement(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: false)
    }
      
    private func getCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getCompaniesById/\(self.BillComapnyid ?? 0)"
       
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<UtilityBillCompaniesModel>) in
            
            
            self.hideActivityIndicator()
            
            self.billCompanyListObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.billCompanyListObj?.responsecode == 2 || self.billCompanyListObj?.responsecode == 1 {
                    if let companies = self.billCompanyListObj?.companies {
                        self.comapniesList = companies
                        self.bill_arr = self.billCompanyListObj?.stringCompaniesList
                    }

                    for i in self.billCompanyListObj?.companies! ?? []
                    {
                        let temp = BillCompany()
                        temp.code = i.code!
                        temp.id = i.ubpCompaniesId!
                        temp.name = i.name!
                        self.getClassBillComapny.append(temp)
                        
                    }
                    self.filteredData =  self.bill_arr
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
    
}
extension Billpayment_ListAllItemsVC: UITableViewDelegate, UITableViewDataSource
{
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData?.count ?? 0
   
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Billpayment_ListAllItemsVC") as! cell_Billpayment_ListAllItemsVC
        let aRequest = filteredData?[indexPath.row]
        cell.lblname.text = aRequest
       
        return cell
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
        Selected_Company = (filteredData?[indexPath.row])!
        for i in getClassBillComapny
        {
            if i.name == Selected_Company
            {
                Selected_Company_id = i.id
                Selected_Company_code = i.code
            }

        }
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cell_Billpayment_ListAllItemsVC") as! cell_Billpayment_ListAllItemsVC
//        aCell.lblcityname.textColor = UIColor(hexValue: 0x00CC96)
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
        
        GlobalData.Selected_bil_Company = Selected_Company
        GlobalData.Selected_Company_id = Selected_Company_id
        GlobalData.Selected_Company_code = Selected_Company_code!
//        GlobalData.selected_operator_logo = img(tag: indexPath.row)
        let vc = storyboard?.instantiateViewController(withIdentifier: "Pay_BillPayment_VC") as! Pay_BillPayment_VC
        vc.BillComapnyid = BillComapnyid!
        vc.utilityBillCompany =  GlobalData.Selected_Company_code
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
            
            
        {
            self.filteredData.removeAll()
            print("from searchbar")

            guard let searchText = searchBar.text else { return }
            if searchText == ""{
                print(searchText)
               print("searchlist")
                if(self.filteredData.count == 0){
                   print("searchlist")
                   if(searchBar.text == ""){
                       self.filteredData = self.bill_arr
                    print(self.filteredData)
                   }
                }
               
            
            }else{
                 print(searchText)
              
                self.filteredData = self.bill_arr?.filter({ SearchCity -> Bool in
                    return SearchCity.lowercased().contains(searchText.lowercased())
                })
//                print(self.searchdoctor)
                if(filteredData.count == 0){
                    if(searchBar.text == ""){
                        filteredData = bill_arr
                    }
                   // self.nosearchlb.isHidden = false
                }else{
                    //self.nosearchlb.isHidden = true
                }
                
            }

            tableView.reloadData()


        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
            
        {
            
            searchBar.text = ""
                
            filteredData = bill_arr
                
            searchBar.endEditing(true)
                
            tableView.reloadData()
                
           
        }
   
}
class BillCompany
{
    var code = ""
    var id = 0
    var name = ""
}
