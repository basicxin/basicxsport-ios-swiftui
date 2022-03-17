//
//  Events.swift
//  BasicxSport
//
//  Created by Somesh K on 17/03/22.
//

import Foundation

class Events: ObservableObject {
    static let shared = Events()
    @Published var myCircleChanged = false
    @Published var newCirclePurchased = false

    private init() {}
}
