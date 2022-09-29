// SwiftyLiveApi
// ↳ LAGradeTable.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Full grade table for a user.
public struct LAGradeTable: Decodable {
    public init(grades: [LAGrade], gradeIndex: Int, ruleDefinitions: [LAGradeRuleDefinition]) {
        self.grades = grades
        self.gradeIndex = gradeIndex
        self.ruleDefinitions = ruleDefinitions
    }
    
    /// All grades.
    public var grades: [LAGrade]
    /// Index of the grade that user holds.
    public var gradeIndex: Int
    /// Definitions of rules required for each grade
    public var ruleDefinitions: [LAGradeRuleDefinition]
}
