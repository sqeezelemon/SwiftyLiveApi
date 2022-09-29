// SwiftyLiveApi
// ↳ LAUserStatsRequest.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

internal struct LAUserStatsRequest: Encodable {
    public var userIds: [String]
    public var usernames: [String]
    public var userHashes: [String]
    
    private enum CodingKeys: String, CodingKey {
        case userIds
        case usernames = "discourseNames"
        case userHashes
    }
}
