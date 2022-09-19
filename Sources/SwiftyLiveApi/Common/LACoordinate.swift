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
    public var latitude: Double
    public var longitude: Double
    /// Altitude in feet.
    public var altitude: Double
}
