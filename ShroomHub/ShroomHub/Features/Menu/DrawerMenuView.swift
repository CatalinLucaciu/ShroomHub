//
//  DrawerMenuView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 09.06.2025.
//


import SwiftUI
import SHNavigation
import ShroomHubDesignLibrary

struct DrawerMenuView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            header
            menuButton(title: "Profile", systemImage: "person.crop.circle") {
                navigationRouter.navigate(to: HomeTabDestination.profile, in: .home)
                onDismiss()
            }

            menuButton(title: "Settings", systemImage: "gearshape") {
                onDismiss()
            }

            menuButton(title: "About", systemImage: "info.circle") {
                onDismiss()
            }

            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(SHColor.mainBackground)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Menu")
                .font(.largeTitle.bold())
            Divider()
        }
    }

    @ViewBuilder
    private func menuButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundStyle(SHColor.forestGreen)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(SHColor.forestGreen)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
