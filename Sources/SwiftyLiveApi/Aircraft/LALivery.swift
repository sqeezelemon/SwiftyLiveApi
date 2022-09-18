// SwiftyLiveApi
// ↳ LALivery.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single Infinite Flight livery.
public struct LALivery: Decodable {
    public init(id: String, aircraft: LAAircraft, name: String) {
        self.id = id
        self.aircraft = aircraft
        self.name = name
    }
    
    /// UUID of the livery.
    public var id: String
    /// Aircraft the livery is on.
    public var aircraft: LAAircraft
    /// Name of the livery. Can differ between aircraft.
    public var name: String
    
    internal enum CodingKeys: CodingKey {
        case id
        case aircraftID
        case aircraftName
        case liveryName
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.aircraft = LAAircraft(id: "", name: "")
        self.aircraft.id = try container.decode(String.self, forKey: .aircraftID)
        self.aircraft.name = try container.decode(String.self, forKey: .aircraftName)
        self.name = try container.decode(String.self, forKey: .liveryName)
    }
}
