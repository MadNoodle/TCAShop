//
//  CounterView.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct AddToCartView: View {
    let store: StoreOf<AddToCartFeature>
    
    var body: some View {
        WithViewStore(self.store, observe:  { $0 }) { viewStore in
            if viewStore.count > 0 {
                PlusMinusView(store: self.store)
            } else {
                Button("Add to cart") {
                    viewStore.send(.incrementButtonTapped)
                }
                .padding(10)
                .font(.custom("AmericanTypeWriter", size: 20))
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
            }
        }
    }
}

#Preview {
    AddToCartView(
        store: Store(
            initialState: AddToCartFeature.State()
        ) {
            AddToCartFeature()
        }
    )
}
