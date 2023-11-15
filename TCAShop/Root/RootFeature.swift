//
//  RootFeature.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import Foundation
import ComposableArchitecture

struct RootFeature: Reducer {
    struct State: Equatable {
        var selectedTab = Tab.products
        var productListState = ProductListFeature.State(cartState: CartListFeature.State())
        var profileState = ProfileFeature.State()
    }
    
    enum Tab {
        case products
        case profile
    }
    
    @Dependency(\.client) var api
    
    enum Action: Equatable {
        case tabSelected(Tab)
        case productList(ProductListFeature.Action)
        case profile(ProfileFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
        
        Scope(
            state: \.productListState,
            action: /RootFeature.Action.productList
        ) {
            ProductListFeature()
        }
        
        Scope(
            state:  \.profileState,
            action: /RootFeature.Action.profile
        ) {
            ProfileFeature()
        }
    }
}
