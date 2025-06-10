//
//  DashboardView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import SHNavigation
import ShroomHubDesignLibrary
import FirebaseAuthPackage
import CSRNetworkService
import CSRLocationService

struct DashboardView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var appSession: AppSession
    var homeViewFactory: HomeViewFactory {
        HomeViewFactory(appSession: appSession)
    }
    var mapViewFactory: MapViewFactory {
        MapViewFactory(appSession: appSession)
    }
    let objectCaptureViewFactory = ObjectCaptureViewFactory()
    let collectionViewFactory = CollectionViewFactory()
    
    var body: some View {
        TabView() {
            Tab(SHTab.home.title,
                systemImage: SHTab.home.systemImage
            ) {
                makeTabContent(for: .home)
            }
            Tab(SHTab.objectCapture.title,
                systemImage: SHTab.objectCapture.systemImage) {
                makeTabContent(for: .objectCapture)
            }
            Tab(SHTab.map.title,
                systemImage: SHTab.map.systemImage
            ) {
                makeTabContent(for: .map)
            }
            Tab(SHTab.collection.title,
                systemImage: SHTab.collection.systemImage
            ) {
                makeTabContent(for: .collection)
            }
        }
        .tint(SHColor.forestGreen)
        .background(SHColor.mainBackground)
    }
}

// MARK: - Utils
private extension DashboardView {
    @ViewBuilder
    func makeTabContent(for tab: SHTab) -> some View {
        switch tab {
        case .home:
            NavigationStack(path: navigationRouter.path(for: .home)) {
                let networkService = NetworkService()
                let viewModel = HomeViewModel(mushroomService: MushroomSpeciesService(networkService: networkService, locationProvder: CSRLocationService(), userService: UserService(networkService: networkService)), appSession: appSession)
                HomeView(viewModel: viewModel)
                    .navigationDestination(for: HomeTabDestination.self) { destination in
                        homeViewFactory.makeView(for: destination)
                    }
            }
        case .objectCapture:
            NavigationStack(path: navigationRouter.path(for: .objectCapture)) {
                MushroomCaptureView()
                    .navigationDestination(for: ObjectCaptureTabDestination.self) { destination in
                        objectCaptureViewFactory.makeView(for: destination)
                    }
            }
        case .map:
            NavigationStack(path: navigationRouter.path(for: .map)) {
                let service = MushroomSpeciesService(networkService: NetworkService(), locationProvder: CSRLocationService(), userService: UserService(networkService: NetworkService()))
                let viewModel = MushroomMapViewModel(service: service, locationService: CSRLocationService())
                MushroomMapView(viewModel: viewModel)
                    .navigationDestination(for: MapTabDestination.self) { destination in
                        mapViewFactory.makeView(for: destination)
                    }
            }
        case .collection:
            let viewModel = MushroomCollectionViewModel(service: MushroomSpeciesService(networkService: NetworkService(), locationProvder: CSRLocationService(), userService: UserService(networkService: NetworkService())), appSession: appSession)
            NavigationStack(path: navigationRouter.path(for: .collection)) {
                MushroomCollectionView(viewModel: viewModel)
                    .navigationDestination(for: CollectionTabDestination.self) { destination in
                        collectionViewFactory.makeView(for: destination)
                    }
            }
        }
    }
}

#Preview {
    DashboardView()
}
