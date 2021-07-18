//
//  LiveApi.swift
//  PrivateTracker
//
//  Created by Александр Никитин on 28.05.2021.
//

import Foundation

// Networking may not work on Linux without this
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
public class LiveApiClient {
    
    public var apiKey: String
    private let baseUrl = "https://api.infiniteflight.com"
    
    /**
     Initiates a LiveApiClient object with the supplied Live Api Key
     - Parameters:
       - apiKey: Your api key.
       - requestLimitPerMinute: Maximum amount of requests per minute after which further requests will be blocked until the end of the minute. Go above 100 at your own risk.
     */
    public init(_ apiKey: String, requestLimitPerMinute: Int = 100) {
        self.apiKey = apiKey
        self.requestLimitPerMinute = requestLimitPerMinute
        self.requestsThisMinuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            self.requestsThisMinute = 0
        })
    }
    
    //MARK: Request limiter
    /**
     Amount of requests per minute after which no further requests would be sent until a minute passes since last counter reset.
     - Warning: 100 requests per minute is the limit above which Cameron might ask you a few questions.
     */
    public var requestLimitPerMinute: Int
    
    // Counting the amount of requests
    private var requestsThisMinute: Int = 0
    private var requestsThisMinuteTimer: Timer?
    public func restartRequestLimiterTimer() {
        self.requestsThisMinuteTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            self.requestsThisMinute = 0
        })
    }
    
    //MARK: Main method for requests
    // idk if having JSONDecoder initialized here really does something for efficiency but I'd guess initiating the same thing tens of times per minute is not efficient
    private var jsonDecoder = JSONDecoder()
    private func getJsonData<T: Codable>(_ path: String) throws -> T {
        requestsThisMinute += 1
        guard requestsThisMinute <= requestLimitPerMinute else {
            throw LiveApiClientError.requestLimitReached
        }
        guard let requestUrl = URL(string: "\(baseUrl)\(path)?apikey=\(apiKey)") else {
            print("getJsonData: \(baseUrl)\(path)?apikey=\(apiKey) isn't a valid URL")
            throw LiveApiClientError.invalidUrl
        }
        let data = try Data(contentsOf: requestUrl)
        
        var jsonData: LiveApiResponseWrapper<T>!
        do {
            jsonData = try jsonDecoder.decode(LiveApiResponseWrapper<T>.self, from: data)
        } catch {
            if let codeFetcher = try? jsonDecoder.decode(LiveApiErrorCodeFetcher.self, from: data) {
                let liveApiError = LiveApiError.init(rawValue: codeFetcher.errorCode) ?? .unknownErrorCode
                throw liveApiError
            } else {
                throw error
            }
        }
        guard jsonData.errorCode == 0 else {
            throw LiveApiError.init(rawValue: jsonData.errorCode) ?? LiveApiError.unknownErrorCode
        }
        return jsonData.result
    }
    
    
    //MARK: Sessions
    
    /**
     Returns all public Infinite Flight Servers
     - Returns: Returns an array of Session objects or an empty array if something went wrong.
     */
    public func getSessions() throws -> [Session] {
        let data: [Session] = try getJsonData(RequestPath.sessions)
        updateSessionIds(sessions: data)
        return data
    }
    
    /**
     Refresh server ids inside ServerId enum
     */
    @available(*, deprecated, message: "getSessions now does that automatically when called. If needed, just call getSessions() and ignore the returned data")
    public func refreshSessionIds() {
        let sessions: [Session] = (try? getSessions()) ?? []
        print("refreshSessionIds: got \(sessions.count) sessions")
        for session in sessions {
            let name = session.name.lowercased()
            if name.contains("expert") {
                LiveServer.expertId = session.id
                print("refreshSessionIds: set id \(session.id) for \(session.name)")
            } else if name.contains("training") {
                LiveServer.trainingId = session.id
                print("refreshSessionIds: set id \(session.id) for \(session.name)")
            } else if name.contains("casual") {
                LiveServer.casualId = session.id
                print("refreshSessionIds: set id \(session.id) for \(session.name)")
            }
        }
    }
    
    /**
     Updates session ids inside LiveServer enum
     - Parameter sessions: array of ```Session``` objects
     */
    public func updateSessionIds(sessions: [Session]) {
        for session in sessions {
            let name = session.name.lowercased()
            if name.contains("expert") {
                LiveServer.expertId = session.id
                print("refreshSessionIds: set id \(session.id) for \(session.name)")
            } else if name.contains("training") {
                LiveServer.trainingId = session.id
                print("refreshSessionIds: set id \(session.id) for \(session.name)")
            } else if name.contains("casual") {
                LiveServer.casualId = session.id
                print("refreshSessionIds: set id \(session.id) for \(session.name)")
            }
        }
    }
    
    //MARK: Get Flights
    /**
     Retrieve a list of all flights for a session.
     - Parameter sessionId: Session (Server) ID of the Live Server.
     - Returns: Returns an array of Flight objects or an empty array if something went wrong.
     */
    public func getFlights(_ sessionId: String) throws -> [Flight] {
        let data: [Flight] = try getJsonData(RequestPath.flights(sessionId))
        return data
    }
    
    //MARK: Get Flight Route
    /**
     Retrieve the flown route of a specific flight with position, altitude, speed and track information at different points in time.
     - Warning: Please note, this is currently only supported on the Expert Server and Training Server.
     - Parameter flightId: ID of the flight. The flight must be in an active session.
     - Returns: Returns an array of PositionReport objects or an empty array if something went wrong.
     */
    public func getFlightRoute(_ flightId: String) throws -> [PositionReport] {
        let data: [PositionReport] = try getJsonData(RequestPath.flightRoute(flightId))
        return data
    }
    
    //MARK: Get Detailed Flight Plan
    /**
     Retrieve the flight plan for a specific active flight.
     - Parameter flightId: ID of the flight. The flight must be in an active session.
     - Returns: Returns an optional FlightPlan object or nil if something went wrong.
     */
    public func getFlightPlan(_ flightId: String) throws -> FlightPlan {
        let data: FlightPlan = try getJsonData(RequestPath.flightPlan(flightId))
        return data
    }
    
    //MARK: Get Active ATC Frequencies
    /**
     Retrieve active Air Traffic Control frequencies for a session.
     - Parameter sessionId: Session (Server) ID of the Live Server.
     - Returns: Returns an array of ActiveAtcFacility objects or an empty array if something went wrong.
     */
    public func getActiveAtc(_ sessionId: String) throws -> [ActiveAtcFacility] {
        let data: [ActiveAtcFacility] = try getJsonData(RequestPath.activeAtc(sessionId))
        return data
    }
    
    //MARK: Get User Stats
    /**
     Retrieve user statistics for multiple users, including their grade, flight time and username.
     - Parameters:
       - userIds: An array of user ID strings retrieved from another endpoint
       - discourseNames: An array of IFC Usernames. Not case sensitive.
       - userHashes: An array of user hashes retrieved in-app or from another endpoint. All letters must be upper case.
     - Warning: At least one array has to have data Requesting data on more than 25 users at a time will result in an error.
     - Returns: Returns an array of UserStats objects.
     - Note: If you need a more detailed Grade table, consider using getUserGrade
     */
    public func getUserStats(userIds: [String] = [], discourseNames: [String] = [], userHashes: [String] = []) throws -> [UserStats] {
        
        let usersCount = userIds.count + discourseNames.count + userHashes.count
        guard usersCount <= 25 else {
            throw LiveApiClientError.tooManyUsers
        }
        guard usersCount > 0 else {
            throw LiveApiClientError.emptyrequestParameters
        }
        
        requestsThisMinute += 1
        guard requestsThisMinute <= requestLimitPerMinute else {
            throw LiveApiClientError.requestLimitReached
        }
        
        struct UserStatsRequest: Codable {
            var userIds: [String]?
            var discourseNames: [String]?
            var userHashes: [String]?
        }
        
        guard let requestUrl = URL(string: "\(baseUrl)\(RequestPath.userStats)?apikey=\(apiKey)") else {
            print("getUserStats: \(baseUrl)\(RequestPath.userStats)?apikey=\(apiKey) is an invalid URL")
            throw LiveApiClientError.invalidUrl
        }
        
        guard let requestBody = try? JSONEncoder().encode(
                UserStatsRequest(userIds: userIds, discourseNames: discourseNames, userHashes: userHashes)) else {
            throw LiveApiClientError.failedToEncodeRequestBody
            
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        var result = [UserStats]()
        
        // Semaphore is for the "return result" code to wait for the completion of dataTask
        // Don't change it to anything but zero, or else it breaks
        let semaphore = DispatchSemaphore(value: 0)
        
        var urlSessionError: Error?
        URLSession.shared.dataTask(with: request) { data, response, responseError in
            // Defer means when this closure exits this would execute
            defer {
                semaphore.signal()
            }
            
            do {
                guard responseError == nil else {
                    throw responseError!
                }
                guard data != nil else {
                    throw LiveApiClientError.dataIsNil
                }
                
                
                var jsonData: LiveApiResponseWrapper<[UserStats]>!
                do {
                    jsonData = try self.jsonDecoder.decode(LiveApiResponseWrapper<[UserStats]>.self, from: data!)
                } catch {
                    if let codeFetcher = try? self.jsonDecoder.decode(LiveApiErrorCodeFetcher.self, from: data!) {
                        let liveApiError = LiveApiError.init(rawValue: codeFetcher.errorCode) ?? .unknownErrorCode
                        throw liveApiError
                    } else {
                        throw error
                    }
                }
                result = jsonData.result
                
            } catch {
                urlSessionError = error
                return
            }
        }.resume()
        
        guard urlSessionError == nil else {
            throw urlSessionError!
        }
        //Means the code will wait until the semaphore signals (and it does that at the end of the closure due to defer)
        semaphore.wait()
        
        return result
    }
    
    //MARK: Get User Grade
    /**
     Retrieve the full grade table and detailed statistics for a user.
     - Parameter userId: ID of the User
     - Returns: Returns an optional GradeInfo object or nil if something went wrong.
     - Note: if you don't need grade table, consider using getUserStats instead.
     */
    
    public func getUserGrade(_ userId: String) throws -> GradeInfo {
        let data: GradeInfo = try getJsonData(RequestPath.userGrade(userId))
        return data
    }
    
    //MARK: Get Airport ATIS
    /**
     Retrieve the ATIS for an airport on a specific server if it is active.
     - Parameters:
       - icao: ICAO of the airport to get the ATIS for
       - sessionId: Session (Server) ID of the Live Server
     - Returns: Returns an optional String or nil if something went wrong.
     */
    public func getAirportAtis(icao: String, sessionId: String) throws -> String {
        let data: String = try getJsonData(RequestPath.airportAtis(icao, serverId: sessionId))
        return data
    }
    
    //MARK: Get Airport Status
    /**
     Retrieve active ATC status information for an airport, and the number of inbound and outbound aircraft.
     - Parameters:
       - icao: ICAO of the airport to get the Status for
       - sessionId: Session (Server) ID of the Live Server
     - Returns: Returns a noptional AirportStatus object or nil if something went wrong.
     */
    public func getAirportStatus(icao: String, sessionId: String) throws -> AirportStatus {
        let data: AirportStatus = try getJsonData(RequestPath.airportStatus(icao, serverId: sessionId))
        return data
    }
    
    //MARK: Get world status
    /**
     Retrieve active ATC status information and inbound/outbound aircraft information for all airports with activity on a specific server.
     - Parameter sessionId: Session (Server) ID of the Live Server
     - Returns: Returns an array of AirportStatus objects or an empty array if something went wrong.
     */
    public func getWorldStatus(_ sessionId: String) throws -> [AirportStatus] {
        let data: [AirportStatus] = try getJsonData(RequestPath.worldStatus(sessionId))
        return data
    }
    
    //MARK: Get Oceanic tracks
    /**
     Retrieves a list of Oceanic Tracks active in Infinite Flight multiplayer sessions.
     - Returns: Returns an array of OceanicTrack objects or an empty array if something went wrong.
     */
    public func getOceanicTracks() throws -> [OceanicTrack] {
        let data: [OceanicTrack] = try getJsonData(RequestPath.oceanicTracks)
        return data
    }
    
    //MARK: Request paths
    public enum RequestPath {
        static let sessions = "/public/v2/sessions"
        
        static func flights(_ sessionId: String) -> String {
            return "/public/v2/flights/\(sessionId)"
        }
        
        static func flightRoute(_ flightId: String) -> String {
            return "/public/v2/flight/\(flightId)/route"
        }
        
        static func flightPlan(_ flightId: String) -> String {
            return "/public/v2/flight/\(flightId)/flightplan"
        }
        
        static func activeAtc(_ sessionId: String) -> String {
            return "/public/v2/atc/\(sessionId)"
        }
        
        static let userStats = "/public/v2/user/stats"
        
        static func userGrade(_ userId: String) -> String {
            return "/public/v2/user/grade/\(userId)"
        }
        
        static func airportAtis(_ airportIcao: String, serverId: String) -> String {
            return "/public/v2/airport/\(airportIcao)/atis/\(serverId)"
        }
        
        static func airportStatus(_ airportIcao: String, serverId: String) -> String {
            return "/public/v2/airport/\(airportIcao)/status/\(serverId)"
        }
        
        static func worldStatus(_ serverId: String) -> String {
            return "/public/v2/world/status/\(serverId)"
        }
        
        static let oceanicTracks = "/public/v2/tracks"
    }
    
    //MARK: Custom errors
    public enum LiveApiClientError: String, Error {
        case requestLimitReached = "Reached request limit"
        case dataIsNil = "Data returned nil"
        case tooManyUsers = "Request contained too much items (25 items max)"
        case failedToEncodeRequestBody = "Failed to encode request body"
        case emptyrequestParameters = "All of the request parameters were empty"
        case invalidUrl = "Request URL is invalid"
    }
}

public enum LiveServer {
    static internal var expertId = ""
    static internal var trainingId = ""
    static internal var casualId = ""
    
    case training, expert, casual
    
    public var id: String {
        switch self {
        case .casual:
            return LiveServer.casualId
        case .training:
            return LiveServer.trainingId
        case .expert:
            return LiveServer.expertId
        }
    }
}

// For JSON decoding in case there is data, but it can't be decoded into LiveApiResponseWrapper<T>
internal struct LiveApiErrorCodeFetcher: Codable {
    var errorCode: Int
}
