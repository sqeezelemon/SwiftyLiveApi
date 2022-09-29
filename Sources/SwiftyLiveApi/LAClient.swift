// SwiftyLiveApi
// ↳ LAClient.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// Client for LiveAPI.
public final class LAClient {
    
    //MARK: Properties
    
    /// Reusable URL components
    private var urlComponents = URLComponents()
    /// URLSession to be used by the client.
    private let urlSession = URLSession(configuration: .ephemeral)
    /// JSON decoder to be used by the client
    private let decoder = JSONDecoder()
    /// The API key used by the client.
    public var apiKey: String? {
        set {
            urlComponents.queryItems = [
                URLQueryItem(name: "apikey", value: newValue)
            ]
        }
        get {
            return urlComponents.queryItems?
                .first(where: { $0.name == "apikey" })?
                .value
        }
    }
    
    //MARK: Initialisers
    
    /// Initialises the client.
    ///
    /// - Parameter apiKey: Live API key.
    public init(_ apiKey: String) {
        urlComponents.host = "api.infiniteflight.com"
        urlComponents.scheme = "https"
        self.apiKey = apiKey
    }
    
    //MARK: Networking
    
    /// Fetching logic for simple `GET` requests.
    ///
    /// - Parameter url: URL for the request.
    private func fetch<T: Decodable>(with url: URL) throws -> T {
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?
        var error: Error?
        
        urlSession.dataTask(with: url) { (respData, response, respError) in
            data = respData
            error = respError
            semaphore.signal()
        }.resume()
        semaphore.wait()
        
        guard let data = data else {
            if let error = error {
                throw error
            } else {
                throw LAClientError.dataIsNil
            }
        }

        let json = try decoder.decode(LAResponse<T>.self, from: data)
        return json.result
    }
    
    /// Fetching logic for non-`GET` requests.
    ///
    /// - Parameter request: URLRequest to be used for fetching.
    private func fetch<T: Decodable>(with request: URLRequest) throws -> T {
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?
        var error: Error?
        
        urlSession.dataTask(with: request) { (respData, response, respError) in
            data = respData
            error = respError
            semaphore.signal()
        }.resume()
        semaphore.wait()
        
        guard let data = data else {
            if let error = error {
                throw error
            } else {
                throw LAClientError.dataIsNil
            }
        }

        let json = try decoder.decode(LAResponse<T>.self, from: data)
        return json.result
    }
    
    //MARK: Client methods
    
    /// Retrieves active sessions (servers).
    public func getSessions() throws -> [LASession] {
        urlComponents.path = "/public/v2/sessions"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves a list of flights for a session.
    ///
    /// - Parameter sessionId: ID of the session.
    public func getFlights(_ sessionId: String) throws -> [LAFlight] {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/flights"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves the flown route of a flight.
    ///
    /// - Parameters:
    ///   - sessionId: ID of the session.
    ///   - flightId: ID of the flight.
    public func getFlightRoute(_ sessionId: String,
                               _ flightId: String) throws -> [LAPositionReport] {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/flights/\(flightId)/route"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves the flight plan for a given flight.
    ///
    /// - Parameters:
    ///   - sessionId: ID of the session.
    ///   - flightId: ID of the flight.
    public func getFlightPlan(_ sessionId: String,
                              _ flightId: String) throws -> [LAPositionReport] {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/flights/\(flightId)/route"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves all active ATC frequencies for a session.
    ///
    /// - Parameter sessionId: ID of the session.
    public func getActiveAtc(_ sessionId: String) throws -> [LAAtcFrequency] {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/atc"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves stats for up to 25 users.
    ///
    /// - Parameters:
    ///   - userIds: ID of the user, retrieveable from other endpoints.
    ///   - usernames: IFC usernames.
    ///   - userHashes: Short identifiers, as seen in-app.
    public func getUserStats(_ userIds: [String] = [],
                             _ usernames: [String] = [],
                             _ userHashes: [String] = []) throws -> [LAUserStats] {
        urlComponents.path = "/public/v2/users"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = LAUserStatsRequest(userIds: userIds,
                                      usernames: usernames,
                                      userHashes: userHashes)
        let data = try JSONEncoder().encode(json)
        request.httpBody = data
        return try fetch(with: request)
    }
    
    /// Retrieves the full grade table for a user.
    ///
    /// - Parameter userId: ID of the user, retrieveable from other endpoints.
    public func getUserGrade(_ userId: String) throws -> LAUserGrade {
        urlComponents.path = "/public/v2/users/\(userId)"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves ATIS for a specific airport on a specific airport, if available.
    ///
    /// - Parameters:
    ///   - sessionId: ID of the session.
    ///   - icao: ICAO code of the airport.
    public func getAtis(_ sessionId: String,
                        _ icao: String) throws -> String {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/airport/\(icao)/atis"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves active ATC at the airport and flights connected to it.
    ///
    /// - Parameters:
    ///   - sessionId: ID of the session.
    ///   - icao: ICAO code of the airport.
    public func getAirportStatus(_ sessionId: String,
                                 _ icao: String) throws -> LAAirportStatus {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/airport/\(icao)/status"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves active ATC and flights related to it for every airport.
    ///
    /// - Parameters:
    ///   - sessionId: ID of the session.
    ///   - icao: ICAO code of the airport.
    public func getWorldStatus(_ sessionId: String) throws -> [LAAirportStatus] {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/world"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves all active tracks (usually oceanic).
    public func getTracks() throws -> [LATrack] {
        urlComponents.path = "/public/v2/tracks"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves a single page from the flights logbook.
    ///
    /// - Parameters:
    ///   - userId: ID of the user.
    ///   - page: The logbook page to fetch. Defaults to `1`.
    public func getUserFlights(_ userId: String,
                               _ page: Int = 1) throws -> LAFlightLogbookPage {
        var compsCopy = urlComponents
        compsCopy.queryItems?.append(URLQueryItem(name: "page",
                                                      value: "\(page)"))
        compsCopy.path = "/public/v2/users/\(userId)/flights"
        guard let url = compsCopy.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves a single user flight.
    ///
    /// - Parameters:
    ///   - userId: ID of the user.
    ///   - flightId: ID of the flight to fetch.
    public func getUserFlight(_ userId: String,
                              _ flightId: String) throws -> LALogbookFlight {
        urlComponents.path = "/public/v2/users/\(userId)/flights/\(flightId)"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        //TODO: Date decoding
        return try fetch(with: url)
    }
    
    /// Retrieves a single page from the ATC logbook.
    ///
    /// - Parameters:
    ///   - userId: ID of the user.
    ///   - page: The logbook page to fetch. Defaults to `1`.
    public func getUserAtcSessions(_ userId: String,
                                   _ page: Int = 1) throws -> LAAtcLogbookPage {
        var compsCopy = urlComponents
        compsCopy.queryItems?.append(URLQueryItem(name: "page",
                                                      value: "\(page)"))
        compsCopy.path = "/public/v2/users/\(userId)/atc"
        guard let url = compsCopy.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves a single user ATC session.
    ///
    /// - Parameters:
    ///   - userId: ID of the user.
    ///   - atcSessionId: ID of the ATC session to fetch.
    public func getUserAtcSession(_ userId: String,
                                  _ atcSessionId: String) throws -> LALogbookAtcSession {
        urlComponents.path = "/public/v2/users/\(userId)/atc/\(atcSessionId)"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves NOTAMs for a session.
    ///
    /// - Parameter sessionId: ID of the session.
    public func getNotams(_ sessionId: String) throws -> [LANotam] {
        urlComponents.path = "/public/v2/sessions/\(sessionId)/notams"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves all aircraft available in the latest Infinite Flight version.
    public func getAircraft() throws -> [LAAircraft] {
        urlComponents.path = "/public/v2/aircraft"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves the list of liveries for a given aircraft in the latest Infinite Flight version.
    ///
    /// - Parameter aircraftId: ID of the aircraft.
    public func getAircraftLiveries(_ aircraftId: String) throws -> [LALivery] {
        urlComponents.path = "/public/v2/aircraft/\(aircraftId)/liveries"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
    
    /// Retrieves all liveries available in the latest Infinite Flight version.
    public func getLiveries() throws -> [LALivery] {
        urlComponents.path = "/public/v2/aircraft/liveries"
        guard let url = urlComponents.url else { throw LAClientError.urlIsNil }
        return try fetch(with: url)
    }
}
