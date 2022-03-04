//
//  Error+.swift
//  NetworkingDemo
//
//  Created by Alex Nagy on 02.10.2021.
//

import Foundation
import Networking

extension Error {
    func getError() -> String {
        switch self {
        case let decodingError as DecodingError:
            print("JSON decoding error: \(decodingError.description ?? "Unknown Error")")
            return decodingError.description ?? "Unknown Error"
        case let networkingError as NetworkingError:
            print("Networking error: \(networkingError.description)")
            return networkingError.description
        default:
            print(self.localizedDescription)
            return self.localizedDescription
        }
    }
}
