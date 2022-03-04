//
//  GalleryResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 03/01/22.
//

import Foundation

// MARK: - DataClass

struct GalleryResponse: Codable {
    let galleryList: [GalleryBean]

    enum CodingKeys: String, CodingKey {
        case galleryList
    }
}

// MARK: - GalaryList

struct GalleryBean: Codable, Hashable {
    let id: Int
    let galaryListDescription: String
    let name: String
    let galleryCoverPhotoUrl: String
    let galleryPhotos: [GalleryPhoto]

    enum CodingKeys: String, CodingKey {
        case id
        case galaryListDescription = "description"
        case name
        case galleryCoverPhotoUrl
        case galleryPhotos
    }
}

// MARK: - GalleryPhoto

struct GalleryPhoto: Codable, Hashable {
    let id: Int
    let title: String
    let photoUrl: String
    let noOfLikes: Int?
    let noOfComments: Int?
    let mediaType: String
    let isLiked: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case photoUrl
        case noOfLikes
        case noOfComments
        case mediaType
        case isLiked
    }
}
