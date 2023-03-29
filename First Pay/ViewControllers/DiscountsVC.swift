////
////  DiscountsVC.swift
////  First Wallet
////
////  Created by Syed Uzair Ahmed on 28/07/2020.
////  Copyright © 2020 FMFB Pakistan. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import ObjectMapper
//import SDWebImage
//import Foundation
//
//import Kingfisher
//import iOSDropDown
////import Lottie
//
//
//class DiscountsVC: BaseClassVC, UICollectionViewDelegate,UICollectionViewDataSource {
//    
//    @IBOutlet weak var lblSelectCity: UILabel!
//    @IBOutlet weak var dropdowncity: DropDown!
//    
//    @IBOutlet weak var lblMainTitle: UILabel!
//    var arraycategory : [Category] = []
//    var cityArray : [getCityID_Dis] = []
//    var cityNameArray = [String]()
//    var ProductArray : [productData] = []
//    @IBOutlet weak var lblhome: UILabel!
//    @IBOutlet weak var lblContactus: UILabel!
//    @IBOutlet weak var lblBookme: UILabel!
//    @IBOutlet weak var lblInviteFriend: UILabel!
//    
//    
//    
//    @IBOutlet var dropDownCities: UIDropDown!
//    var selectedCity:String?
//    var cityId : Int?
//    var catagoryID : Int?
//    var disCitiesObj : DiscountCityModel?
//    var discountsObj : DiscountsModel?
//    var disCateogoryObj : DiscountCategoryModel?
//    var disBrandObj : DiscountsBrandModel?
//    var getDiscountObj : GetDiscountsModel?
//    var discityObj : DiscityModel?
//    
//    var flag = "true"
//    
//    @IBOutlet var discountsTableView: UITableView!
//    
//    
//    @IBOutlet weak var collectionview: UICollectionView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        lblMainTitle.text = "Discounts".addLocalizableString(languageCode: languageCode)
////        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
////        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
////        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
////        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
////        collectionview.delegate = self
////        collectionview.dataSource = self
////        self.getCityList()
//////        self.getcategory()
////        dropdowncity.dropShadow1()
////        allbtnoutlet.setTitle("ALL".addLocalizableString(languageCode: languageCode), for: .normal)
////        lblSelectCity.text = "Select City".addLocalizableString(languageCode: languageCode)
////        self.dropdowncity.didSelect{(b , index ,id) in
////                    self.selectedCity = b
////
////            self.lblSelectCity.text = ""
////            self.dropdowncity.isSelected = true
////            self.dropdowncity.selectedRowColor = UIColor.gray
////            self.dropdowncity.isSearchEnable = true
////
//        }
//    }
//    
//   
//    
//    // MARK: - MethodDropDown Cities
//    
//    private func methodDropDownCities(Cities:[String]) {
//        
//        if dropDownCities.placeholder == "Select City".addLocalizableString(languageCode: languageCode)
//        {
//           
//            collectionview.isHidden = false
//            allbtnoutlet.isHidden = false
//        }
//        
//        self.dropDownCities.placeholder = "Select City".addLocalizableString(languageCode: languageCode)
//        self.dropDownCities.tableHeight = 250.0
//        self.dropDownCities.options = Cities
//        self.dropDownCities.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.dropDownCities.isSelected = true
//        self.dropDownCities.didSelect(completion: {
//            (option , index) in
//            self.collectionview.isHidden = false
//            self.allbtnoutlet.isHidden = false
//            print("You Just select: \(option) at index: \(index)")
//            self.selectedCity = option
//           // self.getCityList()
////            if self.selectedCity == self.discityObj?.data?[index].cityDescr
////            {
////                self.cityId = self.discityObj?.data?[index].cityId
////                print("cityid",self.cityId)
////            }
//            
////            self.getDiscount(city: option)
//            
//        })
//    }
//    func GetDisountList ()
//        {
//            
//        self.showActivityIndicator()
//       
//        ServerManager.GEt_typeWithoutParmsfetchApiData_PostAppJSON(APIMethodName: APIMethods.GetDiscountList.rawValue, Token: DataManager.instance.accessToken ?? "" ) { (Result : AlldiscountList?) in
//                
//                //== check if api is responding or not
//                guard Result != nil else {
//                  
//                        self.showAlert(title: "" , message: "No Data Found".addLocalizableString(languageCode: languageCode), completion: {
//                            self.navigationController?.popToRootViewController(animated: true)
//                        })
////                        self.showDefaultAlert(title: "", message: message)
//               
////                    UtilManager.showAlertMessage(message: "No Data Found", viewController: self)
////
////                     self.navigationController?.popToRootViewController(animated: true)
//                    return
//                }
//                
//            GlobalData.GetDiscountAll_List = Result!
//                
//              //  print(Result!)
//            print("token is :",GlobalData.GetDiscountAll_List.responsecode)
//            if GlobalData.GetDiscountAll_List.responsecode == 1 || GlobalData.GetDiscountAll_List.responsecode == 2
//                {
//           
//                  print("api call done")
//                
//                //GlobalData.GetDiscountAll_List.data[indexPath.row].tblBrandLocation.image!
//                self.ProductArray.removeAll()
//                for data in GlobalData.GetDiscountAll_List.data
//                {
//                    
//                    let tem_obj = productData()
//                    GlobalData.long = data.tblBrandLocation.longitude
//                    GlobalData.lat = data.tblBrandLocation.latitude
//                    tem_obj.Image = data.tblBrand.image
//                    tem_obj.brandDescription = data.tblBrand.brandDescr
//                    tem_obj.discountPercentage = data.discountPercentage
//                    tem_obj.city = self.selectedCity ?? ""
//                    tem_obj.contatct = data.tblBrandLocation.contactNo
//                    tem_obj.email = data.tblBrandLocation.email
//                    tem_obj.detail = data.discountDetails
//                    tem_obj.website = data.website ?? ""
//                    self.ProductArray.append(tem_obj)
//                }
//               
//                self.discountsTableView.delegate = self
//                self.discountsTableView.dataSource = self
//                self.discountsTableView.reloadData()
//                self.hideActivityIndicator()
//              
//                }
//                
//            }
//            
//        }
//    
//    func Get_Catagory_Description ()
//        {
//        if let citiesList = self.discityObj?.data{
//            for data in citiesList
//            {
//                
//                if selectedCity == data.cityDescr
//                {
//                    cityId = data.cityId
//                    print(cityId!)
//                }
//
//            }
//        }
//        //CtegoryDescriptionModel
//        showActivityIndicator()
//        print("sdd:" , cityId)
//        ServerManager.GEt_CityandcatgoryIDWithoutParmsfetchApiData_PostAppJSON(APIMethodName: APIMethods.GetDiscountList.rawValue, Token: DataManager.instance.accessToken ?? "" ,CityID: cityId ?? -1, CatagoryId: catagoryID! ) { (Result : Citycatagory?) in
//                
//                //== check if api is responding or not
//                guard Result != nil else {
//                    self.discountsTableView.isHidden = true
//                    UtilManager.showAlertMessage(message: " No Discount Found ", viewController: self)
//                   
////
//                 
//                    self.hideActivityIndicator()
//                    return
//                }
//           print("msg is:" ,GlobalData.newcatagory.messages)
//                
//            GlobalData.newcatagory = Result!
//                
//                print(Result!)
//          
//            if GlobalData.newcatagory.responsecode == 1 || GlobalData.newcatagory.responsecode  == 2
//                {
//                  print("api call done")
//               
//                self.ProductArray.removeAll()
//                for data in GlobalData.newcatagory.data
//                {
//                    var tem_obj = productData()
//                    tem_obj.Image = data.tblBrand.image
//                    tem_obj.brandDescription = data.tblBrand.brandDescr
//                    tem_obj.discountPercentage = data.discountPercentage
//                    tem_obj.city = self.selectedCity ?? ""
//                    tem_obj.contatct = data.tblBrandLocation.contactNo
//                    tem_obj.email = data.tblBrandLocation.email
//                    tem_obj.detail = data.discountDetails
//                    print(data.website)
//                    tem_obj.website = data.website ?? ""
//                  
//                    self.ProductArray.append(tem_obj)
//                }
//                self.discountsTableView.delegate = self
//                self.discountsTableView.dataSource = self
//                self.discountsTableView.reloadData()
////
//                self.hideActivityIndicator()
////
//                }
//           
//            }
//            
//        }
//    
//    
//    @IBAction func allbuttonaction(_ sender: UIButton) {
//       
//        allbtnoutlet.setBackgroundImage(#imageLiteral(resourceName: "submit_buttonNormal"), for: .normal)
//        self.GetDisountList ()
//    }
//    
//    @IBOutlet weak var allbtnoutlet: UIButton!
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//       print("click")
//        if flag == "true"
//        {
//            allbtnoutlet.isHidden = false
//            collectionview.isHidden = false
//      
//            flag = "false"
//        }
//        if flag == "false"
//        {
//            collectionview.isHidden = true
//            allbtnoutlet.isHidden = true
//            flag = "true"
//        }
//    }
//    
//    
//    @objc func labeltapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DiscountHistoryVC") as! DiscountHistoryVC
////
//        self.navigationController!.pushViewController(vc, animated: true)
////        NSLog ("You selected row: %@ \(indexPath)")
//    }
//    @IBAction func backbtn(_ sender: UIButton) {
//
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    
//    @IBAction func homeaction(_ sender: UIButton) {
//        
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
//        
//    }
//
//    
//    @IBAction func inviteFriends(_ sender: Any) {
//        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
//        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
//    }
//    
//    
//    @IBAction func centerbtn(_ sender: UIButton) {
//        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
////        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
////        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func ticketsbtn(_ sender: UIButton) {
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
//    }
//    
//    
//    @IBAction func contactus(_ sender: UIButton) {
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
//    }
//    // MARK: - API CALL
//    
//    private func getCities() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        
//        showActivityIndicator()
//        
//        let compelteUrl = GlobalConstants.BASE_URL + "getDiscountCity"
//        let header = ["Content-Type":"application/json"]
//        
//        print(header)
//        print(compelteUrl)
//        
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<DiscountCityModel>) in
//          
//            self.hideActivityIndicator()
//            
//            self.disCitiesObj = response.result.value
//            if response.response?.statusCode == 200 {
//                
//                if self.disCitiesObj?.responsecode == 2 || self.disCitiesObj?.responsecode == 1 {
//                    if let citiesList = self.disCitiesObj?.citiesdata{
//                       // self.methodDropDownCities(Cities: citiesList)
//                    }
//                   
//                    //                    self.methodDropDownCities(Cities: (self.disCitiesObj?.citiesdata)!)
//                }
//                else {
//                    if let message = self.disCitiesObj?.messages{
//                        self.showAlert(title: "", message: message, completion: nil)
//                    }
//                }
//            }
//            else {
//                
////                print(response.result.value)
////                print(response.response?.statusCode)
//                
//            }
//        }
//    }
//    
//    private func getcategory() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        
//        showActivityIndicator()
//        
//        let compelteUrl = GlobalConstants.BASE_URL + "getDiscountsCategory"
//        let header = ["Content-Type":"application/json"]
//        
//        print(header)
//        print(compelteUrl)
//        
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<DiscountCategoryModel>) in
//            
//            self.hideActivityIndicator()
//            
//            self.disCateogoryObj = response.result.value
//            if response.response?.statusCode == 200 {
//                print("api call done ")
//                print("discryption is",disCateogoryObj?.data?[0].categoryDescr)
//                self.collectionview.dataSource = self
//                self.collectionview.delegate = self
//                collectionview.reloadData()
//                
//                if self.disCateogoryObj?.responsecode == 2 || self.disCateogoryObj?.responsecode == 1 {
//                    
//                    collectionview.reloadData()
////                     api call all
//                    // self.GetDisountList()
//                    // end calling all
//                  
//        // loadCategory()
//            
//                }
//                else {
//                    if let message = self.disCateogoryObj?.messages{
//                        UtilManager.showAlertMessage(message:  (self.disCateogoryObj?.messages)!, viewController: self)
////                        self.showAlert(title: "", message: message, completion: nil)
//                    }
//                }
//            }
//            else {
//                
////                print(response.result.value)
////                print(response.response?.statusCode)
//                
//            }
//        }
//    }
//    private func DiscountBrand() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        
//        showActivityIndicator()
//        
//        let compelteUrl = GlobalConstants.BASE_URL + "getDiscountsBrands"
//        let header = ["Content-Type":"application/json"]
//        
//        print(header)
//        print(compelteUrl)
//        
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<DiscountsBrandModel>) in
//            
//            self.hideActivityIndicator()
//            
//            self.disBrandObj = response.result.value
//            if response.response?.statusCode == 200 {
//                print("api call done ")
//                print("discryption is",disCateogoryObj?.data?[0].categoryDescr)
//                
//                
//                if self.disBrandObj?.responsecode == 2 || self.disBrandObj?.responsecode == 1 {
//                    discountsTableView.delegate = self
//                    discountsTableView.dataSource = self
//        
//            
//                }
//                else {
//                    if let message = self.disBrandObj?.messages{
//                        UtilManager.showAlertMessage(message:  (self.disBrandObj?.messages)!, viewController: self)
////                        self.showAlert(title: "", message: message, completion: nil)
//                    }
//                }
//            }
//            else {
//                
////                print(response.result.value)
////                print(response.response?.statusCode)
//                
//            }
//        }
//    }
//    
//   
//    
////    citylist
//    private func getCityList() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        
//        showActivityIndicator()
//        
//        let compelteUrl = GlobalConstants.BASE_URL + "getDiscountsCity"
//        let header = ["Content-Type":"application/json"]
//        
//        print(header)
//        print(compelteUrl)
//        
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<DiscityModel>) in
//            
//            self.hideActivityIndicator()
//            
//            self.discityObj = response.result.value
//            if response.response?.statusCode == 200 {
//              
//                
//                if self.discityObj?.responsecode == 2 || self.discityObj?.responsecode == 1 {
//                    print("api succesfull run")
//                        self.getcategory()
////
//                    
//                    if let citiesList = self.discityObj?.data{
//                        for data in citiesList
//                        {
//                            
//                            cityNameArray.append(data.cityDescr ?? "")
//                            
//                        }
//                        dropdowncity.optionArray = cityNameArray
////                        self.GetDisountList()
//                        
//                    }
//                    
//                }
//                else {
//                    if let message = self.discityObj?.messages{
//                        UtilManager.showAlertMessage(message:  (self.discityObj?.messages)!, viewController: self)
////                        self.showAlert(title: "", message: message, completion: nil)
//                    }
//                }
//            }
//            else {
//                
//                
//            }
//        }
//    }
//    
////
//    @objc func btnClicked(_sender:UIButton)
//    {
//        
//        
//        let tag = _sender.tag
//        
//        let cell = collectionview.cellForItem(at: IndexPath(row: tag, section: 0)) as! DiscountCollectionviewcell
////        cell.btntext.setBackgroundImage(#imageLiteral(resourceName: "submit_buttonNormal"), for: .normal)
//        allbtnoutlet.setBackgroundImage(#imageLiteral(resourceName: "login"), for: .normal)
//        collectionview.reloadData()
//        let selectedCatagory = disCateogoryObj?.data?[tag].categoryDescr
//        //disCateogoryObj?.data?[0].categoryDescr
//        print(selectedCity)
////
//      
//        if selectedCity == nil
//        {
//            selectedCity = "LAHORE"
//        }
//        else
//        {
//            if selectedCatagory == disCateogoryObj?.data?[tag].categoryDescr
//            {
//              
//                 catagoryID = disCateogoryObj?.data?[tag].categoryId
//                print("cat id",catagoryID)
//              
//                Get_Catagory_Description()
//            }
//        }
//        
//        
//    }
////    func  CamraAnimation ()
////        {
////        let aCell = tableView.dequeueReusableCell(withIdentifier: "DiscountsTableViewCell") as! DiscountsTableViewCell
////        aCell.loader.contentMode = .scaleAspectFit
//////        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//////        let aCell = tableView.cellForRowAtIndexPath(indexPath)
////            let checkMarkAnimation =  AnimationView(name: "loager")
////        aCell.loader.contentMode = .scaleAspectFit
////        aCell.loader.addSubview(checkMarkAnimation)
////            checkMarkAnimation.frame = self.loaderview.bounds
////            checkMarkAnimation.loopMode = .loop
////            checkMarkAnimation.play()
////
////        }
//}
//extension DiscountsVC {
//    
//
//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    
//    return disCateogoryObj?.data?.count ?? -1
//
//}
//
//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    
//let cell1 = collectionview.dequeueReusableCell(withReuseIdentifier: "DiscountCollectionviewcell", for: indexPath) as!
//   DiscountCollectionviewcell
////    cell1.btntext.tag = indexpath.row
//    
//    let value = disCateogoryObj?.data?[indexPath.row].categoryDescr
//    
//    cell1.btntext.setTitle(value, for: .normal)
//    cell1.btntext.tag = indexPath.row
//    cell1.btntext.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
//    return cell1
//}
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let cell = collectionView.cellForItem(at: indexPath)
////        cell?.tag = indexPath.row
////        let tag = _sender.tag
////        let cell = collectionview.cellForItem(at: IndexPath(row: tag, section: 0)) as! DiscountCollectionviewcell
////         cell.btntext.setBackgroundImage(#imageLiteral(resourceName: "submit_buttonNormal"), for: .normal)
//      
//        let selectedCatagory = disCateogoryObj?.data?[indexPath.row].categoryDescr
//        
//        disCateogoryObj?.data?[0].categoryDescr
//        if selectedCatagory == disCateogoryObj?.data?[indexPath.row].categoryDescr
//        {
//            
//            catagoryID = disCateogoryObj?.data?[indexPath.row].categoryId
//            print("cat id",catagoryID)
////            self.DiscountBrand()
//            Get_Catagory_Description()
//        }
//       
//    }
//}
//extension DiscountsVC : UITableViewDelegate , UITableViewDataSource
//{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ProductArray.count
//       
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let aCell = tableView.dequeueReusableCell(withIdentifier: "DiscountsTableViewCell") as! DiscountsTableViewCell
//        print(ProductArray[indexPath.row].brandDescription)
//        aCell.viewback.dropShadow1()
//        aCell.lblproduct.text = ProductArray[indexPath.row].brandDescription
//        aCell.lblDiscount.text = "Discount \(ProductArray[indexPath.row].discountPercentage)%"
//
//        var imageurl = ProductArray[indexPath.row].Image
////
//        aCell.imgview.imageFromServerURL(urlString: imageurl)
// 
//        return aCell
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
//        UIView.animate(withDuration: 0.3, animations: {
//                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
//                },completion: { finished in
//                    UIView.animate(withDuration: 0.1, animations: {
//                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
//                    })
//            })
//     }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if selectedCity == nil
//        {
//            selectedCity = "LAHORE"
//        }
//
//        else
//        {
////            CamraAnimation ()
//            showActivityIndicator()
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "DiscountHistoryVC") as! DiscountHistoryVC
//             vc.city = selectedCity ?? ""
//        
//        vc.email = ProductArray[indexPath.row].email
//             vc.contact =  ProductArray[indexPath.row].contatct
//             vc.detail = ProductArray[indexPath.row].detail
//             vc.discountproduct = ProductArray[indexPath.row].discountDescripotion
//        vc.image = ProductArray[indexPath.row].Image
//        vc.branddes = ProductArray[indexPath.row].brandDescription
//        vc.website = ProductArray[indexPath.row].website
//            vc.discountproduct = ProductArray[indexPath.row].discountPercentage
//        print(ProductArray[indexPath.row].website)
//       
//             self.navigationController!.pushViewController(vc, animated: true)
//        hideActivityIndicator()
//    }
//    }
//    
//}
//
//
//class Category
//{
//    var categoryId = 0
//    var categoryCode = ""
//    var categoryDescr = ""
//    var createdate = ""
//    var createuser = ""
//    var lastupdatedate = ""
//    var lastupdateuser = 0
//    var sortSeq = 0
//    var status = ""
//    var updateindex = 0
//    var tblBrands = ""
//    
//}
//class getCityID_Dis
//{
//    var city_ID = 0
//    var City_Discription = ""
//}
//class productData
//{
//    var brandDescription = ""
//    var discountDescripotion = ""
//    var Image = ""
//    var city = ""
//    var email = ""
//    var contatct = ""
//    var website = ""
//    var detail = ""
//    var discountPercentage = ""
//    
//}
//extension UIImageView {
//public func imageFromServerURL(urlString: String) {
//    self.image = nil
//    let urlStringNew = urlString.replacingOccurrences(of: " ", with: "%20")
//    URLSession.shared.dataTask(with: NSURL(string: urlStringNew)! as URL, completionHandler: { (data, response, error) -> Void in
//
//        if error != nil {
//            print(error as Any)
//            return
//        }
//        DispatchQueue.main.async(execute: { () -> Void in
//            let image = UIImage(data: data!)
//            self.image = image
//        })
//
//    }).resume()
//}}
