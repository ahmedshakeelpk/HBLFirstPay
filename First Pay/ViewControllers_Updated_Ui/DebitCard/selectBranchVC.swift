//
//  selectBranchVC.swift
//  First Pay
//
//  Created by Irum Butt on 14/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import AlamofireObjectMapper
class selectBranchVC: BaseClassVC, UISearchBarDelegate {
    var getBranchesObj : GetAllBranchesModel?
    var arrBranchList : [String]?
    var filteredData: [String]!
    var Seclected_Branch :String?
    var getBranch = [myBranch]()
    var branchID: Int?
    var branchCode : String?
    var fullname: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getBranches()
        searchBar.delegate = self
        tableView.rowHeight = 80
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    func getBranches() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getBranches"
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetAllBranchesModel>) in
            
            self.hideActivityIndicator()
            
            self.getBranchesObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.getBranchesObj?.responsecode == 2 || self.getBranchesObj?.responsecode == 1 {
                    
                    
                    for i in self.getBranchesObj?.data! ?? []
                    {
                       var temp = myBranch()
                        temp.id = i.branchId!
                        temp.code = i.branchCode!
                        temp.name = i.branchDescr!
                        self.getBranch.append(temp)
                    }
                    
                    self.arrBranchList = self.getBranchesObj?.stringBranch
                    self.filteredData = self.arrBranchList
                    
                    print("get branch data", self.filteredData)
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
}
class myBranch
{
    var name = ""
    var id = 0
    var code = ""
}
extension selectBranchVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return filteredData.count ?? 0

        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellselectBranchVC") as! cellselectBranchVC
        let aRequest = filteredData?[indexPath.row]
        aCell.labelBranchName.text = aRequest
        aCell.labelBranchName.textColor = UIColor(hexValue: 0x00CC96)
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        Seclected_Branch = filteredData?[indexPath.row]
        for i in getBranch
        {
            if i.name == Seclected_Branch
            {
                branchID = i.id
                branchCode = i.code
                
            }
                
        }
    
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellselectBranchVC") as! cellselectBranchVC
        aCell.labelBranchName.textColor = UIColor(hexValue: 0x00CC96)
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
         GlobalData.selectedBranch = Seclected_Branch!
        GlobalData.selectedBranchId = branchID
        GlobalData.selectedBranchCode = branchCode
        GlobalData.debitCardUserName = fullname!
        print("city id get",  GlobalData.selectedBranch)
        
        FBEvents.logEvent(title: .Debit_orderconfirm_screen)

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardBranchAddressConfirmationVC") as!  DebitCardBranchAddressConfirmationVC
//        vc.fullUserName = fullName!
        
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
                       self.filteredData = self.arrBranchList
                    print(self.filteredData)
                   }
                }
               
            
            }else{
                 print(searchText)
              
                self.filteredData = self.arrBranchList?.filter({ SearchCity -> Bool in
                    return SearchCity.lowercased().contains(searchText.lowercased())
                })
//                print(self.searchdoctor)
                if(filteredData.count == 0){
                    if(searchBar.text == ""){
                        filteredData = arrBranchList
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
                
            filteredData = arrBranchList
                
            searchBar.endEditing(true)
                
                tableView.reloadData()
                
           
        }

    
}
