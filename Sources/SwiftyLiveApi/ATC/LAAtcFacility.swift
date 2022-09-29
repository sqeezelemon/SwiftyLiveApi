// SwiftyLiveApi
// ↳ LAAtcFacility.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Metadata about an ATC facility.
public struct LAAtcFacility: Decodable {
    public init(id: String, icao: String? = nil, type: LAFacilityType, latitude: Double, longitude: Double) {
        self.id = id
        self.icao = icao
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Unique identifier for the facility.
    public var id: String
    /// ICAO code of the airport. `null` if center.
    public var icao: String?
    /// Facility type.
    public var type: LAFacilityType
    /// Latitude of the facility.
    public var latitude: Double
    /// Longitude of the facility.
    public var longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case icao = "airportIcao"
        case type = "frequencyType"
        case latitude, longitude
    }
}
