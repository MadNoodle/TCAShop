//
//  ProductListView.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {
    let store: StoreOf<ProductListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0}) { viewStore in
            NavigationStack {
                Group {
                    switch viewStore.loadingStatus {
                    case .loading:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .notStarted:
                        EmptyView()
                    case .loaded:
                        List {
                            ForEachStore(
                                self.store.scope(
                                    state: \.productList,
                                    action: ProductListFeature.Action.product
                                )) {
                                    ProductView(store: $0)
                                }
                        }
                    case .error:
                        ErrorView(message: "Error while fetching products") {
                            viewStore.send(.fetchProducts)
                        }
                    }
                }
                .task {
                    viewStore.send(.fetchProducts)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Go to cart") {
                        viewStore.send(.setCartStatus(isPresented: true))
                    }
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.shouldOpenCart,
                    send: { .setCartStatus(isPresented: $0) }
                )
            ) {
                IfLetStore(
                     self.store.scope(
                        state: \.cartState,
                        action: ProductListFeature.Action.cart
                     )
                ) {
                     CartListView(store: $0)
                 }
                
            }
            
        }
        
    }
}

#Preview {
    NavigationStack {
        ProductListView(
            store: Store(
                initialState: ProductListFeature.State(
                    cartState: CartListFeature.State()
                )
            ) {
                ProductListFeature()
            } withDependencies: {
                $0.client = { .mock }()
            }
        )
    }
}
