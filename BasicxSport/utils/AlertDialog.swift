//
//  File.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 18/01/22.
//

import SwiftUI

struct AlertDialog: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}
