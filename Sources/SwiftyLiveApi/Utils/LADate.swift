// SwiftyLiveApi
// ↳ LADate.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Wrapper for all Live APi date types.
@propertyWrapper
public struct LADate: Decodable {
    private static var withMilliseconds: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSSSSXXX"
        return formatter
    }
    
    private static var withoutMilliseconds: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ssXXX"
        return formatter
    }

    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let strValue = try decoder.singleValueContainer().decode(String.self)
            .replacingOccurrences(of: " ", with: "T")
        if let date = LADate.withMilliseconds.date(from: strValue) {
            wrappedValue = date
        } else if let date = LADate.withoutMilliseconds.date(from: strValue) {
            wrappedValue = date
        } else {
            throw LAClientError.dateIsNil
        }
    }
}
