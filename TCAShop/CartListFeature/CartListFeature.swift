//
//  CartListFeature.swift
//  TCAPedro
//
//  Created by User on 10.11.2023.
//

import Foundation
import ComposableArchitecture

struct CartListFeature: Reducer {
    struct State: Equatable {
        var loadingStatus = DataLoadingStatus.notStarted
        var cartItems: IdentifiedArrayOf<CartItemFeature.State> = []
        var totalPrice: Double = 0.0
        var isPayButtonActive = false
        var paymentResponse = ""
        @PresentationState var confirmationAlert: AlertState<Action.Alert>?
        @PresentationState var resultAlert: AlertState<Action.Alert>?
        @PresentationState var errorAlert: AlertState<Action.Alert>?
        
        var totalPriceString: String {
            let roundedValue = round(totalPrice * 100) / 100
            return "\(roundedValue)"
        }
    }
    
    enum Action: Equatable {
        case didPressCloseButton
        case cartItem(id: CartItemFeature.State.ID, action: CartItemFeature.Action)
        
        case getTotalPrice
        case didReceivePurchaseResponse(String)
        case didReceivePurchaseResponseWithError(PresentationAction<Alert>)
        case didPressPayButton(PresentationAction<Alert>)
        case dismissSuccessAlert
        
        enum Alert: Equatable {
            case showAlert
            case didConfirmPurchase
            case didCancelConfirmation
            case didSucceed
            case didFailWithPaymentError
            case dismissSuccessAlert
        }
    }
    
    @Dependency(\.client) var client
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .didPressCloseButton:
                return .none
            case .cartItem(let id, let action):
                switch action {
                case .deleteCartItem:
                    state.cartItems.remove(id: id)
                    return .send(.getTotalPrice)
                }
            case .didPressPayButton(.presented(.showAlert)):
                state.confirmationAlert = AlertState(
                    title: TextState("Confirm your purchase"),
                    message: TextState("Do you want to proceed with your purchase of \(state.totalPriceString)?"),
                    buttons: [
                        .default(
                            TextState("Pay \(state.totalPriceString)"),
                            action: .send(.didConfirmPurchase)
                        ),
                        .cancel(
                            TextState("Cancel"),
                            action: .send(.didCancelConfirmation)
                        )
                    ]
                )
                return .none
                
            case .getTotalPrice:
                let items = state.cartItems.map { $0.item }
                state.totalPrice = items.reduce(0.0, { $0 + ($1.product.price * Double($1.quantity)) })
                return CartListFeature.verifyPayButtonVisibility(state: &state)
            case let .didReceivePurchaseResponse(response):
                state.paymentResponse = response
                state.loadingStatus = .loaded
                return .send(.didPressPayButton(.presented(.didSucceed)))
            case .didReceivePurchaseResponseWithError:
                return .send(.didPressPayButton(.presented(.didFailWithPaymentError)))
            case .didPressPayButton(.presented(.didConfirmPurchase)):
                if state.loadingStatus == .loaded || state.loadingStatus == .loading {
                    return .none
                }
                state.loadingStatus = .loading
                let items = state.cartItems.map { $0.item }
                return .run { send in
                    do {
                        let response = try await client.sendOrder(items)
                        await send(.didReceivePurchaseResponse(response))
                    } catch let error {
                        guard let apiError = error as? APIError else { return }
                        switch apiError {
                        case .failedPayment:
                            await send(.didReceivePurchaseResponseWithError(.presented(.didFailWithPaymentError)))
                        }
                    }
                }
            case .didPressPayButton(.presented(.didCancelConfirmation)):
                state.confirmationAlert = nil
                return .none
            case .didPressPayButton(.dismiss):
                state.confirmationAlert = nil
                return .none
            case .didPressPayButton(.presented(.didSucceed)):
                state.resultAlert = AlertState(
                    title: TextState("Bravo"),
                    message: TextState("the API answer is OK"),
                    buttons: [
                        .default(
                            TextState("Done"),
                            action: .send(.dismissSuccessAlert)
                        )
                    ]
                )
                return .none
            case .didPressPayButton(.presented(.didFailWithPaymentError)):
                state.loadingStatus = .error
                return .none
            case .didPressPayButton(.presented(.dismissSuccessAlert)):
                return .send(.dismissSuccessAlert)
            case .dismissSuccessAlert:
                state.resultAlert = nil
                return .none
            }
        }
        .forEach(
            \.cartItems,
             action: /Action.cartItem(id:action:)
        ) {
            CartItemFeature()
        }
    }
    
    private static func verifyPayButtonVisibility(
        state: inout State
    ) -> Effect<Action> {
        state.isPayButtonActive = state.totalPrice != 0.0
        return .none
    }
}
