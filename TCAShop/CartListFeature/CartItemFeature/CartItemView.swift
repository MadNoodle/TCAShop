//
//  CartItemView.swift
//  TCAPedro
//
//  Created by User on 10.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartItemView: View {
    let store: StoreOf<CartItemFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    AsyncImage(url: URL(string: viewStore.item.product.imageString)!
                    )
                    {
                        $0
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                
                VStack(alignment: .leading) {
                    Text(viewStore.item.product.title)
                        .lineLimit(3)
                        .minimumScaleFactor(0.5)
                    HStack {
                        Text("$\(viewStore.item.product.price.description)")
                            .font(.custom("AmericanTypewriter", size: 25))
                            .fontWeight(.bold)
                    }
                    Group {
                        HStack {
                            Text("Quantity ")
                        +
                        Text("\(viewStore.item.quantity)")
                            .fontWeight(.bold)
                        
                            Spacer()
                            Button {
                                viewStore.send(.deleteCartItem(product: viewStore.item.product))
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                    }
                    .font(.custom("AmericanTypewriter", size: 25))
                    .padding(10)
                }
                }
            }
        }
    }
}

#Preview {
    CartItemView(store:
                    Store(
                        initialState: CartItemFeature.State(
                            id: UUID(),
                            item: CartItem.sample[0]
                        ),
                        reducer: {
                            CartItemFeature()
                        }
                    )
    )
}
