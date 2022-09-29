// SwiftyLiveApi
// ↳ LAFlightPlan.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// An Infinite Flight flightplan.
public struct LAFlightPlan: Decodable {
    public init(flightPlanId: String, flightId: String, waypoints: [String], lastUpdate: Date, flightPlanItems: [LAFlightPlanItem]) {
        self.flightPlanId = flightPlanId
        self.flightId = flightId
        self.waypoints = waypoints
        self.lastUpdate = lastUpdate
        self.flightPlanItems = flightPlanItems
    }
    
    /// Unique identifier for the flight plan.
    public var flightPlanId: String
    /// Unique identifier for the flight.
    public var flightId: String
    /// Waypoint names for the flight. **Deprecated**
    public var waypoints: [String]
    /// Last time the flightplan was reported to the server.
    @LADate
    public var lastUpdate: Date
    /// Waypoints and procedures making up the flightplan.
    public var flightPlanItems: [LAFlightPlanItem]
}
