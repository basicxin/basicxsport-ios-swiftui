//
//  PaymentTransaction.swift
//  BasicxSport
//
//  Created by Somesh K on 05/03/22.
//

import Foundation

struct PaymentTransaction: Encodable {
    var apiKey: String
    var memberid: String
    var paymentMethod: String
    var TXNID: String
    var TXNAMOUNT: String
    var BANKNAME: String
    var BANKTXNID: String
    var CURRENCY: String
    var GATEWAYNAME: String
    var MID: String
    var ORDERID: String
    var PAYMENTMODE: String
    var RESPCODE: String
    var RESPMSG: String
    var STATUS: String
}
