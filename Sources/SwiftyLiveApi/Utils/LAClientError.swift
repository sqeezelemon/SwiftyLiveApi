// SwiftyLiveApi
// ↳ LAClientError.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

public enum LAClientError: Error {
    case dataIsNil
    case urlIsNil
    case dateIsNil
}

extension LAClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataIsNil:
            return "API Call didn't return any data."
        case .urlIsNil:
            return "Couldn't generate a URL for this request."
        case .dateIsNil:
            return "Couldn't parse Date."
        }
    }
}
