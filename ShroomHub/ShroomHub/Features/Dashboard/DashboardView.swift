//
//  DashboardView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import SHNavigation
import ShroomHubDesignLibrary

struct DashboardView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    let homeViewFactory = HomeViewFactory()
    let classificationViewFactory = ClassificationViewFactory()
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
    }
}

// MARK: - Utils
private extension DashboardView {
    @ViewBuilder
    func makeTabContent(for tab: SHTab) -> some View {
        switch tab {
        case .home:
            NavigationStack(path: navigationRouter.path(for: .home)) {
                HomeView()
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
            NavigationStack(path: navigationRouter.path(for: .profile)) {
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
