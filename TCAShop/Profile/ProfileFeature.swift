//
//  ProfileFeature.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import Foundation
import ComposableArchitecture

struct ProfileFeature: Reducer {
    struct State: Equatable {
        var loadingStatus = DataLoadingStatus.notStarted
        var profile: Profile = .default
    }
    
    enum Action: Equatable {
        case fetchUserProfile
        case fetchUserProfileResponse(Profile)
        case fetchUserProfileWithError
    }
    
    @Dependency(\.client) var api
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchUserProfile:
                if state.loadingStatus == .loading || state.loadingStatus == .loaded {
                    return .none
                }
                state.loadingStatus = .loading
                return .run { send in
                    do {
                        let profile = try await self.api.fetchUserProfile()
                        await send(.fetchUserProfileResponse(profile))
                    } catch {
                        await send(.fetchUserProfileWithError)
                    }
                }
            case let .fetchUserProfileResponse(response):
                state.loadingStatus = .loaded
                state.profile = response
                return .none
            case .fetchUserProfileWithError:
                state.loadingStatus = .error
                return .none
            }
        }
    }
}
