// SwiftyLiveApi
// ↳ LAUserStats.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Stats for a single user.
public struct LAUserStats: Decodable {
    public init(userId: String, virtualOrganization: String? = nil, username: String? = nil, roles: [Int], onlineFlights: Int, violations: Int, violationsByLevel: LAViolationCount, xp: Double, landingCount: Int, flightTime: Double, atcOperations: Int, atcRank: LAAtcRank, grade: Int, hash: String) {
        self.userId = userId
        self.virtualOrganization = virtualOrganization
        self.username = username
        self.roles = roles
        self.onlineFlights = onlineFlights
        self.violations = violations
        self.violationsByLevel = violationsByLevel
        self.xp = xp
        self.landingCount = landingCount
        self.flightTime = flightTime
        self.atcOperations = atcOperations
        self.atcRank = atcRank
        self.grade = grade
        self.hash = hash
    }
    
    /// Unique identifier of the user.
    public var userId: String
    /// User's forum VA/VO, `nil` if not linked, not set or anonymous.
    public var virtualOrganization: String?
    /// User's forum username, `nil` if not linked or anonymous.
    public var username: String?
    
    // To be removed in a future update
    // public var groups: [String]
    
    /// List of user roles. See [docs] for most common.
    ///
    /// [docs]: https://infiniteflight.com/guide/developer-reference/live-api/user-stats#roles
    public var roles: [Int]
    
    // Not in use for the endpoint
    // public var errorCode: LAError
    
    /// Number of online flights.
    public var onlineFlights: Int
    /// Total amount of violations received by the user.
    public var violations: Int
    /// Violations received by user, split by level.
    public var violationsByLevel: LAViolationCount
    /// Total XP obtained in multiplayer.
    public var xp: Double
    /// Total landings conducted in multiplayer.
    public var landingCount: Int
    /// Total multiplayer flight time, in minutes.
    public var flightTime: Double
    /// Total amount of ATC operations.
    public var atcOperations: Int
    /// Expert server ATC rank, defaults to `.observer` if `null`.
    public var atcRank: LAAtcRank
    /// Current grade of the user.
    public var grade: Int
    /// Short form user identifier, as seen in the app.
    public var hash: String
    
    private enum CodingKeys: String, CodingKey {
        case userId, virtualOrganization
        case username = "discourseUsername"
        case roles, onlineFlights, violations
        case violationsByLevel = "violationsCountByLevel"
        case xp, landingCount, flightTime, atcOperations, atcRank, grade, hash
    }
}
