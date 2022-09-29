// SwiftyLiveApi
// ↳ LAGrade.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A grade and all its info.
public struct LAGrade: Decodable {
    public init(rules: [LAGradeRule], index: Int, name: String, state: LAGradeState) {
        self.rules = rules
        self.index = index
        self.name = name
        self.state = state
    }
    
    /// Rules to be met to obtain the grade.
    public var rules: [LAGradeRule]
    /// Index of this `LAGrade` in `LAGradeTable.grades`.
    public var index: Int
    /// Name of the grade.
    public var name: String
    /// User's status of obtaining the grade.
    public var state: LAGradeState
}
