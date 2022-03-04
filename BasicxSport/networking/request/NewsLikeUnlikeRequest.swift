//
//  NewsLikeUnlikeRequest.swift
//  BASICX SPORT
//
//  Created by Somesh K on 15/12/21.
//

import Foundation
struct NewsLikeUnlikeRequest : Encodable{
    let memberId: Int, apiKey: String, objectId: Int
}
