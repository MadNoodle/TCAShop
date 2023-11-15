//
//  PlusMinuseView.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusView: View {
    let store: StoreOf<AddToCartFeature>
    
    var body: some View {
        WithViewStore(self.store, observe:  { $0 }) { viewStore in
            HStack {
                Button("-") {
                    viewStore.send(.decrementButtonTapped)
                }
                .padding(10)
                .font(.custom("AmericanTypeWriter", size: 20))
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
                .buttonStyle(.plain)
                
                Text("\(viewStore.count.description)")
                    .font(.custom("AmericanTypeWriter", size: 20))
                
                Button("+") {
                    viewStore.send(.incrementButtonTapped)
                }
                .padding(10)
                .font(.custom("AmericanTypeWriter", size: 20))
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
                .buttonStyle(.plain)
            
            }
            
        }
    }
}

#Preview {
    PlusMinusView(
        store: Store(initialState: AddToCartFeature.State()) {
            AddToCartFeature()
        }
    )
}
