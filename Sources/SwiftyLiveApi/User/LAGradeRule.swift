// SwiftyLiveApi
// ↳ LAGradeRule.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Rule to be met to obtain grade.
public struct LAGradeRule: Decodable {
    public init(index: Int, reference: Double, userValue: Double, state: LAGradeState, userValueString: String, referenceString: String, definition: LAGradeRuleDefinition) {
        self.index = index
        self.reference = reference
        self.userValue = userValue
        self.state = state
        self.userValueString = userValueString
        self.referenceString = referenceString
        self.definition = definition
    }
    
    /// Index of the rule in `LAGrade.rules` property.
    public var index: Int
    /// The required value for this rule.
    public var reference: Double
    /// User's value for this property.
    public var userValue: Double
    /// User's state in regards to meeting the rule.
    public var state: LAGradeState
    /// The required value for this rule, nicely formatted.
    public var userValueString: String
    /// User's value for this property, nicely formatted.
    public var referenceString: String
    /// Definition for the rule.
    public var definition: LAGradeRuleDefinition
    
    private enum CodingKeys: String, CodingKey {
        case index = "ruleIndex"
        case reference = "referenceValue"
        case userValue, state, userValueString
        case referenceString = "referenceValueString"
        case definition
    }
}
