// SwiftyLiveApi
// ↳ LAFlightPlanItem.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single waypoint or procedure.
public struct LAFlightPlanItem: Decodable {
    public init(name: String, type: LAFlightPlanItemType, children: [LAFlightPlanItem], identifier: String, altitude: Int, location: LACoordinate) {
        self.name = name
        self.type = type
        self.children = children
        self.identifier = identifier
        self.altitude = altitude
        self.location = location
    }
    
    /// Name of the waypoint or procedure.
    public var name: String
    /// Type of procedure.
    public var type: LAFlightPlanItemType
    /// Information about a procedure. If empty assume this is a waypoint.
    public var children: [LAFlightPlanItem]
    /// Identifier for the waypoint or procedure.
    public var identifier: String
    /// Altitude for the waypoint in feet. Defaults to `-1` if not set.
    public var altitude: Int
    /// Location of the waypoint. Ignore for procedures.
    public var location: LACoordinate
    
    private enum CodingKeys: String, CodingKey {
        case name, type, children, identifier, altitude, location
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decode(LAFlightPlanItemType.self, forKey: .type)
        children = (try? values.decode([LAFlightPlanItem].self, forKey: .name)) ?? []
        identifier = try values.decode(String.self, forKey: .identifier)
        altitude = try values.decode(Int.self, forKey: .altitude)
        location = try values.decode(LACoordinate.self, forKey: .location)
    }
}
