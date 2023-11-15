//
//  APIClient.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import Foundation

struct APIClient {
    var fetchProducts: () async throws -> [Product]
    var sendOrder: ([CartItem]) async throws -> String
    var fetchUserProfile: () async throws -> Profile
    
    enum Failure: Error {
        case invalidUrl
        case badRequest
        case invalidResponse
        case unauthorizedRequest
        case unavailable
        case serverUnreachable
        case genericError
    }
}

extension APIClient {
    
    static let live = Self  {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            throw APIClient.Failure.invalidUrl
        }
        
        do {
            let (data, _) = try await URLSession.shared
                .data(from: url)
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw APIClient.Failure.badRequest
        }
    } sendOrder: { items in
        // Make Payload
        do {
            let payload = try JSONEncoder().encode(items)
            // Make request
            guard let url = URL(string: "https://fakestoreapi.com/carts") else {
                throw APIClient.Failure.invalidUrl
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: payload)
            
            guard
                let httpResponse = (response as? HTTPURLResponse)
            else {
                throw APIClient.Failure.invalidResponse
            }
            let code = try httpResponse.mapValidResponse().statusCode
            return "Status: \(code)"
        } catch {
            throw Failure.genericError
        }
        
    } fetchUserProfile: {
        guard let url = URL(string: "https://fakestoreapi.com/users/1") else {
            throw APIClient.Failure.invalidUrl
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let profile = try JSONDecoder().decode(Profile.self, from: data)
            return profile
        } catch {
            throw APIClient.Failure.badRequest
        }
    }
    
}

extension HTTPURLResponse {
    func mapValidResponse() throws -> Self {
        if self.statusCode < 400 {
            return self
        } else if self.statusCode == 401 {
            throw APIClient.Failure.unauthorizedRequest
        } else if self.statusCode == 404  {
            throw APIClient.Failure.unavailable
        } else if self.statusCode == 500 {
            throw APIClient.Failure.serverUnreachable
        } else {
            throw APIClient.Failure.genericError
        }
        
    }
}
