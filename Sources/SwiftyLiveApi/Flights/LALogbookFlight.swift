// SwiftyLiveApi
// ↳ LALogbookFlight.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A logged flight.
public struct LALogbookFlight: Decodable {
    public init(flightId: String, created: Date, userId: String, aircraftId: String, liveryId: String? = nil, callsign: String, server: String, dayTime: Float, nightTime: Float, totalTime: Float, landingCount: Int, origin: String, destination: String, xp: Int) {
        self.flightId = flightId
        self.created = created
        self.userId = userId
        self.aircraftId = aircraftId
        self.liveryId = liveryId
        self.callsign = callsign
        self.server = server
        self.dayTime = dayTime
        self.nightTime = nightTime
        self.totalTime = totalTime
        self.landingCount = landingCount
        self.origin = origin
        self.destination = destination
        self.xp = xp
    }
    
    /// Unique id of the flight.
    public var flightId: String
    /// Time the flight was created.
    @LADate
    public var created: Date
    /// Unique ID of the user who flew the flight.
    public var userId: String
    /// Unique ID of the aircraft with which the flight was flown.
    public var aircraftId: String
    /// Unique ID of the livery and aircraft combination with which the flight was flown. Only available on Casual for now.
    public var liveryId: String?
    /// Callsign during the flight.
    public var callsign: String
    /// Name of the server the flight was flown on.
    public var server: String
    /// Flight time during the day, in minutes.
    public var dayTime: Float
    /// Flight time during the night, in minutes.
    public var nightTime: Float
    /// Total flight time, in minutes.
    public var totalTime: Float
    /// Number of landings conducted during the flight.
    public var landingCount: Int
    /// ICAO of the origin airport.
    public var origin: String
    /// ICAO of the destination airport.
    public var destination: String
    /// XP earned during the flight.
    public var xp: Int
    
    private enum CodingKeys: String, CodingKey {
        case flightId = "id"
        case created, userId, aircraftId, liveryId, callsign, server, dayTime, nightTime, totalTime, landingCount
        case origin = "originAirport"
        case destination = "destinationAirport"
        case xp
    }
}
