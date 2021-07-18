//
//  LiveApiJsonTypes.swift
//  PrivateTracker
//
//  Created by Александр Никитин on 28.05.2021.
//

import Foundation

internal struct LiveApiResponseWrapper<T: Codable>: Codable {
    public var errorCode: Int
    public var result: T
}

//MARK: Get Sessions
public struct Session: Codable {
    public init(maxUsers: Int, id: String, name: String, userCount: Int, type: Int) {
        self.maxUsers = maxUsers
        self.id = id
        self.name = name
        self.userCount = userCount
        self.type = type
    }
    
    public var maxUsers: Int
    public var id: String
    public var name: String
    public var userCount: Int
    public var type: Int // Restricted = 1, unrestricted = 0
}

//MARK: Get Flights
public struct Flight: Codable {
    public init(username: String? = nil, callsign: String, latitude: Float, longitude: Float, altitude: Float, speed: Float, verticalSpeed: Float, track: Float, lastReport: String, flightId: String, userId: String, aircraftId: String, liveryId: String, heading: Float, virtualOrganization: String? = nil) {
        self.username = username
        self.callsign = callsign
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speed = speed
        self.verticalSpeed = verticalSpeed
        self.track = track
        self.lastReport = lastReport
        self.flightId = flightId
        self.userId = userId
        self.aircraftId = aircraftId
        self.liveryId = liveryId
        self.heading = heading
        self.virtualOrganization = virtualOrganization
    }
    
    public var username: String?
    public var callsign: String
    public var latitude: Float
    public var longitude: Float
    public var altitude: Float
    public var speed: Float
    public var verticalSpeed: Float
    public var track: Float
    public var lastReport: String
    
    public var flightId: String
    public var userId: String
    public var aircraftId: String
    public var liveryId: String
    
    public var heading: Float
    public var virtualOrganization: String?
}


//MARK: Get Flight Route
public struct PositionReport: Codable {
    public init(latitude: Float, longitude: Float, altitude: Float, track: Float, groundSpeed: Float, date: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.track = track
        self.groundSpeed = groundSpeed
        self.date = date
    }
    
    public var latitude: Float
    public var longitude: Float
    public var altitude: Float
    public var track: Float
    public var groundSpeed: Float
    public var date: String
    
    public var wrappedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: date)
    }
}

//MARK: Get Detailed Flight Plan
public struct FlightPlan: Codable {
    public init(flightPlanId: String, flightId: String, waypoints: [String], lastUpdate: String, flightPlanItems: [FlightPlan.FlightPlanItem]) {
        self.flightPlanId = flightPlanId
        self.flightId = flightId
        self.waypoints = waypoints
        self.lastUpdate = lastUpdate
        self.flightPlanItems = flightPlanItems
    }
    
    public var flightPlanId: String
    public var flightId: String
    public var waypoints: [String]
    public var lastUpdate: String
    
    public var flightPlanItems: [FlightPlanItem]
    
    public struct FlightPlanItem: Codable {
        public init(name: String, type: Int, children: [FlightPlan.FlightPlanItem]? = nil, identifier: String? = nil, altitude: Int, location: FlightPlan.Coordinate) {
            self.name = name
            self.type = type
            self.children = children
            self.identifier = identifier
            self.altitude = altitude
            self.location = location
        }
        
        var name: String
        var type: Int
        var children: [FlightPlanItem]?
        var identifier: String?
        var altitude: Int
        var location: FlightPlan.Coordinate
    }
    
    public struct Coordinate: Codable {
        public init(latitude: Float, longitude: Float) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        var latitude: Float
        var longitude: Float
    }
}

public extension FlightPlan {
    var wrappedLastUpdate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return formatter.date(from: lastUpdate)
    }
}

public extension FlightPlan.FlightPlanItem {
    enum FlightPlanItemType: Int {
        case sid = 0
        case star = 1
        case approach = 2
        case track = 3
        case unknown = 5
    }
    
    var typeEnum: FlightPlanItemType {
        return FlightPlanItemType.init(rawValue: type) ?? .unknown
    }
}

//MARK: Get Active ATC Frequencies

public struct ActiveAtcFacility: Codable {
    public init(frequencyId: String, userId: String, username: String? = nil, virtualOrganization: String? = nil, airportName: String? = nil, type: Int, latitude: Float, longitude: Float, startTime: String) {
        self.frequencyId = frequencyId
        self.userId = userId
        self.username = username
        self.virtualOrganization = virtualOrganization
        self.airportName = airportName
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.startTime = startTime
    }
    
    public var frequencyId: String
    public var userId: String
    public var username: String?
    public var virtualOrganization: String?
    public var airportName: String? // Optional because we live in a society where centers exist
    public var type: Int
    public var latitude: Float
    public var longitude: Float
    public var startTime: String
}

public extension ActiveAtcFacility {
    var wrappedStartTime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return formatter.date(from: startTime)
    }
    
    enum ActiveAtcFacilityType: Int {
        case ground = 0
        case tower = 1
        case unicom = 2
        case clearance = 3
        case approach = 4
        case departure = 5
        case center = 6
        case atis = 7
        case aircraft = 8
        case recorded = 9
        case unknown = 10
        case unused = 11
    }
    
    var enumType: ActiveAtcFacilityType {
        return ActiveAtcFacilityType.init(rawValue: type) ?? .unknown
    }
}

//MARK: Get User Stats

public struct UserStats: Codable {
    public init(onlineFlights: Int, violations: Int, xp: Int, landingCount: Int, flightTime: Int, atcOperations: Int, atcRank: Int? = nil, grade: Int, hash: String, violationCountByLevel: [String : Int], roles: [Int], userId: String, virtualOrganization: String? = nil, discourseUsername: String? = nil, groups: [String], errorCode: Int) {
        self.onlineFlights = onlineFlights
        self.violations = violations
        self.xp = xp
        self.landingCount = landingCount
        self.flightTime = flightTime
        self.atcOperations = atcOperations
        self.atcRank = atcRank
        self.grade = grade
        self.hash = hash
        self.violationCountByLevel = violationCountByLevel
        self.roles = roles
        self.userId = userId
        self.virtualOrganization = virtualOrganization
        self.discourseUsername = discourseUsername
        self.groups = groups
        self.errorCode = errorCode
    }
    
    public var onlineFlights: Int
    public var violations: Int
    public var xp: Int
    public var landingCount: Int
    public var flightTime: Int
    public var atcOperations: Int
    public var atcRank: Int?
    public var grade: Int
    public var hash: String
    public var violationCountByLevel: [String : Int]
    public var roles: [Int]
    
    public var userId: String
    public var virtualOrganization: String?
    public var discourseUsername: String?
    public var groups: [String]
    public var errorCode: Int
}

public extension UserStats {
    var enumRoles: [UserRole] {
        var result = [UserRole]()
        for role in roles {
            if let enumRole = UserRole.init(rawValue: role) {
                result.append(enumRole)
            }
        }
        return result
    }
    
    var enumAtcRank: AtcRank {
        return AtcRank.init(rawValue: atcRank ?? 0) ?? .observer
    }
}

//MARK: Get User Grade

public struct GradeInfo: Codable {
    public init(total12MonthsViolations: Int, gradeDetails: GradeInfo.GradeConfiguration, totalXP: Int, atcOperations: Int, atcRank: Int? = nil, lastLevel1ViolationDate: String, lastReportViolationDate: String, violationCountByLevel: [String : Int], roles: [String], userId: String, virtualOrganization: String? = nil, discourseUsername: String? = nil, errorCode: Int) {
        self.total12MonthsViolations = total12MonthsViolations
        self.gradeDetails = gradeDetails
        self.totalXP = totalXP
        self.atcOperations = atcOperations
        self.atcRank = atcRank
        self.lastLevel1ViolationDate = lastLevel1ViolationDate
        self.lastReportViolationDate = lastReportViolationDate
        self.violationCountByLevel = violationCountByLevel
        self.roles = roles
        self.userId = userId
        self.virtualOrganization = virtualOrganization
        self.discourseUsername = discourseUsername
        self.errorCode = errorCode
    }
    
    public var total12MonthsViolations: Int
    public var gradeDetails: GradeConfiguration
    public var totalXP: Int
    public var atcOperations: Int
    public var atcRank: Int?
    public var lastLevel1ViolationDate: String
    public var lastReportViolationDate: String
    public var violationCountByLevel: [ String : Int ]
    public var roles: [String]
    
    public var userId: String
    public var virtualOrganization: String?
    public var discourseUsername: String?
    //var groups: []
    public var errorCode: Int
    
    
    public struct GradeConfiguration: Codable {
        public init(gradeIndex: Int, grades: [GradeInfo.GradeConfiguration.Grade], ruleDefinitions: [GradeInfo.GradeConfiguration.GradeRuleDefinition]) {
            self.gradeIndex = gradeIndex
            self.grades = grades
            self.ruleDefinitions = ruleDefinitions
        }
        
        public var gradeIndex: Int
        public var grades: [Grade]
        public var ruleDefinitions: [GradeRuleDefinition]
        
        public struct Grade: Codable {
            public init(rules: [GradeInfo.GradeConfiguration.Grade.GradeRule], index: Int, name: String, state: Int) {
                self.rules = rules
                self.index = index
                self.name = name
                self.state = state
            }
            
            public var rules: [GradeRule]
            public var index: Int
            public var name: String
            public var state: Int
            
            public struct GradeRule: Codable {
                public init(ruleIndex: Int, referenceValue: Double, userValue: Double, state: Int, userValueString: String, referenceValueString: String, definition: GradeInfo.GradeConfiguration.GradeRuleDefinition) {
                    self.ruleIndex = ruleIndex
                    self.referenceValue = referenceValue
                    self.userValue = userValue
                    self.state = state
                    self.userValueString = userValueString
                    self.referenceValueString = referenceValueString
                    self.definition = definition
                }
                
                public var ruleIndex: Int
                public var referenceValue: Double
                public var userValue: Double
                public var state: Int
                public var userValueString: String
                public var referenceValueString: String
                public var definition: GradeRuleDefinition
            }
        }
        
        public struct GradeRuleDefinition: Codable {
            public init(name: String, description: String, property: String, `operator`: Int, period: Double, order: Int, group: Int) {
                self.name = name
                self.description = description
                self.property = property
                self.`operator` = `operator`
                self.period = period
                self.order = order
                self.group = group
            }
            
            public var name: String
            public var description: String
            public var property: String
            /// Be careful with this name, ```operator``` is a reserved word in swift. In case of any issues with it, surround it with one backtick on either sides..
            public var `operator`: Int
            public var period: Double
            public var order: Int
            public var group: Int
        }
    }
}

public extension GradeInfo.GradeConfiguration.Grade {
    var enumState: GradeState {
        return GradeState.init(rawValue: state) ?? .fail
    }
}

public extension GradeInfo.GradeConfiguration.Grade.GradeRule {
    var enumState: GradeState {
        return GradeState.init(rawValue: state) ?? .fail
    }
}

public extension GradeInfo.GradeConfiguration.GradeRuleDefinition {
    enum GradeRuleOperator: Int {
        case greaterThan = 0
        case lesserThan = 1
        case greaterThanOrEqual = 2
        case lesserThanOrEqual = 3
        case equal = 4
        case differentThan = 5
    }
    
    var enumOperator: GradeRuleOperator {
        return GradeRuleOperator.init(rawValue: self.operator) ?? .equal
    }
}

public extension GradeInfo {
    var enumAtcRank: AtcRank {
        return AtcRank.init(rawValue: atcRank ?? 0) ?? .observer
    }
}

//MARK: Get Airport ATIS
// Just do a
// LiveApiResponseWrapper<String>

//MARK: Get Airport Status
public struct AirportStatus: Codable {
    public init(airportIcao: String, inboundFlightsCount: Int, inboundFlights: [String], outboundFlightsCount: Int, outboundFlights: [String], atcFacilities: [ActiveAtcFacility]) {
        self.airportIcao = airportIcao
        self.inboundFlightsCount = inboundFlightsCount
        self.inboundFlights = inboundFlights
        self.outboundFlightsCount = outboundFlightsCount
        self.outboundFlights = outboundFlights
        self.atcFacilities = atcFacilities
    }
    
    public var airportIcao: String
    public var inboundFlightsCount: Int
    public var inboundFlights: [String]
    
    public var outboundFlightsCount: Int
    public var outboundFlights: [String]
    
    public var atcFacilities: [ActiveAtcFacility]
}

//MARK: Get World Status
// Just do a
// LveApiResponseWrapper<[AirportStatus]>

//MARK: Get Oceanic Tracks
public struct OceanicTrack: Codable {
    public init(name: String, path: [String], eastLevels: [Int]? = nil, westLevels: [Int]? = nil, type: String, lastSeen: String) {
        self.name = name
        self.path = path
        self.eastLevels = eastLevels
        self.westLevels = westLevels
        self.type = type
        self.lastSeen = lastSeen
    }
    
    public var name: String
    public var path: [String]
    public var eastLevels: [Int]?
    public var westLevels: [Int]?
    public var type: String
    public var lastSeen: String
}

public extension OceanicTrack {
    var wrappedLastSeen: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: lastSeen)
    }
}

//MARK: Enums for extensions

public enum UserRole: Int {
    case infiniteFlightStaff = 1
    case moderator = 2
    case ifatc = 64
}

public enum AtcRank: Int {
    case observer = 0
    case trainee = 1
    case apprentice = 2
    case specialist = 3
    case officer = 4
    case supervisor = 5
    case recruiter = 6
    case manager = 7
}

public enum GradeState: Int {
    case fail = 0
    case ok = 1
    case warning = 2
}

//MARK: Error Code types

public enum LiveApiError: Int, Error {
    case ok = 0
    case userNotFound = 1
    case missingRequestParameters = 2
    case endpointError = 3
    case notAuthorized = 4
    case serverNotFound = 5
    case flightNotFound = 6
    case noAtisAvailable = 7
    
    // Error just in case
    case unknownErrorCode = 404
}

extension LiveApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ok:
            return "ERROR CODE 0: Ok"
        case .userNotFound:
            return "ERROR CODE 1: User Not Found"
        case .missingRequestParameters:
            return "ERROR CODE 2: Missing Request Parameters"
        case .endpointError:
            return "ERROR CODE 3: Endpoint Error"
        case .notAuthorized:
            return "ERROR CODE 4: Not Authorized"
        case .serverNotFound:
            return "ERROR CODE 5: Server Not Found"
        case .flightNotFound:
            return "ERROR CODE 6: Flight Not Found"
        case .noAtisAvailable:
            return "ERROR CODE 7: No Atis Available"
        case .unknownErrorCode:
            return "Unknown LiveAPI Error Code"
        }
    }
}
