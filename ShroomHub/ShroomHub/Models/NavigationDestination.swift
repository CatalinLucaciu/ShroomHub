//
//  NavigationDestination.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import CSRImageClassifier

enum AppRootDestination: Hashable {
    case login
    case register
    case dashboard
}

enum HomeTabDestination: Hashable {
    case homeScreen
    case classification(ClassificationImageSource)
    case speciesDetails(MushroomClassificationResult)
    case profile
}

enum MapTabDestination: Hashable {
    case classification
    case speciesDetails(MushroomClassificationResult)
}

enum ObjectCaptureTabDestination: Hashable {
    case objectCapture
}

enum CollectionTabDestination: Hashable {
    case profile
}
