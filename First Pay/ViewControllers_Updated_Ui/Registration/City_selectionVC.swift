//
//  City_selectionVC.swift
//  First Pay
//
//  Created by Irum Butt on 17/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import iOSDropDown

class City_selectionVC: BaseClassVC, UITextFieldDelegate, UISearchBarDelegate {
    var cityListObj : CitiesList?
     var cityID: Int?
//    var cityDescr: String?
//    var custAllID : Int?
    var arrCitiesList : [String]?
    var filteredData: [String]!
    var Seclected_City :String?
    var getcitid = [mycity]()
    
//    weak var mydelegate: myprotocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        getCities()
        SearchBar.delegate = self
        SearchBar.placeholder = "Search City Name"
        tableview.rowHeight = 70
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var City_View: UIView!
    @IBOutlet weak var lbl_SelectCity: UILabel!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    @IBAction func Action_hideCityview(_ sender: UIButton) {
        City_View.isHidden = true
       
    }
    //MARK: - API CALL
    
    private func getCities(){
        
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/getAllCities"
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.AuthToken]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let error: Error!
        let sessionManger = APIs.shared.sessionManger(timeOut: 410)
        sessionManger.request(compelteUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<CitiesList>().map(JSONObject: response.result)
            self.cityListObj = forecasts
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<CitiesList>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in
            
            self.hideActivityIndicator()
//
//            self.cityListObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cityListObj?.responsecode == 2 || self.cityListObj?.responsecode == 1 {
                    for i in self.cityListObj?.citiesList! ?? []
                    {
                        var temp = mycity()
                        temp.id = (i.cityID!)
                        temp.name = i.cityDescr!
                        self.getcitid.append(temp)
                    }
                    
                    
                    self.arrCitiesList = self.cityListObj?.stringCities
                 
                    self.filteredData =  self.arrCitiesList
                   
                   //                print("cityid",self.cityId)
                    print("get city data", self.filteredData)
                   
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
//                    self.methodDropDownCities(Cities: self.arrCitiesList!)
//                    self.getRefferID()
                }
                else{
                    if let message = self.cityListObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                       
                    }
                }
            }
            else {
                if let message = self.cityListObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                   
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    

}
extension City_selectionVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return filteredData.count ?? 0

        
        
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "Cell_CitySelectedVC") as! Cell_CitySelectedVC
       
        let aRequest = filteredData?[indexPath.row]
//        aCell.backview.dropShadow1()
        aCell.lblcityname.text = aRequest
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
        Seclected_City = filteredData?[indexPath.row]
        for i in getcitid
        {
            if i.name == Seclected_City
            {
                cityID = i.id
            }
                
        }
        
        
        City_View.isHidden = false
        let aCell = tableview.dequeueReusableCell(withIdentifier: "Cell_CitySelectedVC") as! Cell_CitySelectedVC
        aCell.lblcityname.textColor = UIColor(hexValue: 0x00CC96)
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
         GlobalData.user_City = Seclected_City!
        GlobalData.User_CityId = cityID
        print("city id get",  GlobalData.User_CityId)
    
        self.navigationController?.popViewController(animated: false)
  
        
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
                       self.filteredData = self.arrCitiesList
                    print(self.filteredData)
                   }
                }
               
            
            }else{
                 print(searchText)
              
                self.filteredData = self.arrCitiesList?.filter({ SearchCity -> Bool in
                    return SearchCity.lowercased().contains(searchText.lowercased())
                })
//                print(self.searchdoctor)
                if(filteredData.count == 0){
                    if(searchBar.text == ""){
                        filteredData = arrCitiesList
                    }
                   // self.nosearchlb.isHidden = false
                }else{
                    //self.nosearchlb.isHidden = true
                }
                
            }

            tableview.reloadData()


        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
            
        {
            
            searchBar.text = ""
                
            filteredData = arrCitiesList
                
            searchBar.endEditing(true)
                
                tableview.reloadData()
                
           
        }
       
    
}
extension UIView {

func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
   self.alpha = 0.0

   UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
       self.isHidden = false
       self.alpha = 1.0
   }, completion: completion)
}

func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
   self.alpha = 1.0

   UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
       self.alpha = 0.0
   }) { (completed) in
       self.isHidden = true
       completion(true)
   }
 }
}
class mycity
{
    var name = ""
    var id = 0
}
