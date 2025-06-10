//
//  HomeViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI

import SwiftUI
import CSRLocationService
import FirebaseAuthPackage
import CSRNetworkService

struct HomeViewFactory {
    let appSession: any AppSessionProtocol
    
    var mushroomService: MushroomSpeciesService {
        MushroomSpeciesService(
            networkService: networkService,
            locationProvder: locationService,
            userService: userService
        )
    }
    
    var userService: UserService {
        UserService(networkService: networkService)
    }
    
    var networkService: NetworkService {
        NetworkService()
    }
    
    var locationService: CSRLocationService {
        CSRLocationService()
    }
    
    var fireBaseAuthenticator: FirebaseAuthenticator {
        FirebaseAuthenticator()
    }
    
    @ViewBuilder
    func makeView(for destination: HomeTabDestination) -> some View {
        switch destination {
        case let .classification(imageSource):
            MushroomClasificationView(imageSource: imageSource)
        case let .speciesDetails(classificationResult):
            speciesDetails(for: classificationResult)
        case .homeScreen:
            Text("homeScreen")
        case .profile:
            let viewModel = ProfileViewModel(userService: userService, fireBaseAuthenticator: fireBaseAuthenticator)
            ProfileView(viewModel: viewModel)
        }
    }
}

// MARK: - Views
private extension HomeViewFactory {
    @ViewBuilder
    func speciesDetails(for classificationResult: MushroomClassificationResult) -> some View {
        let viewModel = MushroomSpeciesViewModel(
            classificationResult: classificationResult,
            service: mushroomService,
            locationService: locationService,
            appSession: appSession
        )
        MushroomSpeciesView(viewModel: viewModel)
    }
}
