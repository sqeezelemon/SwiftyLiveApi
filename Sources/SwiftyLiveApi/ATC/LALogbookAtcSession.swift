// SwiftyLiveApi
// ↳ LALogbookAtcSession.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A logged ATC session.
public struct LALogbookAtcSession: Decodable {
    public init(id: String, sessionGroupId: String, facility: LAAtcFacility, created: Date, updated: Date, operations: Int, totalTime: Double) {
        self.id = id
        self.sessionGroupId = sessionGroupId
        self.facility = facility
        self.created = created
        self.updated = updated
        self.operations = operations
        self.totalTime = totalTime
    }
    
    /// Unique ID of the session.
    public var id: String
    /// Identifies a group of sessions (for when a controller opens multiple frequencies at once).
    public var sessionGroupId: String?
    /// Information about the facility.
    public var facility: LAAtcFacility
    /// Time at which the frequency was opened.
    @LADate
    public var created: Date
    /// Time at which the last report was received.
    @LADate
    public var updated: Date
    /// Operations earned during the session.
    public var operations: Int
    /// Total time on the frequency, in minutes.
    public var totalTime: Double
}
