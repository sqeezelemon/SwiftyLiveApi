// SwiftyLiveApi
// ↳ LASessionType.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

public enum LASessionType: Int {
    case unrestricted = 0
    case restricted = 1
    
    /// Undocumented Session type, please file a report on GitHub if encountered.
    case undocumented
}

extension LASessionType: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue.self)
        self = .init(rawValue: value) ?? .undocumented
    }
}
