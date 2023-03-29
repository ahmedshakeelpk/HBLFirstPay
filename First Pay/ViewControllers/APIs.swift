//
//  APIs.swift
//  talkPHR
//
//  Created by Shakeel Ahmed on 3/20/21.
//

import Foundation
import Alamofire
import SwiftyJSON


struct APIs {
    static var shared = APIs()
    func sessionManger(timeOut: Int) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeOut)
        configuration.httpShouldUsePipelining = true
        let sessionManger = Session(configuration: configuration, startRequestsImmediately: true)
        return sessionManger
    }
    
//    func sessionManger(timeOut: Int) -> SessionManager {
//        let serverTrustPolicies : [String: ServerTrustPolicy] = ["https://bb.fmfb.pk" : .pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true), "insecure.expired-apis.com": .disableEvaluation]
//        let networkSessionManager = SessionManager( serverTrustPolicyManager: ServerTrustPolicyManager(policies:serverTrustPolicies))
//        return networkSessionManager
//    }
    
    
    static func load(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")

                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }
    
    
    static func funDownloadFileViaUrl(_ urlString: String, viewController: UIViewController) {
        
    }

    
//    static let ipAddress = UIDevice.current.ipAddress() ?? ""
//    static let deviceInfo = UIDevice.modelName
//    static let grantType = "password"
//    static let deviceToken = General_Elements.shared.deviceToken
//    //static let authToken = "bearer \(General_Elements.shared.userProfileData?.data?.accessTokenResponse?.accessToken ?? "")"
//    static let authToken = "bearer \(Constant.kAccessToken)"
//    static let header: HTTPHeaders = ["Content-Type": "application/json"
//                               ,"device_info" : deviceInfo ,
//                               "device_token" : deviceToken ,
    
    
//                               "ip" : ipAddress ,
//                               "grant_type" : grantType]
//
//    static let headerWithToken: HTTPHeaders = ["Content-Type": "application/json"
//                               ,"device_info" : deviceInfo ,
//                               "device_token" : deviceToken ,
//                               "ip" : ipAddress ,
//                               "grant_type" : grantType,
//                               "Authorization" : authToken]
    
    
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func postAPI(url: String, parameters: [String: Any], headers: HTTPHeaders?, completion: @escaping(_ response: JSON?, Bool, _ errorMsg: String) -> Void) {
        
        let stringParamters = APIs.json(from: parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
//        print(parameters)
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        

        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]

        // longitude and latitude round off to 4 digits
//        print(params)
//        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        //let postData = stringParamters!.data(using: .utf8)

        let url = URL(string: url)!
        let jsonData = stringParamters!.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\(DataManager.instance.accessToken ?? "nil")", forHTTPHeaderField: "Authorization")

        request.httpBody = jsonData

        //print("\(APIs.json(from: parameters)))")
        
//        Alamofire.request(request).responseJSON { response in
//            print("Response: \(response)")
//
//            switch response.result {
//            case .success(let json):
//                let serverResponse = JSON(response.value!)
//                print("JSON: \(serverResponse)")
//                print("JSON: \(json)")
//                switch response.response?.statusCode {
//                case 200 :
//                    if serverResponse["responsecode"] == 1 {
//                        completion(serverResponse, true, "")
//                    }
//                    else {
//                        completion(serverResponse, false, serverResponse["message"].string ?? "")
//                    }
//                    break
//                default :
//                    completion(serverResponse, false, serverResponse["message"].string ?? "")
//                    break
//                }
//            case .failure( _):
//                var errorMessage = ""
//                if let error = response.error?.localizedDescription {
//                    let errorArray = error.components(separatedBy: ":")
//                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
//                    completion(nil, false, errorMessage)
//                }
//                else {
//                    errorMessage = response.error.debugDescription
//                    completion(nil, false, response.error.debugDescription)
//                }
//                break
//            }
//        }
    }
    
    
    static func postAPI2(apiName: APIs.name, parameters: [String: Any], viewController: UIViewController?, queryParameterDictionary: [String: Any]?, encoding: ParameterEncoding? = JSONEncoding.default, customSessionManager: Session? = nil, completion: @escaping(_ response: JSON?, Bool, _ errorMsg: String) -> Void) {
        
        
        //let url = "\(apiName.url())"

//        let ipAddress = UIDevice.current.ipAddress() ?? ""
//        let deviceInfo = UIDevice.modelName
//        let grantType = "password"
//        let deviceToken = General_Elements.shared.deviceToken
        let authTokenHardCoded = "Basic nil"
        
        let tokenType = "Basic"
        let authToken = DataManager.instance.accessToken ?? "nil" ?? authTokenHardCoded
        let headerWithToken: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "\(tokenType) \(authToken)"
        ]
//
        print("URL: \(apiName.url)")
        print("Parameters: \(parameters)")
        print("Header: \(headerWithToken)")

        var urlComponents = URLComponents(string: apiName.url)
        var queryItems: [URLQueryItem] = []
        
        for item in queryParameterDictionary! {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        urlComponents?.queryItems = queryItems
        let url = urlComponents?.url!
        print("Complete URL: \(String(describing: url))")
        
        let sessionManger = customSessionManager ?? APIs.shared.sessionManger(timeOut: 20)
        if viewController != nil {
            viewController!.view.showLoader(viewController: viewController!)
        }
        sessionManger.request(url!, method: .post, parameters: parameters, encoding: encoding!, headers: headerWithToken).response { response in
            sessionManger.cancelAllRequests()
            if viewController != nil {
            viewController!.view.removeLoader(viewController: viewController!)
            }
            print("Response: \(response.data)")
//            let json = JSON(data: response.data!)
//            print(json)
//            print("Response: \(response.response?.body ?? HTTPURLResponse())")

            switch response.result {
            case .success(let json):
                var responseMessage = ""
                if let data = response.data {
                    print("Response data: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)")
                    responseMessage = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                }
                let serverResponse = JSON(response.value! ?? "No JSON Response, JSON is empty\nURL: \(apiName.url)")
                
                if serverResponse.isEmpty {
                    print("empty data")
                    completion(nil, true, responseMessage)
                    return
                }
                print("JSON serverResponse: \(serverResponse)\nURL: \(apiName.url)")
                print("JSON json Data: \(json!)\nURL: \(apiName.url)")
                switch response.response?.statusCode {
                case 200 :
                    completion(serverResponse, true, "")
                    break
                default :
                    completion(serverResponse, false, serverResponse["message"].string ?? "")
                    break
                }
            case .failure( _):
                var errorMessage = ""
                if let error = response.error?.localizedDescription {
                    let errorArray = error.components(separatedBy: ":")
                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
                    completion(nil, false, errorMessage)
                }
                else {
                    errorMessage = response.error.debugDescription
                    completion(nil, false, response.error.debugDescription)
                }
                break
            }
        }
    }
    
    
    
    
    //Working Code with URLSession Request
    static func downloadFileFromURLSessionRequest(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")

                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }

    
    static var kBaseURL = baseUrlHttpStagging
    
    static let  baseUrlHttp = "http://bbuat.hblmfb.com/"
    static let baseUrlHttps =  "https://bb.fmfb.pk/irisrest/"
    static let baseUrlHttpStagging = "http://bbuat.fmfb.pk/irisrest/"
    
    enum name: String {
        //MARK:- Auth
        case LoginUser_multi = "LoginUser_multi"
        case Login = "Auth/Login"
        
        var url : String {
            return APIs.kBaseURL + self.rawValue
        }
    }
    
    
    static func splitString(stringToSplit : String) -> (apiAttribute1:String,apiAttribute2:String) {
        
        let varLength : Int?
        var attr1 : String?
        var attr2 : String?
        
        varLength = stringToSplit.count/2
        
        let splitString = stringToSplit.split(by: varLength!)
        let arr = Array(splitString).map { String($0) }
        //        print(arr)
        
        if arr.count == 0 {
            return ("","")
        }
        
        attr1 = arr[0]
        if arr.count%2 == 0{
            attr2 = arr[1]
        }
        else{
            attr2 = arr[1] + arr[2]
        }
        
        return (attr1!,attr2!)
    }
    
    static func base64EncodedString( params : [String : Any]) -> String {
      
        let base64EncodedString : String
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decodedString = String(data: jsonData, encoding: .utf8)!
        
        //          let encoder = JSONEncoder()
        //          let jsonData = (try? encoder.encode(params))!
        //          let jsonString = String(data: jsonData, encoding: .utf8)
        //            print(jsonString!)
        
        base64EncodedString = decodedString.toBase64()
        return base64EncodedString
    }
}






extension UIView {
    func showLoader(viewController: UIViewController) {
        let child = HZProgressHud()
        viewController.addChildViewController(child)
        child.view.frame = viewController.view.frame
        child.view.frame.origin.y = 0
        viewController.view.addSubview(child.view)
        child.didMove(toParentViewController: viewController)
    }
    
    /* Remove Loader */
    func removeLoader(viewController: UIViewController) {
        let child = viewController.childViewControllers.last
        child?.willMove(toParentViewController: nil)
        child?.view.removeFromSuperview()
        child?.removeFromParentViewController()
    }
}
