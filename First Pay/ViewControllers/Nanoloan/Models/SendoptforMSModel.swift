//
//  SendoptforMSModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 13/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

struct sendOtpForManualSettlementModel : Mappable {
    var responsecode : Int?
    var dataotp : String?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        dataotp <- map["data"]
        messages <- map["messages"]
    }

}
