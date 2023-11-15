//
//  ProductView.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductView: View {
    let store: StoreOf<ProductFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                AsyncImage(url: URL(string: viewStore.product.imageString)!) {
                    $0
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                } placeholder: {
                    ProgressView()
                        .frame(height:300)
                }
                VStack(alignment: .leading) {
                    Text(viewStore.product.title)
                    HStack {
                        Text("$\(viewStore.product.price.description)")
                            .font(.custom("AmericanTypeWriter", size: 25))
                            .fontWeight(.bold)
                        
                        Spacer()
                        AddToCartView(
                            store: self.store.scope(
                                state: \.addToCartState,
                                action: ProductFeature.Action.addToCart
                            )
                        )
                    }
                }
                .font(.custom("AmericanTypeWriter", size: 20))
                .padding(20)
            }
        }
    }
}

#Preview {
    ProductView(
        store: Store(
            initialState: ProductFeature.State(
                id: UUID(), product: Product.sample[0],
                addToCartState: AddToCartFeature.State()
            )
        ) {
                ProductFeature()
        }
    )
    .previewLayout(.fixed(width: 300, height: 300))
}
