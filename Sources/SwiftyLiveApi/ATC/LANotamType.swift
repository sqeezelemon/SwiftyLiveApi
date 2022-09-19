// SwiftyLiveApi
// ↳ LANotamType.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

public enum LANotamType: Int {
    case notam = 0
    case tfr = 1
    
    /// Undocumented NOTAM type, please file a report on GitHub if encountered.
    case undocumented
}

extension LANotamType: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(RawValue.self)
        self = .init(rawValue: value) ?? .undocumented
    }
}
