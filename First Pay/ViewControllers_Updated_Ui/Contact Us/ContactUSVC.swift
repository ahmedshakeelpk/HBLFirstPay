//
//  ContactUSVC.swift
//  First Pay
//
//  Created by Irum Butt on 22/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import MessageUI
class ContactUSVC: BaseClassVC,MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            self.showToast(title: "Message canceled")
            print("message canceled")
        case MessageComposeResult.failed.rawValue :
            self.showToast(title: "Message failed")
            print("message failed")
        case MessageComposeResult.sent.rawValue :
            self.showToast(title: "Message sent")
            print("message sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    var arrCategory  = ["Inquiry","Complaint","Suggestion","Feedback"]
    var selectedCategory:String?
    var genericObj:GenericResponse?
    var myarr = [category]()
    var visibleIndexPath: IndexPath? = nil
    var IsSelectedCategorgy = true
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewCategory.delegate = self
        collectionViewCategory.dataSource = self
        Homebtn.setTitle("", for: .normal)
        btnAccount.setTitle("", for: .normal)
        btnLoactor.setTitle("", for: .normal)
        btnScanQR.setTitle("", for: .normal)
        btnNotification.setTitle("", for: .normal)
        viewScanQR.backgroundColor =  UIColor(hexValue: 0x00CC96)
        btnBack.setTitle("", for: .normal)
        buttonContinue.isUserInteractionEnabled = false
        
        btnAlertView.isHidden = true
        btnAlertView.setTitle("", for: .normal)
        appendArray()
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(Send(tapGestureRecognizer:)))
        img_next.addGestureRecognizer(tapGestureRecognizerr)
        
        
    }
    func appendArray(){
        for i in arrCategory{
            myarr.append(category(name: i, isSeleccted: false))
        }
    }
    @IBOutlet weak var viewScanQR: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet weak var Homebtn: UIButton!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var lblLocator: UILabel!
    @IBOutlet weak var btnLoactor: UIButton!
    @IBOutlet weak var btnScanQR: UIButton!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblMainTitile: UILabel!
    @IBOutlet weak var Tfname: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAlertView: UIButton!
    
    
    @IBOutlet weak var img_next: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBAction func ActionHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dash_Board", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home_ScreenVC")
        self.present(vc, animated: true)
        
    }
    
    
    @IBAction func Action_Notification(_ sender: UIButton) {
        
    }
    
    
    @IBAction func Action_ScanQR(_ sender: UIButton) {
    }
    
    
    @IBAction func Action_Locator(_ sender: UIButton) {
    }
    
    @IBAction func Action_Account(_ sender: UIButton) {
    }
    @IBAction func Action_Send(_ sender: UIButton) {
        
       
        sendComplaint()
        
        
    }
    @objc func Send(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        sendComplaint()
        
    }

    @IBAction func Action_Back(_ sender: UIButton) {
          self.dismiss(animated: true)
        
    }
    
    
    
    @IBAction func Action_AlertView(_ sender: UIButton) {
//
//        btnAlertView.isHidden = true
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
        
        
        
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.rangeOfCharacter(from: .letters) != nil || string == " " {
            return true
        }
        else if !(string == "" && range.length > 0) {
        return false
        
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.rangeOfCharacter(from: .letters) != nil || text == " " {
                   return true
               }
               else if !(text == "" && range.length > 0) {
               return false
               }
        if text == "\n"
        {
            messageTextView.resignFirstResponder()
        }
//        if (Tfname.text == nil) || (messageTextView.text == nil)
//            {
//                buttonContinue.isUserInteractionEnabled = false
//                let image = UIImage(named: "grayArrow")
//                img_next.image = image
//                img_next.isUserInteractionEnabled = false
//            }

        
               return true
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
     
            messageTextView.text = ""
            
       }
    private func sendComplaint(){

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()

//        let compelteUrl = GlobalConstants.BASE_URL + "bbscontactUs"
       var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/contactUs"
        let parameters = ["channelId":"\(DataManager.instance.channelID)","name":self.Tfname.text!,"category":self.selectedCategory!,"message":self.messageTextView.text!,"cnic": userCnic!,"imei": DataManager.instance.imei!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
//        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in

            self.hideActivityIndicator()
            self.genericObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                    self.btnAlertView.isHidden = false
                   
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showToast(title: message)
//                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericObj?.messages{
                    self.showToast(title: message)
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }

    }
    @objc func buttontaped(_sender:UIButton)
    {
        
        let tag = _sender.tag
               
                let cell = collectionViewCategory.cellForItem(at: IndexPath(row: tag, section: 0)) as! cellCategory
                for i in  myarr{
                    i.isSeleccted = false
                }
        selectedCategory =  String(arrCategory[tag])
             self.myarr[tag].isSeleccted = true

             cell.btnCategory.setTitleColor(.white, for: .normal)
//        cell.btnCategory.borderColor = .clear
        cell.backView.backgroundColor =  UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
        cell.btnCategory.setImage(.none, for: .normal)
                self.collectionViewCategory.reloadData()
        if (Tfname.text != nil) && selectedCategory != nil{
            buttonContinue.isUserInteractionEnabled = true
            let image = UIImage(named: "]greenarrow")
            img_next.image = image
            img_next.isUserInteractionEnabled = true
            messageTextView.isUserInteractionEnabled = false
            Tfname.isUserInteractionEnabled = false
        }
    }
   
    
}
extension ContactUSVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewCategory .dequeueReusableCell(withReuseIdentifier: "cellCategory", for: indexPath) as! cellCategory
        if(myarr[indexPath.row].isSeleccted == true){
            cell.btnCategory.setTitleColor(.white, for: .normal)  ///set title color here to white
            
            cell.backView.backgroundColor =   UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
            cell.btnCategory.setImage(.none, for: .normal)
//            cell.btnCategory.backgroundColor = .orange
        }else{
            //set title color here to black
            cell.btnCategory.setTitleColor(.black, for: .normal)
            cell.btnCategory.backgroundColor = .clear
            cell.backView.backgroundColor = .clear
            let setimg = UIImage(named: "")
            cell.btnCategory.setImage(setimg, for: .normal)
            cell.btnCategory.backgroundColor = .clear
            
        }
        cell.btnCategory.setTitle(myarr[indexPath.row].name, for: .normal)
        cell.btnCategory.tag = indexPath.row
        cell.btnCategory.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)

        return cell

    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        NSLog ("You selected row: %@ \(indexPath)")
//        selectedCategory =  String(arrCategory[indexPath.row])
//        let cell = collectionViewCategory .dequeueReusableCell(withReuseIdentifier: "cellCategory", for: indexPath) as! cellCategory
////        cell.backView.
////        cell.btnCategory.backgroundColor = UIColor.lightGray
////        cell.btnCategory.setTitleColor(.black, for: .normal)
////        myarr[indexPath.row].isSeleccted = false
//
//
//    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let visibleIndexPath = self.visibleIndexPath {
            
            // This conditional makes sure you only animate cells from the bottom and not the top, your choice to remove.
            if indexPath.row > visibleIndexPath.row {
                
                cell.contentView.alpha = 0.3
                
                cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
                
                // Simple Animation
                UIView.animate(withDuration: 0.5) {
                    cell.contentView.alpha = 1
                    cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                }
            }
        }
    }
    
}
class category
{
    var name : String
    var isSeleccted : Bool
    init(name : String , isSeleccted : Bool ){
        self.name = name
        self.isSeleccted = isSeleccted
    }
    
}

