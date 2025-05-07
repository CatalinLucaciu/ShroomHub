//
//  NavigationDestination.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

enum AppRootDestination: Hashable {
    case login
    case register
    case dashboard
}

enum HomeTabDestination: Hashable {
    case homeScreen
}

enum ClassificationTabDestination: Hashable {
    case classification
    case speciesDetails(String)
}

enum ObjectCaptureTabDestination: Hashable {
    case objectCapture
}

enum ProfileTabDestination: Hashable {
    case profile
}
