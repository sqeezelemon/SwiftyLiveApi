// SwiftyLiveApi
// ↳ LACoordinate.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single coordinate.
public struct LACoordinate: Decodable {
    public init(latitude: Double, longitude: Double, altitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    /// Latitude of the object.
    public var latitude: Double
    /// Longitude of the object.
    public var longitude: Double
    /// Altitude in feet.
    public var altitude: Double
}
