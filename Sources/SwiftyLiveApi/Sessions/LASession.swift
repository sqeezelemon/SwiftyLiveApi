// SwiftyLiveApi
// ↳ LASession.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single Infinite Flight session.
public struct LASession: Decodable {
    public init(id: String, name: String, userCount: Int, maxUsers: Int, type: LASessionType) {
        self.id = id
        self.name = name
        self.userCount = userCount
        self.maxUsers = maxUsers
        self.type = type
    }
    
    /// Unique ID of the server.
    public var id: String
    /// Name of the server.
    public var name: String
    /// Amount of users connected to the server.
    public var userCount: Int
    ///Maximum amount of users the server can accept.
    public var maxUsers: Int
    /// Session type.
    public var type: LASessionType
}
