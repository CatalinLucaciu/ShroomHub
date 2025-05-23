//
//  HomeView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        AsyncView(task: viewModel.getFeed) { feed in
            Text("musat")
        }
    }
}

// MARK: - Views
private extension HomeView {
    func content(for feed: [HomeFeedPost] ) {
        
    }
}
