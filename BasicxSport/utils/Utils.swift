//
//  Utils.swift
//  BASICX SPORT
//
//  Created by Somesh K on 16/12/21.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    items.forEach {
        Swift.print($0, separator: separator, terminator: terminator)
    }
    #endif
}
