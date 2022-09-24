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
    var urlComponents = URLComponents()
    /// URLSession to be used by the client.
    let urlSession = URLSession(configuration: .ephemeral)
    /// JSON decoder to be used by the client
    let decoder = JSONDecoder()
    /// DateFormatter used by the decoder.
    let dateFormatter = DateFormatter()
    /// The API key used by the client.
    var apiKey: String? {
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
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
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
}
