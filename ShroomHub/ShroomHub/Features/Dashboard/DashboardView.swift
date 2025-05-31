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
    let homeViewFactory = HomeViewFactory()
    var classificationViewFactory: ClassificationViewFactory {
        ClassificationViewFactory(appSession: appSession)
    }
    let objectCaptureViewFactory = ObjectCaptureViewFactory()
    let profileViewFactory = ProfileViewFactory()
    @State private var isShowingPopover = false
    
    var body: some View {
        TabView() {
            Tab(SHTab.home.title,
                systemImage: SHTab.home.systemImage
            ) {
                makeTabContent(for: .home)
            }
            Tab(SHTab.classification.title,
                systemImage: SHTab.classification.systemImage
            ) {
                makeTabContent(for: .classification)
            }
            Tab(SHTab.objectCapture.title,
                systemImage: SHTab.objectCapture.systemImage) {
                makeTabContent(for: .objectCapture)
            }
            Tab(SHTab.profile.title,
                systemImage: SHTab.profile.systemImage
            ) {
                makeTabContent(for: .profile)
            }
        }
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
        case .classification:
            NavigationStack(path: navigationRouter.path(for: .classification)) {
                MushroomClasificationView()
                    .navigationDestination(for: ClassificationTabDestination.self) { destination in
                        classificationViewFactory.makeView(for: destination)
                    }
            }
        case .profile:
            let viewModel = MushroomCollectionViewModel(service: MushroomSpeciesService(networkService: NetworkService(), locationProvder: CSRLocationService(), userService: UserService(networkService: NetworkService())), appSession: appSession)
            NavigationStack(path: navigationRouter.path(for: .profile)) {
//                MushroomCollectionView(viewModel: viewModel)
                ProfileView()
                    .navigationDestination(for: ProfileTabDestination.self) { destination in
                        profileViewFactory.makeView(for: destination)
                    }
            }
        }
    }
}

#Preview {
    DashboardView()
}
