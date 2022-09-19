// SwiftyLiveApi
// ↳ LAFlight.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// An active flight on an Infinite Flight server.
public struct LAFlight: Decodable {
    public init(flightId: String, userId: String, aircraftId: String, liveryId: String, username: String? = nil, virtualOrganization: String? = nil, callsign: String, position: LACoordinate, speed: Double, verticalSpeed: Double, track: Double, heading: Float, lastReport: Date) {
        self.flightId = flightId
        self.userId = userId
        self.aircraftId = aircraftId
        self.liveryId = liveryId
        self.username = username
        self.virtualOrganization = virtualOrganization
        self.callsign = callsign
        self.position = position
        self.speed = speed
        self.verticalSpeed = verticalSpeed
        self.track = track
        self.heading = heading
        self.lastReport = lastReport
    }
    
    /// Unique identifier for the flight.
    public var flightId: String
    /// Unique identifier for the user.
    public var userId: String
    /// Unique identifier for the aircraft type.
    public var aircraftId: String
    /// Unique identifier for the aircraft and livery combination.
    public var liveryId: String
    /// User's forum username, `nil` if not linked or anonymous.
    public var username: String?
    /// User's forum VA/VO, `nil` if not linked, not set or anonymous.
    public var virtualOrganization: String?
    /// Callsign for the flight.
    public var callsign: String
    /// Current position of the aircraft
    public var position: LACoordinate
    /// Current ground speed of the aircraft in knots.
    public var speed: Double
    /// Current vertical speed of the aircraft in ft/min.
    public var verticalSpeed: Double
    /// Current track of the aircraft in degrees.
    public var track: Double
    /// Current heading of the aircraft in degrees.
    public var heading: Float
    /// Last position report time.
    public var lastReport: Date
    
    private enum CodingKeys: CodingKey {
        case flightId, userId, aircraftId, liveryId, username, virtualOrganization, callsign, latitude, longitude, altitude, speed, verticalSpeed, track, heading, lastReport
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flightId = try values.decode(String.self, forKey: .flightId)
        userId = try values.decode(String.self, forKey: .userId)
        aircraftId = try values.decode(String.self, forKey: .aircraftId)
        liveryId = try values.decode(String.self, forKey: .liveryId)
        username = try values.decode(String?.self, forKey: .username)
        virtualOrganization = try values.decode(String?.self, forKey: .flightId)
        callsign = try values.decode(String.self, forKey: .callsign)
        position = LACoordinate(latitude: try values.decode(Double.self, forKey: .latitude),
                                longitude: try values.decode(Double.self, forKey: .longitude),
                                altitude: try values.decode(Double.self, forKey: .altitude))
        speed = try values.decode(Double.self, forKey: .speed)
        verticalSpeed = try values.decode(Double.self, forKey: .verticalSpeed)
        track = try values.decode(Double.self, forKey: .track)
        heading = try values.decode(Float.self, forKey: .heading)
        lastReport = try values.decode(Date.self, forKey: .lastReport)
    }
}
