// SwiftyLiveApi
// ↳ LAAircraft.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A single Infinite Flight aircraft.
public struct LAAircraft: Decodable {
  public init(id: String, name: String) {
    self.id = id
    self.name = name
  }
  
  /// Unique ID of the aircraft.
  public var id: String
  /// Aircraft model name.
  public var name: String
}
