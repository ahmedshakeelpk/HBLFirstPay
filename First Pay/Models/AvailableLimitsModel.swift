//
//  AvailableLimitsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/12/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


struct AvailableLimitsModel : Mappable {
    var responsecode : Int?
    var limitsData : LimitsData?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        limitsData <- map["data"]
        messages <- map["messages"]
    }

}

struct LimitsData : Mappable {
    
    var accountId : Int?
    var accountNo : String?
    var dailyConsumed : Int?
    var dailyReceived : Int?
    var levelDescr : String?
    var maxAmtLimit : Int?
    var maxAmtPerTxn : Int?
    var monthlyConsumed : Int?
    var monthlyReceived : Int?
    var totalDailyLimit : Int?
    var totalDailyLimitCr : Int?
    var totalMonthlyLimit : Int?
    var totalMonthlyLimitCr : Int?
    var totalYearlyLimit : Int?
    var totalYearlyLimitCr : Int?
    var yearlyConsumed : Int?
    var yearlyReceived : Int?
    var dailyLevelDebitLimit : Int?
    var monthlyLevelDebitLimit : Int?
    var yearlyLevelDebitLimit : Int?
    var dailyLevelCreditLimit : Int?
    var monthlyLevelCreditLimit : Int?
    var yearlyLevelCreditLimit : Int?


    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

       
        accountId <- map["accountId"]
        accountNo <- map["accountNo"]
        dailyConsumed <- map["dailyConsumed"]
        dailyReceived <- map["dailyReceived"]
        levelDescr <- map["levelDescr"]
        maxAmtLimit <- map["maxAmtLimit"]
        maxAmtPerTxn <- map["maxAmtPerTxn"]
        monthlyConsumed <- map["monthlyConsumed"]
        monthlyReceived <- map["monthlyReceived"]
        totalDailyLimit <- map["totalDailyLimit"]
        totalDailyLimitCr <- map["totalDailyLimitCr"]
        totalMonthlyLimit <- map["totalMonthlyLimit"]
        totalMonthlyLimitCr <- map["totalMonthlyLimitCr"]
        totalYearlyLimit <- map["totalYearlyLimit"]
        totalYearlyLimitCr <- map["totalYearlyLimitCr"]
        yearlyConsumed <- map["yearlyConsumed"]
        yearlyReceived <- map["yearlyReceived"]
        dailyLevelDebitLimit <- map["dailyLevelDebitLimit"]
        monthlyLevelDebitLimit <- map["monthlyLevelDebitLimit"]
        yearlyLevelDebitLimit <- map["yearlyLevelDebitLimit"]
        dailyLevelCreditLimit <- map["dailyLevelCreditLimit"]
        monthlyLevelCreditLimit <- map["monthlyLevelCreditLimit"]
        yearlyLevelCreditLimit <- map["yearlyLevelCreditLimit"]
    }

}
