// SwiftyLiveApi
// ↳ LAViolationCount.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Violation count by level.
public struct LAViolationCount: Decodable {
    public init(lvl1: Int, lvl2: Int, lvl3: Int) {
        self.lvl1 = lvl1
        self.lvl2 = lvl2
        self.lvl3 = lvl3
    }
    
    /// Amount of level 1 violations.
    public var lvl1: Int
    /// Amount of level 2 violations.
    public var lvl2: Int
    /// Amount of level 3 violations.
    public var lvl3: Int
    
    /// Subscript to support docs-style dictionary
    public subscript(_ index: String) -> Int? {
        get {
            switch index {
            case "level1":
                return lvl1
            case "level2":
                return lvl2
            case "level3":
                return lvl3
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else { return }
            switch index {
            case "level1":
                lvl1 = newValue
            case "level2":
                lvl2 = newValue
            case "level3":
                lvl3 = newValue
            default:
                break
            }
        }
    }
    
    public enum CodingLeys: String, CodingKey {
        case lvl1 = "level1"
        case lvl2 = "level2"
        case lvl3 = "level3"
    }
}
