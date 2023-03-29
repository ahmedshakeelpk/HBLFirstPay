//
//  Statement_Transaction_HistoryVC.swift
//  First Pay
//
//  Created by Irum Butt on 06/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class Statement_Transaction_HistoryVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.myStatementObj?.ministatement?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellTransation_Statement_HistoryVc") as! cellTransation_Statement_HistoryVc
        aCell.img.image = #imageLiteral(resourceName: "Arrow Icon")
        aCell.selectionStyle = .none
        aCell.btn.setTitle("", for: .normal)
        let aStatement = self.myStatementObj?.ministatement![indexPath.row]
//        getDataStatemnt = self.myStatementObj?.ministatement![indexPath.row]
        aCell.lblbankName.text = aStatement?.transDocsDescr
        aCell.lbldate.text = aStatement?.transDate
        
        aCell.lblAmount.text = " Rs.\(aStatement?.txnAmt! ?? 0)"
        if aStatement?.amountType == "C"{
//            aCell.lblType.text = "Credit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            aCell.img.image = #imageLiteral(resourceName: "Arrow Icon-1")
            aCell.lblbankName.text = aStatement?.sourceBank
//            self.miniStatementObj?.ministatement?[0].sourceBank
//
        }
        else if aStatement?.amountType == "D" {
//            aCell.lblType.text = "Debit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            aCell.img.image = #imageLiteral(resourceName: "Arrow Icon")
            aCell.lblbankName.text = aStatement?.sourceBank
            
//
        }

        aCell.btnDetail.setTitle("", for: .normal)
        aCell.btnDetail.tag = indexPath.row
        
        aCell.btnDetail.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)

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
        let aStatement = self.myStatementObj?.ministatement![indexPath.row]
          let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "Statement_History_Detail_VC") as! Statement_History_Detail_VC
        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"
        if aStatement?.amountType == "C"{
            detailsVC.strCreditDebit = "CREDIT"
        }
        else if aStatement?.amountType == "D" {
            detailsVC.strCreditDebit = "DEBIT"
        }
        detailsVC.strReceiverWallet = ("\(aStatement?.toAccountTitle ?? "") \n\(aStatement?.toAccountNo ?? "")")
                detailsVC.strSourceWallet = ("\(aStatement?.fromAccountTitle ?? "") \n\(aStatement?.fromAccountNo ?? "")")
                detailsVC.strDateTime = aStatement?.transDate
                detailsVC.strTransactionType = aStatement?.transDocsDescr
                detailsVC.strPurpose = aStatement?.transRefnum
                detailsVC.strSourceBank = aStatement?.sourceBank
                detailsVC.strDestinationBank = aStatement?.destinationBank
                detailsVC.strChannel = aStatement?.channel
                detailsVC.strOpenningBalance = "\(aStatement?.openingbalance ?? 00)"
                detailsVC.strClosingBalance = "\(aStatement?.closingBalance ?? 00)"
                detailsVC.status = aStatement?.status
        self.transRefNum = aStatement?.transRefnum
               if  withoutholdingtax != nil{
                   detailsVC.whtAmt = aStatement?.whtAmt
               }
               else
               {
                   detailsVC.whtAmt = Int(0.0)
       
               }
        self.navigationController!.pushViewController(detailsVC, animated: false)
        self.tableView.reloadData()
    }
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
//
      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellTransation_Statement_HistoryVc
        let detailsVC = self.storyboard!.instantiateViewController(withIdentifier: "Statement_History_Detail_VC") as! Statement_History_Detail_VC
        let aStatement = self.myStatementObj?.ministatement![tag]
        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"

        if aStatement?.amountType == "C"{
            detailsVC.strCreditDebit = "CREDIT"
        }
        else if aStatement?.amountType == "D" {
            detailsVC.strCreditDebit = "DEBIT"
        }
        detailsVC.strReceiverWallet = ("\(aStatement?.toAccountTitle ?? "") \n\(aStatement?.toAccountNo ?? "")")
                detailsVC.strSourceWallet = ("\(aStatement?.fromAccountTitle ?? "") \n\(aStatement?.fromAccountNo ?? "")")
                detailsVC.strDateTime = aStatement?.transDate
                detailsVC.strTransactionType = aStatement?.transDocsDescr
                detailsVC.strPurpose = aStatement?.transRefnum
                detailsVC.strSourceBank = aStatement?.sourceBank
                detailsVC.strDestinationBank = aStatement?.destinationBank
                detailsVC.strChannel = aStatement?.channel
                detailsVC.strOpenningBalance = "\(aStatement?.openingbalance ?? 00)"
                detailsVC.strClosingBalance = "\(aStatement?.closingBalance ?? 00)"
                detailsVC.status = aStatement?.status
        self.transRefNum = aStatement?.transRefnum
               if  withoutholdingtax != nil{
                   detailsVC.whtAmt = aStatement?.whtAmt
               }
               else
               {
                   detailsVC.whtAmt = Int(0.0)

               }
        self.navigationController!.pushViewController(detailsVC, animated: false)
    }
    
    
   
       
    
    var dateFrom = NSDate()
    var dateTo = NSDate()
    var isFrom:String?
    var myStatementObj:MiniStatementModel?
    var geturl : URL!
    var transRefNum : String?
    var fromNewDateVar : Date?
    var withoutholdingtax : Int?
    static let networkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblfromdate.isHidden = true
        lblTodate.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        btnDownLoad.setTitle("", for: .normal)
        btnBack.setTitle("", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("disputeButtonPressed"), object: nil)
        tableView.rowHeight = 109
        getMiniStatementwithoutDates()
        btnShow.setTitle("", for: .normal)
//        btnShow.isHidden = true
        ToDateTextfiled.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
         let disputeVC = self.storyboard!.instantiateViewController(withIdentifier: "Statement_History_Detail_VC") as! Statement_History_Detail_VC
//        disputeVC.transRefnum = self.transRefNum
        self.navigationController!.pushViewController(disputeVC, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    let datePicker = UIDatePicker()
   
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var ToDateTextfiled: UITextField!
    @IBOutlet weak var fromDateTextfield: UITextField!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btnDownLoad: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var lblTodate: UILabel!
    @IBOutlet weak var lblfromdate: UILabel!
    @IBAction func fromDate(_ sender: UITextField) {
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateFrom"
        datePickerObj.maximumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy/HH:mm"
        let fromNewDate = dateFormatter.string(from: datePickerObj.date)
        self.fromNewDateVar = datePickerObj.date
//        self.fromDateTextfield.text = fromNewDate
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        self.ToDateTextfiled.isUserInteractionEnabled = true
        
//

    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if isFrom == "dateFrom"{
//         var getFromDate = dateFormatter.string(from: sender.date)
//            getFromDate = getFromDate.substring(to: 10)
            fromDateTextfield.text = dateFormatter.string(from: sender.date)
            dateFrom =  sender.date as NSDate
            self.fromNewDateVar = sender.date
        }
        else if isFrom == "dateTo"{
            var  gettodatevalue =  dateFormatter.string(from: sender.date)
            gettodatevalue = gettodatevalue.substring(to: 10)
//            ToDateTextfiled.text = dateFormatter.string(from: sender.date)
            dateTo = sender.date as NSDate
        }
    }
   
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
    
   
    
    @IBAction func toDate(_ sender: UITextField) {
        let currentDate = self.fromNewDateVar
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let oneMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate!)

        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        isFrom = "dateTo"

//        datePickerObj.minimumDate = oneMonthAgo
//        datePickerObj.maximumDate = currentDate

        datePickerObj.minimumDate = currentDate
        datePickerObj.maximumDate = oneMonthAgo

        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.ToDateTextfiled.text = newDate
        btnShow.isHidden = false
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
   
        
    }
    
    
    
    @IBAction func Show(_ sender: UIButton) {
        
        getMiniStatement()
        
    }
    
    
    
    
    
    @IBAction func back(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_download(_ sender: UIButton) {
        screenshot()
    }
    // MARK: - API Call
      public func getMiniStatementwithoutDates() {
              if !NetworkConnectivity.isConnectedToInternet(){
                  self.showToast(title: "No Internet Available")
                  return
              }
          showActivityIndicator()
          let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/miniStatement"
         //     let parameters = ["channelId":"\(DataManager.instance.channelID)","acountId":"\(DataManager.instance.accountId!)"],
          var userCnic : String?
          userCnic = UserDefaults.standard.string(forKey: "userCnic")
          let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate":"","toDate":"", "accountType": DataManager.instance.accountType!,"cnic":userCnic!, "imeiNo":DataManager.instance.imei!]
              print(parameters)
              let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
              print(result.apiAttribute1)
              print(result.apiAttribute2)
              let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
          let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
              print(params)
              print(compelteUrl)
              print(header)
              NetworkManager.sharedInstance.enableCertificatePinning()
          let sessionManger = APIs.shared.sessionManger(timeOut: 20)
          let error: Error!
          sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
              sessionManger.cancelAllRequests()
              let forecasts = Mapper<MiniStatementModel>().map(JSONObject: response.result)
              self.myStatementObj = forecasts
                     self.hideActivityIndicator()
          
//          NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
//                  self.hideActivityIndicator()
//                  self.myStatementObj = response.result.value
                  if response.response?.statusCode == 200 {
                      if self.myStatementObj?.responsecode == 2 || self.myStatementObj?.responsecode == 1 {
                          
                          GlobalData.transRefnum = (self.myStatementObj?.ministatement?[0].transRefnum)!
                          print("fetch transation refference Number",  GlobalData.transRefnum)
                          
                          
                          
                          
                          self.tableView.reloadData()
                      }
                      else {
                          if let message = self.myStatementObj?.messages{
                              self.showDefaultAlert(title: "", message: message)
                          }
                      }
                  }
                  else {
                      if let message = self.myStatementObj?.messages{
                          self.showDefaultAlert(title: "", message: message)
                      }
  //                    print(response.result.value)
  //                    print(response.response?.statusCode)
                  }
              }
          }
    public func getMiniStatement() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        let stringFrom = self.formattedDateFromString(dateString: fromDateTextfield.text!, withFormat: "yyyy-MM-dd")
        
        let stringTo = self.formattedDateFromString(dateString: ToDateTextfiled.text!, withFormat: "yyyy-MM-dd")
        print("fromdate ", stringFrom)
        print("fromto ", stringTo)
        showActivityIndicator()
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/miniStatement"
//        2020-05-10 23:59:59
        let parameters = ["channelId":"\(DataManager.instance.channelID)","fromDate": stringFrom! + " 00:00:01","toDate": stringTo!  + " 23:59:59","accountType": DataManager.instance.accountType!,"cnic":userCnic!, "imeiNo":DataManager.instance.imei!]
//        let parameters = ["" : ""]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        let sessionManger = APIs.shared.sessionManger(timeOut: 20)
        let error: Error!
        sessionManger.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).response { (response) in
            sessionManger.cancelAllRequests()
            let forecasts = Mapper<MiniStatementModel>().map(JSONObject: response.result)
            self.myStatementObj = forecasts
                   self.hideActivityIndicator()
        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
//
//            self.hideActivityIndicator()
//
//            self.myStatementObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.myStatementObj?.responsecode == 2 || self.myStatementObj?.responsecode == 1 {
                    GlobalData.transRefnum = (self.myStatementObj?.ministatement?[0].transRefnum)!
                    print("fetch transation refference Number",  GlobalData.transRefnum)
//                    if self.miniStatementObj != nil {
//                        completionHandler(self.miniStatementObj!)
//                    }
                    self.tableView.reloadData()
                }
                else {
                  
                    if let message = self.myStatementObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    self.tableView.reloadData()
                }
            }
            else {
                if let message = self.myStatementObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}
extension Statement_Transaction_HistoryVC {
    func screenshot() -> UIImage{
       
       var image = UIImage();
       UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, false, UIScreen.main.scale)
       // save initial values
       let savedContentOffset = self.tableView.contentOffset;
       let savedFrame = self.tableView.frame;
       let savedBackgroundColor = self.tableView.backgroundColor
       
       // reset offset to top left point
       self.tableView.contentOffset = CGPoint(x: 0, y: 0);
       // set frame to content size
       self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height);
       // remove background
       self.tableView.backgroundColor = self.tableView.backgroundColor;
       
       // make temp view with scroll view content size
       // a workaround for issue when image on ipad was drawn incorrectly
       let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: self.tableView.contentSize.height));
    
       // save superview
       let tempSuperView = self.tableView.superview
       
       // Save constraints
       guard let superView = self.tableView.superview else {
           return UIImage();
       }
       //get old constraints from table
       var oldConstraints: [NSLayoutConstraint] = []
       for constraint in superView.constraints {
           if constraint.firstItem as? NSObject == self.tableView || constraint.secondItem as? NSObject == self.tableView{
              oldConstraints.append(constraint)
          }
       }
       // remove scrollView from old superview
       self.tableView.removeFromSuperview()
       // and add to tempView
       tempView.addSubview(self.tableView)
       
       // render view
       // drawViewHierarchyInRect not working correctly
       tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
       // and get image
       image = UIGraphicsGetImageFromCurrentImageContext()!;
       // and return everything back
       tempView.subviews[0].removeFromSuperview()
       tempSuperView?.addSubview(self.tableView)
       //activate table's old constraints
       NSLayoutConstraint.activate(oldConstraints)
       // restore saved settings
       self.tableView.contentOffset = savedContentOffset;
       self.tableView.frame = savedFrame;
       self.tableView.backgroundColor = savedBackgroundColor
        
       UIGraphicsEndImageContext();
       UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
       showToast(title: "Photo Saved Successfully!")
       return image
   }
}
