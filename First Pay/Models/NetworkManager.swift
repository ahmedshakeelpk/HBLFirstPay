//
//  NetworkManager.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    var sessionManager: Session?
    
    func enableCertificatePinning() {
        
        //         For certificates
        //                let trustPolicy = ServerTrustPolicy.pinCertificates(
        //                    certificates: ServerTrustPolicy.certificates(),
        //                    validateCertificateChain: true,
        //                    validateHost: true)
        
        // For PublicKey pining
        //        let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(
        //            publicKeys: ServerTrustPolicy.publicKeys(),
        //            validateCertificateChain: true,
        //            validateHost: true)
        //
        //        let trustPolicies = [ "https://bb.fmfb.pk": serverTrustPolicy ]
        //        let policyManager =  ServerTrustPolicyManager(policies: trustPolicies)
        //
        //
        
        let evaluators: [String: ServerTrustEvaluating] = [
            "https://bb.fmfb.pk": PublicKeysTrustEvaluator(
                performDefaultValidation: false,
                validateHost: false
            )
        ]
        let serverTrustManager = ServerTrustManager(evaluators: evaluators)
        sessionManager = Session(serverTrustManager: serverTrustManager)
        
        
        //        sessionManager = Session(
        //            configuration: .default,
        //            serverTrustPolicyManager: policyManager)
        
    }
}


