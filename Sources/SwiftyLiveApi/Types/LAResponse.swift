// SwiftyLiveApi
// ↳ LAResponse.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Wrapper for all API responses.
internal struct LAResponse<T: Decodable>: Decodable {
    /// API error code.
    var errorCode: Int
    /// Response data
    var result: T
    
    enum CodingKeys: CodingKey {
        case errorCode, result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorCode  = try values.decode(Int.self, forKey: .errorCode)
        
        guard errorCode == 0 else {
            let apiError = LAError(rawValue: errorCode) ?? .undocumented
            throw apiError
        }
        
        result = try values.decode(T.self, forKey: .result)
    }
}
