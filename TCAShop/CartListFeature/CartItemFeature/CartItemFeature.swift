//
//  CartItemFeature.swift
//  TCAPedro
//
//  Created by User on 10.11.2023.
//

import Foundation
import ComposableArchitecture

struct CartItemFeature: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        let item: CartItem
    }
    
    enum Action: Equatable {
        case deleteCartItem(product: Product)
    }
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            return .none
        }
    }
}
