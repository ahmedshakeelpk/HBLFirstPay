//
//  OtherServices_VC.swift
//  First Pay
//
//  Created by Irum Butt on 22/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import RNCryptor
import Kingfisher
class OtherServices_VC: BaseClassVC , UISearchBarDelegate{
    var imgarrMobileLoad : [UIImage] =  [#imageLiteral(resourceName: "Bookme"), #imageLiteral(resourceName: "ComityLogo"), #imageLiteral(resourceName: "Discounts"), #imageLiteral(resourceName: "Donations"),#imageLiteral(resourceName: "Bookme"),#imageLiteral(resourceName: "Bookme"),#imageLiteral(resourceName: "Bookme"),#imageLiteral(resourceName: "Bookme")]

//    ["Bookme.png","ComityLogo.png","Discounts.png","Donations.png","Bookme.png","ComityLogo.png","Discounts.png","Donations.png"]
    
    var MobileLoaddarrName = ["Book Me", "Committee", "Discounts", "Donations","Book Me", "Committee", "Discounts", "Donations"]
    
    
    var filteredData: [UIImage]!
    var Seclected_City :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnback.setTitle("", for: .normal)
        collectionViewMobileLoad.delegate = self
        collectionViewMobileLoad.dataSource = self
        searchBar.delegate = self
        
        collectionViewSendMoney.delegate = self
        collectionViewSendMoney.dataSource = self
        collectionViewBillPyment.delegate = self
        collectionViewBillPyment.dataSource = self
        collectionViewLoans.delegate = self
        collectionViewLoans.dataSource = self
        collectionViewTravel.delegate = self
        collectionViewTravel.dataSource = self
        filteredData = imgarrMobileLoad
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var collectionViewBillPyment: UICollectionView!
    @IBOutlet weak var collectionViewTravel: UICollectionView!
    @IBOutlet weak var collectionViewLoans: UICollectionView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblMianTitle: UILabel!
    @IBOutlet weak var lblMobileLoad: UILabel!
    @IBOutlet weak var collectionViewMobileLoad: UICollectionView!
    @IBOutlet weak var lblSendMoney: UILabel!
    @IBOutlet weak var lblBillpayment: UILabel!
    @IBOutlet weak var collectionViewSendMoney: UICollectionView!
    @IBOutlet weak var lblLoans: UILabel!
    @IBOutlet weak var lblTravel: UILabel!
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true)
        
        
        
        
    }
    //    @objc func buttontaped(_sender:UIButton)
//    {
//
//       let tag = _sender.tag
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DengueDiseaseVc") as! DengueDiseaseVc
//         selecteddisease = namearr[tag]
//         selectedimage = imgarr[tag]
//        self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//    }
    
    

}
extension OtherServices_VC : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//         return 100
       
        if collectionView == collectionViewMobileLoad
        {
            return filteredData.count ?? 0
        }
        else if collectionView == collectionViewSendMoney
        {
            return filteredData.count ?? 0
        }
        else if collectionView == collectionViewBillPyment
        {
            return filteredData.count ?? 0
        }
        else if collectionView == collectionViewLoans
        {
            return filteredData.count ?? 0
        }
        else{
            return filteredData.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == collectionViewMobileLoad
        {
            let cell = collectionViewMobileLoad .dequeueReusableCell(withReuseIdentifier: "cellMobileLoadServices", for: indexPath) as! cellMobileLoadServices
             cell.btnServices.setTitle("", for: .normal)
        cell.btnServices.setImage(filteredData[indexPath.row], for: UIControl.State.normal)
//        cell.lblServices.text = MobileLoaddarrName[indexPath.row]
        
        cell.btnServices.tag = indexPath.row
        cell.lblServices.tag = indexPath.row
        
//        cell.btnServices.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
             
            return cell
        }
        else if collectionView == collectionViewSendMoney
        {
            let cellA = collectionViewSendMoney .dequeueReusableCell(withReuseIdentifier: "cellSendMoney", for: indexPath) as! cellSendMoney
            cellA.btnSendMoney.setTitle("", for: .normal)
            cellA.btnSendMoney.setImage(filteredData[indexPath.row], for: UIControl.State.normal)
            cellA.btnSendMoney.tag = indexPath.row
            return cellA
        }
        else if collectionView == collectionViewBillPyment
        {
            let cellA = collectionViewBillPyment .dequeueReusableCell(withReuseIdentifier: "cellBillPayment", for: indexPath) as! cellBillPayment
            cellA.btnBillPayment.setTitle("", for: .normal)
            cellA.btnBillPayment.setImage(filteredData[indexPath.row], for: UIControl.State.normal)
            cellA.btnBillPayment.tag = indexPath.row
            return cellA
        }
        else if collectionView == collectionViewLoans
        {
            let cellB = collectionViewLoans .dequeueReusableCell(withReuseIdentifier: "cellLoans", for: indexPath) as! cellLoans
            cellB.btnLoans.setTitle("", for: .normal)
            cellB.btnLoans.setImage(filteredData[indexPath.row], for: UIControl.State.normal)
            cellB.btnLoans.tag = indexPath.row
            return cellB
        }
//        return
        else{
            let cellC = collectionViewTravel .dequeueReusableCell(withReuseIdentifier: "cellTravels", for: indexPath) as! cellTravels
            cellC.btnTravel.setTitle("", for: .normal)
            cellC.btnTravel.setImage(filteredData[indexPath.row], for: UIControl.State.normal)
            cellC.btnTravel.tag = indexPath.row
            return cellC

        }
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
                       self.filteredData = self.imgarrMobileLoad
                    print(self.filteredData)
                   }
                }
               
            
//            }else{
//                 print(searchText)
//
//                self.filteredData = self.imgarrMobileLoad?.filter({ SearchCity -> Bool in
//                    return true
////                    return
////                    SearchCity.lowercased().contains(searchText.lowercased())
//                })
//                print(self.searchdoctor)
                if(filteredData.count == 0){
                    if(searchBar.text == ""){
                        filteredData = imgarrMobileLoad
                    }
                   // self.nosearchlb.isHidden = false
                }else{
                    //self.nosearchlb.isHidden = true
                }
                
            }

//            tableview.reloadData()


        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
            
        {
            
            searchBar.text = ""
                
            filteredData = imgarrMobileLoad
                
            searchBar.endEditing(true)
                
//                tableview.reloadData()
                
           
        }
       
    
}
    
    
    

