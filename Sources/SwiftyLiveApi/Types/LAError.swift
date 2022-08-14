// SwiftyLiveApi
// ↳ LAError.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// An API error code.
public enum LAError: Int, Error {
    case ok = 0
    case userNotFound = 1
    case missingRequestParameters = 2
    case endpointError = 3
    case notAuthorized = 4
    case serverNotFound = 5
    case flightNotFound = 6
    case noAtisAvailable = 7
    /// An error code that is not present in the documentation, ideally should never appear.
    case undocumented = 404
}

extension LAError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ok:
            return "OK"
        case .userNotFound:
            return "User not found."
        case .missingRequestParameters:
            return "Missing request parameters."
        case .endpointError:
            return "Endpoint error."
        case .notAuthorized:
            return "Not authorized, check your API key."
        case .serverNotFound:
            return "Server not found."
        case .flightNotFound:
            return "Flight not found, perhaps it was ended."
        case .noAtisAvailable:
            return "ATIS is not active at this airport."
        case .undocumented:
            return "Unknown error."
        }
    }
}
