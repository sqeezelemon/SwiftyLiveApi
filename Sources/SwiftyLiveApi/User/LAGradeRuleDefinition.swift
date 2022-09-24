// SwiftyLiveApi
// ↳ LAGradeRuleDefinition.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Definition of a `GradeRule`.
public struct LAGradeRuleDefinition: Decodable {
    public init(name: String, description: String, property: String, `operator`: LAGradeRuleOperator, period: Double, order: Int) {
        self.name = name
        self.description = description
        self.property = property
        self.operator = `operator`
        self.period = period
        self.order = order
    }
    
    /// Name of the rule.
    public var name: String
    /// Description of the rule.
    public var description: String
    /// The property of `GradeInfo`object  this relates to.
    public var property: String
    /// Operator used for comparing user's value to reference.
    public var `operator`: LAGradeRuleOperator
    /// Time period in which the rule should be met
    public var period: Double
    /// Order of the rule within `LAGrade.rules`
    public var order: Int
    
    // Not in use for this endpoint
    // public var group: Int
}
