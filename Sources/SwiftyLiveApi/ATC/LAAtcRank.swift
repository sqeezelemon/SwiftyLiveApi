// SwiftyLiveApi
// ↳ LAAtcRank.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// User ATC rank, defaults to `.observer` if `null`.
public enum LAAtcRank: Int {
    case observer = 0
    case trainee = 1
    case apprentice = 2
    case specialist = 3
    case officer = 4
    case supervisor = 5
    case recruiter = 6
    case manager = 7
    
    /// Undocumented facility type, please file a report on GitHub if encountered.
    case undocumented
}

extension LAAtcRank: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue?.self)
        self = .init(rawValue: value ?? LAAtcRank.observer.rawValue) ?? .undocumented
    }
}
