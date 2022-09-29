// SwiftyLiveApi
// ↳ NetworkingTests.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation
import XCTest
@testable import SwiftyLiveApi

/// Test data fetching from the API
///
/// To use, insert your Live API key into the 
final class NetworkingTests: XCTestCase {
    
    var apiKey: String {
        let url = Bundle.module.url(forResource: "apikey", withExtension: "txt")!
        let str = (try? String(contentsOf: url))!
        return str.components(separatedBy: "\n").first!
    }
    
    var client: LAClient {
        LAClient(apiKey)
    }
    
    func testGetSessions() {
        XCTAssertNoThrow(try client.getSessions())
    }
    
    func testGetFlights() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        XCTAssertNoThrow(try client.getFlights(sessions[0].id))
    }
    
    func testGetFlightRoute() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        var flights: [LAFlight]!
        XCTAssertNoThrow(flights = try client.getFlights(session.id))
        XCTAssertNotEqual(flights.count, 0, "Test can't be ran with 0 flights")
        let flight = flights.first { $0.position.altitude > 30000 } ?? flights.randomElement()!
        
        XCTAssertNoThrow(try client.getFlightRoute(session.id, flight.flightId))
    }
    
    func testGetFlightPlan() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        var flights: [LAFlight]!
        XCTAssertNoThrow(flights = try client.getFlights(session.id))
        XCTAssertNotEqual(flights.count, 0, "Test can't be ran with 0 flights")
        let flight = flights.first { $0.position.altitude > 30000 } ?? flights.randomElement()!
        
        XCTAssertNoThrow(try client.getFlightPlan(session.id, flight.flightId))
    }
    
    func testGetActiveATC() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        XCTAssertNoThrow(try client.getActiveAtc(session.id))
    }
    
    func testGetUserStats() {
        let usernames: [String] = ["Laura", "Cameron"]
        let userIds: [String] = []
        let hashes: [String] = []
        XCTAssertNoThrow(try client.getUserStats(userIds, usernames, hashes))
    }
    
    func testGetUserGrade() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        var flights: [LAFlight]!
        XCTAssertNoThrow(flights = try client.getFlights(session.id))
        XCTAssertNotEqual(flights.count, 0, "Test can't be ran with 0 flights")
        let flight = flights.first { $0.position.altitude > 30000 } ?? flights.randomElement()!
        
        XCTAssertNoThrow(try client.getUserGrade(flight.userId))
    }
    
    func testGetAirportAtis() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { $0.name.contains("Expert") } ?? sessions.randomElement()!
        
        var status: [LAAirportStatus]!
        XCTAssertNoThrow(status = try client.getWorldStatus(session.id))
        let airport: LAAirportStatus? = status.first { $0.activeAtc.contains { $0.type == .atis } }
        XCTAssertNotNil(airport, "Test can't be ran without a user")
        
        XCTAssertNoThrow(try client.getAtis(session.id, airport!.icao))
    }
    
    func testGetAirportStatus() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0)
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        XCTAssertNoThrow(try client.getAirportStatus(session.id, "KLAX"))
    }
    
    func testGetWorldStatus() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0)
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        XCTAssertNoThrow(try client.getWorldStatus(session.id))
    }
    
    func testGetOceanicTracks() {
        XCTAssertNoThrow(try client.getTracks())
    }
    
    func testGetUserFlights() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        var flights: [LAFlight]!
        XCTAssertNoThrow(flights = try client.getFlights(session.id))
        XCTAssertNotEqual(flights.count, 0, "Test can't be ran with 0 flights")
        let flight = flights.first { $0.position.altitude > 30000 } ?? flights.randomElement()!
        
        XCTAssertNoThrow(try client.getUserFlights(flight.userId))
        XCTAssertNoThrow(try client.getUserFlights(flight.userId, 2))
    }
    
    func testGetUserFlight() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { !$0.name.contains("Casual") } ?? sessions.randomElement()!
        
        var flights: [LAFlight]!
        XCTAssertNoThrow(flights = try client.getFlights(session.id))
        XCTAssertNotEqual(flights.count, 0, "Test can't be ran with 0 flights")
        let flight = flights.first { $0.position.altitude > 30000 } ?? flights.randomElement()!
        
        var logbook: LAFlightLogbookPage!
        XCTAssertNoThrow(logbook = try client.getUserFlights(flight.userId))
        XCTAssertNotEqual(logbook.data.count, 0, "Test can't be ran with 0 flights")
        let logbookFlight = logbook.data.randomElement()!
        
        XCTAssertNoThrow(try client.getUserFlight(flight.userId, logbookFlight.id))
    }
    
    func testGetUserAtcSessions() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { $0.name.contains("Expert") } ?? sessions.randomElement()!
        
        var status: [LAAirportStatus]!
        XCTAssertNoThrow(status = try client.getWorldStatus(session.id))
        let frequency: LAAtcFrequency? = status.first { !$0.activeAtc.isEmpty }?.activeAtc.first
        XCTAssertNotNil(frequency, "Test can't be ran without a user")
        
        XCTAssertNoThrow(try client.getUserAtcSessions(frequency!.userId))
        XCTAssertNoThrow(try client.getUserAtcSessions(frequency!.userId, 2))
    }
    
    func testGetUserAtcSession() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0, "Test can't be ran with 0 sessions")
        let session = sessions.first { $0.name.contains("Expert") } ?? sessions.randomElement()!
        
        var status: [LAAirportStatus]!
        XCTAssertNoThrow(status = try client.getWorldStatus(session.id))
        let frequency: LAAtcFrequency? = status.first { !$0.activeAtc.isEmpty }?.activeAtc.first
        XCTAssertNotNil(frequency, "Test can't be ran without a user")
        
        var logbook: LAAtcLogbookPage!
        XCTAssertNoThrow(logbook = try client.getUserAtcSessions(frequency!.userId))
        XCTAssertNotEqual(logbook.data.count, 0, "Test can't be ran with 0 flights")
        let logbookAtc = logbook.data.randomElement()!
        
        XCTAssertNoThrow(try client.getUserAtcSession(frequency!.userId, logbookAtc.id))
    }
    
    func testGetNotams() {
        var sessions: [LASession]!
        XCTAssertNoThrow(sessions = try client.getSessions())
        XCTAssertNotEqual(sessions.count, 0)
        XCTAssertNoThrow(try client.getNotams(sessions.randomElement()!.id))
    }
    
    func testGetAircraft() {
        XCTAssertNoThrow(try client.getAircraft())
    }
    
    func testGetAircraftLiveries() {
        var aircraft: [LAAircraft]!
        XCTAssertNoThrow(aircraft = try client.getAircraft())
        XCTAssertNotEqual(aircraft.count, 0)
        XCTAssertNoThrow(try client.getAircraftLiveries(aircraft.randomElement()!.id))
    }
    
    func testGetLiveries() {
        XCTAssertNoThrow(try client.getLiveries())
    }
    
    static var allTests = [
        ("Get Sessions", testGetSessions),
        ("Get Flights", testGetFlights),
        ("Get Flight Route", testGetFlightRoute),
        ("Get Flight Plan", testGetFlightPlan),
        ("Get Active ATC Facilities", testGetActiveATC),
        ("Get User Stats", testGetUserStats),
        ("Get User Grade", testGetUserGrade),
        ("Get Airport ATIS", testGetAirportAtis),
        ("Get Airport Status", testGetAirportStatus),
        ("Get World Status", testGetWorldStatus),
        ("Get Oceanic Tracks", testGetOceanicTracks),
        ("Get User Flights", testGetUserFlights),
        ("Get User Flight", testGetUserFlight),
        ("Get User ATC Sessions", testGetUserAtcSessions),
        ("Get User ATC Session", testGetUserAtcSession),
        ("Get NOTAMs", testGetNotams),
        ("Get Aircraft", testGetAircraft),
        ("Get Aircraft Liveries", testGetAircraftLiveries),
        ("Get Liveries", testGetLiveries)
    ]
}
