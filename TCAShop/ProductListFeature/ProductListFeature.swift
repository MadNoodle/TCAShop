//
//  ProductListFeature.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import Foundation
import ComposableArchitecture

struct ProductListFeature: Reducer {
    
    struct State: Equatable {
        var loadingStatus = DataLoadingStatus.notStarted
        var productList: IdentifiedArrayOf<ProductFeature.State> = []
        var product = StackState<ProductFeature.State>()
        var shouldOpenCart = false
        var cartState: CartListFeature.State?
        
        var shouldShowError: Bool {
            self.loadingStatus == .error
        }
        
        var shouldShowIndicator: Bool {
            self.loadingStatus == .loading
        }
    }
    
    enum Action: Equatable {
        case fetchProducts
        case fetchProductResponse([Product])
        case fetchProductResponseError
        case product(id: ProductFeature.State.ID, action: ProductFeature.Action)
        case setCartStatus(isPresented: Bool)
        case cart(CartListFeature.Action)
    }
    
    @Dependency(\.client) var products
    
    var body: some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .fetchProducts:
                if state.loadingStatus == .loaded || state.loadingStatus == .loading {
                    return .none
                }
                state.loadingStatus = .loading
                return .run { send in
                    do {
                        let response = try await products.fetch()
                        await send(.fetchProductResponse(response))
                    } catch {
                        await send(.fetchProductResponseError)
                    }
                }
            case let .fetchProductResponse(products):
                state.loadingStatus = .loaded
                state.productList = IdentifiedArray(
                    uniqueElements: products
                        .map {
                            ProductFeature.State(id: UUID(), product: $0)
                        }
                )
                return .none
            case .fetchProductResponseError:
                state.loadingStatus = .error
                return .none
            case .product:
                return .none
            case .setCartStatus(let isPresented):
                state.shouldOpenCart = isPresented
                state.cartState?.cartItems =
                    IdentifiedArrayOf(
                        uniqueElements: state.productList.compactMap { state in
                            state.count > 0 ?
                            CartItemFeature.State(
                                id: UUID(),
                                item: CartItem(
                                    product: state.product,
                                    quantity: state.count
                                )
                            )
                            : nil
                        }
                    )
                return .none
            case .cart(let action):
                switch action {
                case .didPressCloseButton:
                    state.shouldOpenCart = false
                    return .none
                case let .cartItem(_, action):
                    switch action {
                    case let .deleteCartItem(product):
                        guard let index = state.productList
                            .firstIndex(where: { $0.product.id == product.id})
                        else {
                            return .none
                        }
                        
                        let productStateId = state.productList[index].id
                        state.productList[id: productStateId]?.count = 0
                    }
                    return .none
                case .dismissSuccessAlert:
                    Self.resetBasket(for: &state)
                    state.shouldOpenCart = false
                    return .none
                default:
                    return .none
                }
            }
        }
        .forEach(
            \.productList,
             action: /ProductListFeature.Action.product(id:action:)
        ) {
            ProductFeature()
                ._printChanges()
        }
        .ifLet(
            \.cartState,
             action: /Action.cart) {
                 CartListFeature()
             }
        }
    
    private static func resetBasket(for state: inout State) {
        for id in state.productList.map(\.id) {
            state.productList[id: id]?.count = 0
        }
    }
}

