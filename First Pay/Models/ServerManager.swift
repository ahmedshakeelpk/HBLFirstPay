//
//  ServerManager.swift
//  Webdocoffical
//
//  Created by Hassan on 16/04/2020.
//  Copyright © 2020 WebDoc. All rights reserved.
//


import Foundation
import Alamofire
import UIKit
import KYDrawerController

import MapKit
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import CryptoSwift
import RNCryptor


import ObjectMapper
import SwiftKeychainWrapper

var alamoFireManager: Session? = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = TimeInterval(410)
    configuration.httpShouldUsePipelining = true
    let sessionManger = Session(configuration: configuration, startRequestsImmediately: true)
    return sessionManger

}()


struct APIPath {

    //original ur
 public static let  BASE_URL = "http://bbuat.hblmfb.com/"
 static let baseurl =  "https://bb.fmfb.pk/irisrest/"
 static let staggingurl = "http://bbuat.fmfb.pk/irisrest/"
// static let baseurl =  "http://bbuat.fmfb.pk/nanoloan/"
//  static var baseurl = "http://bbuat.fmfb.pk/irisrest/"
    //testing url
// static let BaseURL = "https://webdoctesting.webddocsystems.com/iOSApp.svc/"
   // static let ImageUploadURL = "http://e-compare.com.pk/carpictures/upload.php"
    
    
    
    
    // static let BaseURL = "https://sandbox.jsbl.com/mb/verifyaccount/v0/"
    
    
    //ya balance inquery ki ha
    //  static let BaseURL = "https://sandbox.jsbl.com/balance/v0/"

   
}

//Mark: - API Methods
enum APIMethods : String{
    //api k method
    case Login = "v2/custLastTransaction"
    case banner = "FirstPayInfo/v1/getDiscountBanners"
    case GetDiscountList = "FirstPayInfo/getDiscountsList"
    case GetLoanEligibity = "checkLoanEligibility"
    case ChangeLimitManagemntData = "getChannelLimits"
    
}



//Mark: - API Calling
class ServerManager  : BaseClassVC{
 
    //================== generic Api Manager Function
    
    static func fetchGenericData<T: Decodable>(APIMethodName : String, passingPatameterDict : [String: Any] , completion: @escaping (T?) -> ()) {
       // UtilManager.showProgress()
        
        let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
        
        print(url)
        
        print(passingPatameterDict)
        
        Alamofire.request(url, method: .post, parameters: passingPatameterDict, encoding: JSONEncoding.default).responseJSON { response in
            
           // UtilManager.dismissGlobalHUD()
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    if response.result.value != nil {
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: response.data!)
                            completion(obj)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(nil)
                            GlobalData.APIStatusCode = status
                            print("*** === *** Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                        }
                        
                    }else {
                        completion(nil)
                        GlobalData.APIStatusCode = status
                        print("***====*** No JSON Data")
                    }
                    
                case 401:
                    completion(nil)
                    GlobalData.APIStatusCode = status
                    print("401: Session Expied")
                    
                default:
                    GlobalData.APIStatusCode = status
                    completion(nil)
                    print(status)
                    
                    print("-=-=-=-= Error: in API Path")
                }
                
            } else {
                completion(nil)
                print( "************" , response.response?.statusCode.description )
                print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
            }
        }
        
        
    }//end generic function
    

    //---------->Func without parameters
    
    static func WithoutParafetchGenericData<T: Decodable>(APIMethodName : String, completion: @escaping (T?) -> ()) {
        UtilManager.showProgress()
        
        let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
        
        print(url)
        
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        Alamofire.request(url, method: .post, encoding:  JSONEncoding.default, headers: header).responseJSON { (response ) in
        
        //Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { response in
            
            UtilManager.dismissGlobalHUD()
            
            
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    if response.result.value != nil {
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: response.data!)
                            completion(obj)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(nil)
                            print("*** === *** Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                        }
                        
                    }else {
                        completion(nil)
                        print("***====*** No JSON Data")
                    }
                    
                case 401:
                    completion(nil)
                    print("401: Session Expied")
                    
                default:
                    completion(nil)
                    print("-=-=-=-= Error: in API Path")
                }
                
            } else {
                completion(nil)
                print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
            }
        }
        
        
    }//end without parameters
    
    static func fetchApiData_PostAppJSON<T: Decodable>(APIMethodName : String,  passingPatameterDict : [String: Any] , completion: @escaping (T?) -> ()) {
          UtilManager.showProgress()
          
          let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
          print(url)
          
          
          
          let headers = [
//              "Authorization" : "Bearer \(Token)",
              "Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"
          ]
          
          
          
          Alamofire.request(url, method: .post, parameters: passingPatameterDict, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response ) in
              
              UtilManager.dismissGlobalHUD()
              
              if let status = response.response?.statusCode {
                  switch(status){
                  case 200:
                      
                      
                      debugPrint(response)
                      
                      
                      let responseJson = response.result.value! as! NSDictionary
                      print(responseJson)
                      
                      
                      ///=====
                      if response.result.value != nil {
                          do {
                              let obj = try JSONDecoder().decode(T.self, from: response.data!)
                              completion(obj)
                          }catch{
                              completion(nil)
                              print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                          }
                          
                      }else {
                          completion(nil)
                          print("***====*** No JSON Data")
                      }
                      
                  case 401:
                      completion(nil)
                      print("401: Session Expied")
                      
                      
                      
                  default:
                      completion(nil)
                      print("-=-=-=-= Error: in API Path")
                  }
                  
              } else {
                  completion(nil)
                  print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
              }
          }
          
          
      }//end generic function
    
   //new
    static func GEt_typeWithoutParmsfetchApiData_PostAppJSON<T: Decodable>(APIMethodName : String, Token : String, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
            
//        let url = "\(APIPath.staggingurl)\(APIMethodName)"
        let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
            print("url", url)
            let headers = [
                "Content-Type":"application/json","Authorization":"\(Token))"
            ]
            
            
    //        let headers = [
    //            "Authorization" : "Basic \(Token)",
    //            "Content-Type": "application/json"
    //        ]
            
            print(headers)
            
            Alamofire.request(url, method: .get, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response ) in
                
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:

                        debugPrint(response)
                        if response.result.value != nil {
                            do {
                                let responseJson = response.result.value as! NSDictionary
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                print(responseJson)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                         
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }//ho gia ha
                
            }
            
            
        }//end generic function
        
   // for getcatory+cityId
    static func GEt_CityandcatgoryIDWithoutParmsfetchApiData_PostAppJSON<T: Decodable>(APIMethodName : String, Token : String, CityID : Int, CatagoryId : Int, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
        
        
            let headers = [
                "Content-Type":"application/json","Authorization":"\(Token))"
            ]
        let url  = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
            
            print(headers)
            
           
            Alamofire.request(url, method: .get, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response ) in
                
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        
                        debugPrint(response)
                        
                        
//                        let responseJson = response.result.value as! NSDictionary
//                        print(responseJson)
                        
                        
                        ///=====
                        if response.result.value != nil {
                            do {
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }
            }
            
            
        }//end generic function
//    ckeckLoanEligibilty with parameters
    static func CheckLoan<T: Decodable>(APIMethodName : String, Token : String, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
            
        let url  = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
        print(url)
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        var userCnic : String?
      
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
      
        let dict:[String : Any] = ["imei":  DataManager.instance.imei!,
                                   "channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"amount" :"5000","productId": "3"
            
        ]
  
        print(dict)
           
        Alamofire.request(url,  method: .post, parameters: dict, encoding: JSONEncoding.default, headers: header).responseJSON
        {(response ) in
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        
                        debugPrint(response)
                        
                        
                        let responseJson = response.result.value as! NSDictionary
                        print(responseJson)
                        
                        
                        ///=====
                        if response.result.value != nil {
                            do {
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }
            }
            
            
        }
//    api NanoloanProductModel withoutparameters
    static func WithoutParafetchNanoloanProduct<T: Decodable>(APIMethodName : String, completion: @escaping (T?) -> ()) {
        UtilManager.showProgress()
        
        let url = "\(APIPath.baseurl)\(APIMethodName)"
        
        print(url)
        
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        Alamofire.request(url, method: .get, encoding:  JSONEncoding.default, headers: header).responseJSON { (response ) in
        
        //Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { response in
            
            UtilManager.dismissGlobalHUD()
            
            
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    if response.result.value != nil {
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: response.data!)
                            completion(obj)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(nil)
                            print("*** === *** Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                        }
                        
                    }else {
                        completion(nil)
                        print("***====*** No JSON Data")
                    }
                    
                case 401:
                    completion(nil)
                    print("401: Session Expied")
                    
                default:
                    completion(nil)
                    print("-=-=-=-= Error: in API Path")
                }
                
            } else {
                completion(nil)
                print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
            }
        }
    }
    static func LimitManagmentwithParameter<T: Decodable>(APIMethodName : String, Token : String, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
            
        let url  = "\(APIPath.baseurl)\(APIMethodName)"
        print(url)
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        var userCnic : String?
      
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
      
        let dict:[String : Any] = ["imei":  DataManager.instance.imei!,
                                   "channelId":"\(DataManager.instance.channelID)","cnic":userCnic!
            
        ]
  
        print(dict)
           
        Alamofire.request(url,  method: .post, parameters: dict, encoding: JSONEncoding.default, headers: header).responseJSON
        {(response ) in
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        
                        debugPrint(response)
                        
                        
                        let responseJson = response.result.value as! NSDictionary
                        print(responseJson)
                        
                        
                        ///=====
                        if response.result.value != nil {
                            do {
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }
            }
            
            
        }
  
}
