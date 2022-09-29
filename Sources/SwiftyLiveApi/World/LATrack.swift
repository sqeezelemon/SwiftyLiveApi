// SwiftyLiveApi
// ↳ LATrack.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single Infinite Flight track.
public struct LATrack: Decodable {
    public init(name: String, path: [String], eastLevels: [Int], westLevels: [Int], type: String, lastSeen: Date) {
        self.name = name
        self.path = path
        self.eastLevels = eastLevels
        self.westLevels = westLevels
        self.type = type
        self.lastSeen = lastSeen
    }
    
    /// Name of the track, usually a single letter.
    public var name: String
    /// Waypoints making up the track.
    public var path: [String]
    /// Array of flight levels for eastbound flights.
    public var eastLevels: [Int]
    /// Array of flight levels for westbound flights.
    public var westLevels: [Int]
    /// type of track, i.e. `"North Atlantic Tracks"`
    public var type: String
    /// last time the track was updated.
    @LADate
    public var lastSeen: Date
    
    private enum CodingKeys: CodingKey {
        case name, path, eastLevels, westLevels, type, lastSeen
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        path = try values.decode([String].self, forKey: .path)
        eastLevels = (try? values.decode([Int].self, forKey: .eastLevels)) ?? []
        westLevels = (try? values.decode([Int].self, forKey: .westLevels)) ?? []
        type = try values.decode(String.self, forKey: .type)
        _lastSeen = try values.decode(LADate.self, forKey: .lastSeen)
    }
}
