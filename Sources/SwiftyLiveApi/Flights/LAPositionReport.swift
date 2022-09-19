// SwiftyLiveApi
// ↳ LAPositionReport.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single position report.
public struct LAPositionReport: Decodable {
    public init(position: LACoordinate, track: Double, groundSpeed: Double, date: Date) {
        self.position = position
        self.track = track
        self.groundSpeed = groundSpeed
        self.date = date
    }
    
    /// Aircraft position at the time of the report.
    public var position: LACoordinate
    /// Aircraft track/course at the time of the report in degrees.
    public var track: Double
    /// Aircraft ground speed at the time of the report in knots.
    public var groundSpeed: Double
    /// Time of the report.
    public var date: Date
    
    private enum CodingKeys: CodingKey {
        case latitude, longitude, altitude, track, groundSpeed, date
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        position = LACoordinate(latitude: try values.decode(Double.self, forKey: .latitude),
                                longitude: try values.decode(Double.self, forKey: .longitude),
                                altitude: try values.decode(Double.self, forKey: .altitude))
        track = try values.decode(Double.self, forKey: .track)
        groundSpeed = try values.decode(Double.self, forKey: .groundSpeed)
        date = try values.decode(Date.self, forKey: .date)
    }
}
