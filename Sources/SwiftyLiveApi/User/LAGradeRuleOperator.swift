// SwiftyLiveApi
// ↳ LAGradeRuleOperator.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

public enum LAGradeRuleOperator: Int {
    case greater = 0
    case lesser = 1
    case greaterOrEqual = 2
    case lesserOrEqual = 3
    case equal = 4
    case notEqual = 5
    
    /// Undocumented facility type, please file a report on GitHub if encountered.
    case undocumented
}

extension LAGradeRuleOperator: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue.self)
        self = .init(rawValue: value) ?? .undocumented
    }
}
