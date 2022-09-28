// SwiftyLiveApi
// ↳ LAAirportStatus.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

public struct LAAirportStatus: Decodable {
    public init(icao: String, inboundsCount: Int, inbounds: [String], outboundsCount: Int, outbounds: [String], activeAtc: [LAAtcFrequency]) {
        self.icao = icao
        self.inboundsCount = inboundsCount
        self.inbounds = inbounds
        self.outboundsCount = outboundsCount
        self.outbounds = outbounds
        self.activeAtc = activeAtc
    }
    
    /// ICAO code of the airport.
    public var icao: String
    /// Number of flights inbound to this airport (Must have this airport as the final waypoint).
    public var inboundsCount: Int
    /// Unique identifiers of the flights inbound to this airport (Must have this airport as the final waypoint).
    public var inbounds: [String]
    /// Number of flights departing this airport (Must have this airport as the first waypoint).
    public var outboundsCount: Int
    /// Unique identifiers of the flights departing this airport (Must have this airport as the first waypoint).
    public var outbounds: [String]
    /// Active ATC facilities at the airport.
    public var activeAtc: [LAAtcFrequency]
    
    private enum CodingKeys: String, CodingKey {
        case icao = "airportIcao"
        case inboundsCount = "inboundFlightsCount"
        case inbounds = "inboundFlights"
        case outboundsCount = "outboundFlightsCount"
        case outbounds = "outboundFlights"
        case activeAtc = "atcFacilities"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        icao = try values.decode(String.self, forKey: .icao)
        inbounds = try values.decode([String].self, forKey: .inbounds)
        inboundsCount = try values.decode(Int.self, forKey: .inboundsCount)
        outbounds = try values.decode([String].self, forKey: .outbounds)
        outboundsCount = try values.decode(Int.self, forKey: .outboundsCount)
        activeAtc = try values.decode([LAAtcFrequency].self, forKey: .activeAtc)
    }
}
