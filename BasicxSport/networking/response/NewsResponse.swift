//
//  NewsResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 06/12/21.
//
  
import Foundation

 
// MARK: - NewsDataClass
struct NewsResponse: Codable {
    let news: [News]
    let banners: [Banner]
    let appVersion: String
}

// MARK: - Banner
struct Banner: Codable, Hashable {
    let id: Int
    let name: String
    let lastUpdated: Int
    let bannerURL: String
    let webLinkURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, lastUpdated
        case bannerURL = "bannerUrl"
        case webLinkURL = "webLinkUrl"
    }
}

// MARK: - News
struct News: Codable, Hashable {
    let id: Int
    var displayTitle, title: String
    var coverPicThumbURL: String
    var publishedDate: Int64
    var publishedNewsURL: String
    var likeCount: Int? = 0
    var isLiked: Bool? = false

    enum CodingKeys: String, CodingKey {
        case id, displayTitle, title
        case coverPicThumbURL = "coverPicThumbUrl"
        case publishedDate
        case publishedNewsURL = "publishedNewsUrl"
        case likeCount, isLiked
    }
}
