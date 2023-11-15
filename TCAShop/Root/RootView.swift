//
//  RootView.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.selectedTab,
                send: RootFeature.Action.tabSelected
            )) {
                NavigationView {
                    ProductListView(store: self.store.scope(
                        state: \.productListState,
                        action: RootFeature.Action.productList
                    ))
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Product")
                }
                .tag(RootFeature.Tab.products)
                
                NavigationView {
                    ProfileView(store: self.store.scope(
                        state: \.profileState,
                        action: RootFeature.Action.profile
                    ))
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(RootFeature.Tab.profile)
            }
        }
    }
}

#Preview {
    RootView(store: Store(initialState: RootFeature.State(), reducer: {
        RootFeature()
    }, withDependencies: {
        $0.client = { .mock }()
    }))
}
