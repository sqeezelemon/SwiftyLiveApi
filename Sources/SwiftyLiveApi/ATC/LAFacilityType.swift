// SwiftyLiveApi
// ↳ LAFacilityType.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// ATC facility type.
public enum LAFacilityType: Int {
    case ground = 0
    case tower = 1
    case unicom = 2
    case clearance = 3
    case approach = 4
    case departure = 5
    case center = 6
    case atis = 7
    case aircraft = 8
    case recorded = 9
    case unknown = 10
    case unused = 11
    
    /// Undocumented facility type, please file a report on GitHub if encountered.
    case undocumented
}

extension LAFacilityType: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue.self)
        self = .init(rawValue: value) ?? .undocumented
    }
}
