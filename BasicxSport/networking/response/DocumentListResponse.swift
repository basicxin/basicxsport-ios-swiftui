//
//  DocumentListResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 07/03/22.
//

import Foundation

// MARK: - DocumentListResponse

struct DocumentListResponse: Codable {
    let memberDocuments: [MemberDocument]
}

// MARK: - MemberDocument

struct MemberDocument: Codable, Hashable {
    let id: Int
    let searchName: String
    let docFileUrl: String
    let docIdentityNo: String
    let docType: IdentityType
}
 
