//
//  NetworkManager.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/22/26.
//

import Foundation
import SwiftData


class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchRankings<T: Codable>(urlString: String, outputType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let accessToken = "ampheTM2NDQ6MUNDRkY2RDEtREExOS00NTZBLUEwRTAtODVDMEQ2Q0JCMzJF"
        request.setValue("Basic \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        
        let decodedRankings = try JSONDecoder().decode(outputType, from: data)
        return decodedRankings
    }
}