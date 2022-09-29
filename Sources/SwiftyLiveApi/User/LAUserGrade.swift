// SwiftyLiveApi
// ↳ LAUserGrade.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Grade information for a single user.
public struct LAUserGrade: Decodable {
    public init(userId: String, virtualOrganization: String? = nil, username: String? = nil, roles: [Int], gradeTable: LAGradeTable, violationsByLevel: LAViolationCount, xp: Double, atcOperations: Int, atcRank: LAAtcRank, violationsLast12Months: Int, lastLevel1Violation: Date? = nil, lastLevel2Violation: Date? = nil, lastLevel3Violation: Date? = nil, lastReport: Date? = nil) {
        self.userId = userId
        self.virtualOrganization = virtualOrganization
        self.username = username
        self.roles = roles
        self.gradeTable = gradeTable
        self.violationsByLevel = violationsByLevel
        self.xp = xp
        self.atcOperations = atcOperations
        self.atcRank = atcRank
        self.violationsLast12Months = violationsLast12Months
        self.lastLevel1Violation = lastLevel1Violation
        self.lastLevel2Violation = lastLevel2Violation
        self.lastLevel3Violation = lastLevel3Violation
        self.lastReport = lastReport
    }
    
    /// Unique ID of the user.
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
    
    // Not in use for this endpoint.
    // public var errorCode: LAError
    
    /// Full grade table.
    public var gradeTable: LAGradeTable
    /// Violations received by user, split by level.
    public var violationsByLevel: LAViolationCount
    /// Total XP obtained in multiplayer.
    public var xp: Double
    /// Total amount of ATC operations.
    public var atcOperations: Int
    /// Expert server ATC rank, defaults to `.observer` if `null`.
    public var atcRank: LAAtcRank
    /// Total violations received in the last year.
    public var violationsLast12Months: Int
    /// Date of the last level 1 violation.
    public var lastLevel1Violation: Date?
    /// Date of the last level 1 violation.
    public var lastLevel2Violation: Date?
    /// Date of the last level 1 violation.
    public var lastLevel3Violation: Date?
    /// Date of the last level 2/3 violation.
    public var lastReport: Date?
    
    private enum CodingKeys: String, CodingKey {
        case userId, virtualOrganization
        case username = "discourseUsername"
        case roles
        case gradeTable = "gradeDetails"
        case violationsByLevel = "violationCountByLevel"
        case xp = "totalXP"
        case atcOperations, atcRank
        case violationsLast12Months = "total12MonthsViolations"
        case lastLevel1Violation = "lastLevel1ViolationDate"
        case lastLevel2Violation = "lastLevel2ViolationDate"
        case lastLevel3Violation = "lastLevel3ViolationDate"
        case lastReport = "lastReportViolationDate"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(String.self, forKey: .userId)
        virtualOrganization = try values.decode(String?.self, forKey: .virtualOrganization)
        username = try values.decode(String?.self, forKey: .username)
        roles = try values.decode([Int].self, forKey: .roles)
        gradeTable = try values.decode(LAGradeTable.self, forKey: .gradeTable)
        violationsByLevel = try values.decode(LAViolationCount.self, forKey: .violationsByLevel)
        xp = try values.decode(Double.self, forKey: .xp)
        atcOperations = try values.decode(Int.self, forKey: .atcOperations)
        atcRank = try values.decode(LAAtcRank.self, forKey: .atcRank)
        violationsLast12Months = try values.decode(Int.self, forKey: .violationsLast12Months)
        lastLevel1Violation = try? values.decode(LADate.self, forKey: .lastLevel1Violation).wrappedValue
        lastLevel2Violation = try? values.decode(LADate.self, forKey: .lastLevel2Violation).wrappedValue
        lastLevel3Violation = try? values.decode(LADate.self, forKey: .lastLevel3Violation).wrappedValue
        lastReport = try? values.decode(LADate.self, forKey: .lastReport).wrappedValue
    }
}
