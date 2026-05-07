# ShroomHub 🍄

ShroomHub is a modern iOS application built with SwiftUI for mushroom discovery, identification, and personal foraging management.

The app explores a practical mobile product idea around mushroom classification, species information, saved findings, location-based discovery, and Object Capture concepts. The project is built as a portfolio application with focus on clean architecture, modularization, reusable UI, and real-world iOS development practices.

## Features

* Mushroom identification flow using image classification
* Detailed mushroom species information
* Personal collection of saved findings
* Map and location-based mushroom discovery
* Object Capture / 3D scanning exploration
* Firebase-based authentication and data layer
* Remote image loading support
* Reusable SwiftUI design system
* Modular local Swift package structure

## Tech Stack

* Swift
* SwiftUI
* iOS 18+
* Xcode 16+
* Firebase Auth
* Firebase Firestore
* Firebase Storage
* Firebase Analytics
* SDWebImageSwiftUI
* Lottie
* MapKit / CoreLocation
* Swift Package Manager

## Architecture

ShroomHub is structured around a modular, feature-oriented architecture. The main app target is kept focused on app composition, navigation, and feature integration, while reusable responsibilities are separated into local Swift packages.

The project currently uses several dedicated modules:

```text
ShroomHub
├── App Target
├── ShroomHubDesignLibrary
├── SHNavigation
├── SHUtils
├── CSRNetworkService
├── CSRLocationService
├── CSRImageClassifier
├── CSRObjectCapture
└── FirebaseAuthPackage
```

This separation keeps the codebase easier to scale, test, and maintain as the app grows.

## Modularization

The project uses local Swift packages to isolate shared functionality and avoid tightly coupling feature code.

The modular structure helps with:

* Keeping feature boundaries clear
* Reusing UI components across screens
* Separating navigation from screen implementation
* Isolating networking and location logic
* Keeping image classification independent from the UI
* Making the project easier to refactor and extend

This approach reflects how larger production iOS applications are usually organized.

## Main App Areas

```text
Dashboard
├── Home
│   └── Mushroom Identification
├── Species Details
├── Collection
├── Map
└── Object Capture
```

## Design System

ShroomHub includes a dedicated design library for shared UI styling and reusable SwiftUI components.

The design system is intended to centralize:

* Colors
* Spacing
* Typography
* Reusable components
* Cards and sections
* Common screen layouts

This keeps the app visually consistent and reduces duplicated UI code.

## Data & Services

The app is designed around a cloud-ready data layer using Firebase. Authentication, Firestore, Storage, and Analytics are integrated through Firebase packages, while image loading is handled with SDWebImageSwiftUI.

Core app services are separated into dedicated modules for networking, location handling, image classification, authentication, and Object Capture.

## Safety Notice

Mushroom identification can be dangerous if done incorrectly. Many poisonous mushrooms look very similar to edible species.

ShroomHub is intended as an educational and informational tool. It should not be used as the only source of truth when deciding whether a mushroom is safe to eat. Always consult an experienced forager, mycologist, or trusted field guide before consuming any wild mushroom.

## Current Status

The project is under active development.

Current focus areas include:

* Improving the mushroom identification flow
* Refining species detail screens
* Expanding collection functionality
* Improving map-based discovery
* Polishing the design system
* Strengthening module boundaries
* Improving the overall user experience

## Future Improvements

* Offline mushroom species database
* Improved classification model
* User-generated mushroom findings
* Saved mushroom hotspots
* Community-based observations
* Filtering by edibility, habitat, and season
* More complete Object Capture flow
* Unit tests for services and view models
* Accessibility improvements
* CI setup

## What This Project Demonstrates

This project demonstrates practical iOS development skills through a real-world app idea:

* SwiftUI app development
* Modular iOS architecture
* Swift Package Manager usage
* Firebase integration
* Reusable design system thinking
* Navigation separation
* Image classification integration
* Location-based features
* Remote image loading
* Product-focused mobile app design
* Safety-aware UX for a real-world domain

## Requirements

* iOS 18.0+
* Xcode 16+
* Swift 5+

## Author

**Cătălin Lucaciu**
**iOS Developer**

GitHub: [CatalinLucaciu](https://github.com/CatalinLucaciu)

## License

This project is currently intended for portfolio purposes.
 
