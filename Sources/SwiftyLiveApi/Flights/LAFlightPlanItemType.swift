// SwiftyLiveApi
// ↳ LAFlightPlanItemType.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

public enum LAFlightPlanItemType: Int {
    case sid = 0
    case star = 1
    case approach = 2
    case track = 3
    case unknown = 5
    
    /// Undocumented flightplan item type, please file a report on GitHub if encountered.
    case undocumented
}

extension LAFlightPlanItemType: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue.self)
        self = .init(rawValue: value) ?? .undocumented
    }
}
