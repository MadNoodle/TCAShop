//
//  CounterFeature.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import Foundation
import ComposableArchitecture

struct AddToCartFeature: Reducer {
    
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        return Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            }
        }
    }
    
}
