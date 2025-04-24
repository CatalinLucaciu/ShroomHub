//
//  SpalshScreen.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 04.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary

struct SplashScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("appLogo")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(SHColor.white)
            Image("appTextLogoWhite")
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .tint(.white)
                .scaleEffect(2)
                .padding(.bottom, Spacing.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SHColor.forestGreen)
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreen()
}
