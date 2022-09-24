// SwiftyLiveApi
// ↳ LAGradeState.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// User's state of obtaining a grade
public enum LAGradeState: Int {
    case fail = 0
    case ok = 1
    case warning = 2
    
    /// Undocumented facility type, please file a report on GitHub if encountered.
    case undocumented
}

extension LAGradeState: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue.self)
        self = .init(rawValue: value) ?? .undocumented
    }
}
