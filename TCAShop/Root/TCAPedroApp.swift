//
//  TCAPedroApp.swift
//  TCAPedro
//
//  Created by User on 9.11.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAPedroApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView(store: Store(initialState: RootFeature.State(), reducer: {
                    RootFeature()
                }, withDependencies: {
                    $0.client = { .liveValue }()
                }))
            }
        }
    }
}
