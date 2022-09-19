// SwiftyLiveApi
// ↳ LANotam.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A NOTAM on a live server.
public struct LANotam: Decodable {
    public init(id: String, title: String, author: String, type: LANotamType, sessionId: String? = nil, radius: Int, message: String, latitude: Double, longitude: Double, icao: String, floor: Int, ceiling: Int, startTime: Date, endTime: Date) {
        self.id = id
        self.title = title
        self.author = author
        self.type = type
        self.sessionId = sessionId
        self.radius = radius
        self.message = message
        self.latitude = latitude
        self.longitude = longitude
        self.icao = icao
        self.floor = floor
        self.ceiling = ceiling
        self.startTime = startTime
        self.endTime = endTime
    }
    
    /// Unique ID of the NOTAM.
    public var id: String
    /// Short title of the NOTAM.
    public var title: String
    /// Author of the NOTAM.
    public var author: String
    /// NOTAM type.
    public var type: LANotamType
    /// Session for which the NOTAM is published. Applies to all if `null`.
    public var sessionId: String?
    /// NOTAM radius in NM.
    public var radius: Int
    /// Description of the NOTAM.
    public var message: String
    /// Latitude of the center of the NOTAM.
    public var latitude: Double
    /// Longitude of the center of the NOTAM.
    public var longitude: Double
    /// ICAO of the nearest airport.
    public var icao: String
    /// Lowest altitude of NOTAM in feet.
    public var floor: Int
    /// Highest altitude of NOTAM in feet
    public var ceiling: Int
    /// Time at which the NOTAM comes into effect.
    public var startTime: Date
    /// Time at which the NOTAM expires.
    public var endTime: Date
}
