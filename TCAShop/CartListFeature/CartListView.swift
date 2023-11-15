//
//  CartListView.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
    let store: StoreOf<CartListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                NavigationStack {
                    Group {
                        if viewStore.cartItems.isEmpty {
                            EmptyView()
                        } else {
                            VStack {
                                List {
                                    ForEachStore(
                                        self.store.scope(
                                            state: \.cartItems,
                                            action: CartListFeature.Action.cartItem
                                        )) { store in
                                            CartItemView(store: store)
                                        }
                                    
                                }
                                .safeAreaInset(edge: .bottom) {
                                    Button {
                                        viewStore.send(.didPressPayButton(.presented(.showAlert)))
                                    } label: {
                                        Text("Pay \(viewStore.totalPriceString) $")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                    }
                                    .frame(width: 200)
                                    .padding(20)
                                    .background(viewStore.isPayButtonActive ? Color.blue.cornerRadius(25) : Color.gray.cornerRadius(25)
                                    )
                                    .disabled(!viewStore.isPayButtonActive)
                                    
                                }
                                .onAppear {
                                    viewStore.send(.getTotalPrice)
                                }
                                .alert(
                                    store: self.store.scope(
                                        state: \.$confirmationAlert,
                                        action: {
                                            .didPressPayButton($0)
                                        }
                                    )
                                )
                                .alert(
                                    store: self.store.scope(
                                        state: \.$resultAlert,
                                        action: {
                                            .didPressPayButton($0)
                                        }
                                    )
                                )
                                .alert(
                                    store: self.store.scope(
                                        state: \.$errorAlert,
                                        action: {
                                            .didPressPayButton($0)
                                        }
                                    )
                                )
                            }
                        }
                    }
                }
                if viewStore.loadingStatus == .loading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem {
                    Button("close") {
                        viewStore.send(.didPressCloseButton)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CartListView(
            store: Store(
                initialState: CartListFeature.State(cartItems: IdentifiedArrayOf(
                    uniqueElements: CartItem.sample
                        .map {
                            CartItemFeature.State(id: UUID(), item: $0)
                        }
                )
                ),
                reducer: {
                    CartListFeature()
                }
            )
        )
    }
}
