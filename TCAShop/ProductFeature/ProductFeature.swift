//
//  ProductFeature.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import Foundation
import ComposableArchitecture

struct ProductFeature: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var addToCartState = AddToCartFeature.State()
        
        var count: Int {
            get { addToCartState.count }
            set { addToCartState.count = newValue }
        }
    }
    
    enum Action: Equatable {
        case addToCart(AddToCartFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
            Scope(
                state: \.addToCartState,
                action: /ProductFeature.Action.addToCart
            ) {
                AddToCartFeature()
            }
        
            Reduce { state, action in
                switch action {
                case .addToCart(.incrementButtonTapped):
                    return .none
                case .addToCart(.decrementButtonTapped):
                    state.addToCartState.count = max(0, state.addToCartState.count)
                    return .none
                }
            }
        }
}
