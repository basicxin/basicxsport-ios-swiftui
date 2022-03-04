//
//  DateUtils.swift
//  BASICX SPORT
//
//  Created by Somesh K on 20/12/21.
//

import Foundation
class DateUtils {}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    static var currentTimeStamp: Int64{
           return Int64(Date().timeIntervalSince1970 * 1000)
       }
}
