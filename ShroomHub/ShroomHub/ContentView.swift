//
//  ContentView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 25.02.2025.
//

import SwiftUI
import SwiftData
import SHNavigation
import FirebaseAuthPackage
import FirebaseFirestore

// MARK: - TO DO: do here call to see if authenticated and display spalshscreen meanwhile
struct ContentView: View {
    @State private var isSplashScreenActive = true
    private let authenticationManager: FirebaseAuthenticating
    private var authentifcationViewFactory: AuthenticationViewFactory {
        AuthenticationViewFactory(appSession: appSession)
    }
    @EnvironmentObject private var appSession: AppSession
    
    init(authenticationManager: FirebaseAuthenticating) {
        self.authenticationManager = authenticationManager
    }
    
    var body: some View {
        Group {
            if isSplashScreenActive {
                SplashScreen()
            } else {
                if appSession.currentUser != nil && appSession.isUserCreationFinished {
                    DashboardView()
                        .environmentObject(NavigationRouter.shared)
                } else {
                    LaunchScreen(authenticationViewFactory: authentifcationViewFactory)
                        .environmentObject(NavigationRouter.shared)
                }
               
            }
        }
        
        .task {
           try? await Task.sleep(nanoseconds: 200000)
            withAnimation {
                isSplashScreenActive = false
            }
        }
    }
}

//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
