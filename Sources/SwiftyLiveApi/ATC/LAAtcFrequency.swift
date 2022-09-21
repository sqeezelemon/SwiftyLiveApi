// SwiftyLiveApi
// ↳ LAAtcFrequency.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// An active ATC frequency.
public struct LAAtcFrequency: Decodable {
    public init(facility: LAAtcFacility, userId: String, username: String? = nil, virtualOrganization: String? = nil, startTime: Date) {
        self.facility = facility
        self.userId = userId
        self.username = username
        self.virtualOrganization = virtualOrganization
        self.startTime = startTime
    }
    
    /// Information about the facility.
    public var facility: LAAtcFacility
    /// Unique identifier of the user controlling the frequency.
    public var userId: String
    /// User's forum username, `nil` if not linked or anonymous.
    public var username: String?
    /// User's forum VA/VO, `nil` if not linked, not set or anonymous.
    public var virtualOrganization: String?
    /// Time at which the frequency was opened.
    public var startTime: Date
    
    enum CodingKeys: String, CodingKey {
        case frequencyId, airportName, type, latitude, longitude
        case userId, username, virtualOrganization, startTime
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(String.self, forKey: .userId)
        username = try values.decode(String?.self, forKey: .username)
        virtualOrganization = try values.decode(String?.self, forKey: .virtualOrganization)
        startTime = try values.decode(Date.self, forKey: .startTime)
        
        facility = LAAtcFacility(id: try values.decode(String.self, forKey: .frequencyId),
                                 icao: try values.decode(String?.self, forKey: .frequencyId),
                                 type: try values.decode(LAFacilityType.self, forKey: .type),
                                 latitude: try values.decode(Double.self, forKey: .latitude),
                                 longitude: try values.decode(Double.self, forKey: .longitude))
    }
}
