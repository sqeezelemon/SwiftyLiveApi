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
    
    public var facility: LAAtcFacility
    public var userId: String
    public var username: String?
    public var virtualOrganization: String?
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
        
        facility = LAAtcFacility(id: "", icao: nil, type: .undocumented, latitude: 0, longitude: 0)
        facility.id = try values.decode(String.self, forKey: .frequencyId)
        facility.icao = try values.decode(String?.self, forKey: .frequencyId)
        facility.type = try values.decode(LAFacilityType.self, forKey: .type)
        facility.latitude = try values.decode(Double.self, forKey: .latitude)
        facility.longitude = try values.decode(Double.self, forKey: .longitude)
    }
}
