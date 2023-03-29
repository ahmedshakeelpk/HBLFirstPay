//
//  NetworkManagerSUA.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 20/01/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManagerSUA {
    
    var networkSessionManager : Session?
    
    init() {
        
//        let serverTrustPolicies : [String: ServerTrustPolicy] = ["https://bb.fmfb.pk" : .pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true), "insecure.expired-apis.com": .disableEvaluation]
//        networkSessionManager = SessionManager( serverTrustPolicyManager: ServerTrustPolicyManager(policies:serverTrustPolicies))
        
        let evaluators: [String: ServerTrustEvaluating] = [
            "https://bb.fmfb.pk": PublicKeysTrustEvaluator(
                performDefaultValidation: false,
                validateHost: false
            ),
            "insecure.expired-apis.com": PublicKeysTrustEvaluator(
                performDefaultValidation: false,
                validateHost: false
            )
        ]
        let serverTrustManager = ServerTrustManager(evaluators: evaluators)
        networkSessionManager = Session(serverTrustManager: serverTrustManager)
    }
    
    
}


class ApiPinning {
    
    private static let networkManager = NetworkManagerSUA()
    
    public static func getManager() -> Session {
        return networkManager.networkSessionManager!
    }
}


/*
 
 Use
  
 NetworkManager.Manager!.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<AvailableLimitsModel>) in
 */
