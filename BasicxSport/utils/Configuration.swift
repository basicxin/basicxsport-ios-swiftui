//
//  Configuration.swift
//  BasicxSport
//
//  Created by BASICX Admin on 09/08/24.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum DynamicValues {
    static var baseURL: String {
        do {
            let key: String = try Configuration.value(for: "BASE_URL")
            return "https://" + key
        } catch {
            // Handle error as appropriate for your app. For example:
            print("Error retrieving base URL: \(error)")
            return ""
        }
    }
    
    static var razorPaykey: String {
        let key:String = try! Configuration.value(for: "RAZOR_PAY_KEY")
        return key
    }
}
