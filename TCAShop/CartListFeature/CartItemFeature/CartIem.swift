//
//  CartIem.swift
//  TCAPedro
//
//  Created by User on 10.11.2023.
//

import Foundation

struct CartItem: Equatable {
    let product: Product
    let quantity: Int
}

extension CartItem: Encodable {
    enum CodingKeys: CodingKey {
        case productId
        case quantity
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(product.id, forKey: .productId)
        try container.encode(quantity, forKey: .quantity)
    }
}

extension CartItem {
    static let sample: [CartItem] = [
        .init(product: Product.sample[0], quantity: 1),
        .init(product: Product.sample[1], quantity: 1),
        .init(product: Product.sample[2], quantity: 1),
    ]
}
