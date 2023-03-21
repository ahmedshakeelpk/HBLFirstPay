//
//  GetBankNames.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 25/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class GetBankNames: Mappable {
    
    var singleBank: [SingleBank]?
    var responsecode: Int?
    var messages:String?
    var stringBanks = [String]()
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        singleBank <- map["data"]
        
        for aBank in self.singleBank! {
            stringBanks.append(aBank.bankName!)
        }
        
    }
}


class SingleBank : Mappable {
    
    var imdListId : Int?
    var bankName : String?
    var createdate : String?
    var createuser : Int?
    var descr : String?
    var format : String?
    var imdNo : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var status : String?
    var updateindex : String?
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
                imdListId <- map["imdListId"]
               bankName <- map ["bankName"]
               createdate <- map["createdate"]
               createuser <- map ["createuser"]
               descr <- map["descr"]
               format <- map ["format"]
               imdNo <- map["imdNo"]
               lastupdatedate <- map ["lastupdatedate"]
               lastupdateuser <- map["lastupdateuser"]
               status <- map ["status"]
               updateindex <- map["updateindex"]

        
    }
}
