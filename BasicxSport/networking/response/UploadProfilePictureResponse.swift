//
//  UploadProfilePictureResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 09/03/22.
//

// MARK: - UploadProfilePictureResponse

struct UploadProfilePictureResponse: Codable {
    let profilePictureUrl: String

    enum CodingKeys: String, CodingKey {
        case profilePictureUrl = "profilePictureURL"
    }
}
