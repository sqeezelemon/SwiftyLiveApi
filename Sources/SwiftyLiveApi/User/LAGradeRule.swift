// SwiftyLiveApi
// ↳ LAGradeRule.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Rule to be met to obtain grade.
public struct LAGradeRule: Decodable {
    public init(index: Int, requirement: Double, userValue: Double, state: LAGradeState, userValueString: String, requirementString: String, definition: LAGradeRuleDefinition) {
        self.index = index
        self.requirement = requirement
        self.userValue = userValue
        self.state = state
        self.userValueString = userValueString
        self.requirementString = requirementString
        self.definition = definition
    }
    
    /// Index of the rule in `LAGrade.rules` property.
    public var index: Int
    /// The required value for this rule.
    public var requirement: Double
    /// User's value for this property.
    public var userValue: Double
    /// User's state in regards to meeting the rule.
    public var state: LAGradeState
    /// The required value for this rule, nicely formatted.
    public var userValueString: String
    /// User's value for this property, nicely formatted.
    public var requirementString: String
    /// Definition for the rule.
    public var definition: LAGradeRuleDefinition
    
    private enum CodingKeys: String, CodingKey {
        case index = "ruleIndex"
        case requirement = "referenceValue"
        case userValue, state, userValueString
        case requirementString = "referenceValueString"
        case definition
    }
}
