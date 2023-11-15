//
//  ProductClient.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import Foundation
import ComposableArchitecture

struct ProductsClient {
    var fetch: () async throws -> [Product]
    var sendOrder: ([CartItem]) async throws -> String
    var fetchUserProfile: () async throws -> Profile

}

extension ProductsClient: DependencyKey {
    static let liveValue = Self {
        try await APIClient.live.fetchProducts()
    } sendOrder: { items in
        try await APIClient.live.sendOrder(items)
    } fetchUserProfile: {
        try await APIClient.live.fetchUserProfile()
    }
    
    static let mock = Self {
        Product.sample
    } sendOrder: { _ in
        return "OK"
    } fetchUserProfile: {
        Profile.sample
    }
    
    static let mockWithApiError = Self {
        Product.sample
    } sendOrder: { _ in
        throw APIError.failedPayment
    } fetchUserProfile: {
        throw APIError.failedPayment
    }
}

extension DependencyValues {
    var client: ProductsClient {
        get { self[ProductsClient.self] }
        set { self[ProductsClient.self] = newValue }
    }
}
