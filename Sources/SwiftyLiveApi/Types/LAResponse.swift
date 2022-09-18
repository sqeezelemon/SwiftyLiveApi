// SwiftyLiveApi
// ↳ LAResponse.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Wrapper for all API responses.
internal struct LAResponse<T: Decodable>: Decodable {
    /// API error code.
    var errorCode: LAError
    /// Response data.
    var result: T
    
    private enum CodingKeys: CodingKey {
        case errorCode, result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorCode  = try values.decode(LAError.self, forKey: .errorCode)
        guard errorCode == .ok else { throw errorCode }
        result = try values.decode(T.self, forKey: .result)
    }
}
