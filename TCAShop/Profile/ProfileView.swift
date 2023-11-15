//
//  ProfileView.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section {
                        Text(viewStore.profile.firstname.capitalized)
                        +
                        Text(" \(viewStore.profile.lastname.capitalized)")
                    } header: {
                        Text("Full name")
                    }
                    
                    Section {
                        Text(viewStore.profile.email)
                    } header: {
                        Text("E-mail")
                    }
                }
                .task {
                    viewStore.send(.fetchUserProfile)
                }
                .navigationTitle("Profile")
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(store: Store(
            initialState: ProfileFeature.State(),
            reducer: {
                ProfileFeature()
            }, withDependencies: {
                $0.client = .mock
            }
        ))
    }
}
