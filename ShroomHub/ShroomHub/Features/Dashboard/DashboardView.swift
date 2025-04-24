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
    @State private var isShowingPopover = false

    var body: some View {
        TabView() {
            Tab(homeTitle,
                systemImage: homeImage
            ) {
                HomeView()
            }
            Tab(cameraTitle,
                systemImage: cameraImage
            ) {
                MushroomClasificationView()
            }
            Tab(objectCaptureTitle,
                systemImage: objectCaptureImage) {
                MushroomCaptureView()
            }
            Tab(profileTitle,
                systemImage: profileImage
            ) {
                ProfileView()
            }
        }
    }
}

// MARK: - Strings
private extension DashboardView {
    var homeTitle: String {
        "Home"
    }
    
    var cameraTitle: String {
        "Camera"
    }
    
    var profileTitle: String {
        "Profile"
    }
    
    var objectCaptureTitle: String {
        "3D Map"
    }
    
    var homeImage: String {
        "house.fill"
    }
    
    var cameraImage: String {
        "camera.fill"
    }
    
    var objectCaptureImage: String {
        "cube.transparent"
    }
    
    var profileImage: String {
        "person.fill"
    }
}


#Preview {
    DashboardView()
}
