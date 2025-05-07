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
    private let authenticationManager: FirebaseAuthenticator
    private var authentifcationViewFactory: AuthenticationViewFactory {
        AuthenticationViewFactory(authManager: authenticationManager)
    }
    
    init(authenticationManager: FirebaseAuthenticator) {
        self.authenticationManager = authenticationManager
    }
    
    var body: some View {
        Group {
            if isSplashScreenActive {
                SplashScreen()
            } else {
                if let user = authenticationManager.currentUser {
                    DashboardView()
                        .environmentObject(NavigationRouter.shared)
                } else {
                    LaunchScreen(authenticationViewFactory: authentifcationViewFactory)
                        .environmentObject(NavigationRouter.shared)
                }
               
            }
        }
        .task {
            uploadMushroomsFromBundle()
           try? await Task.sleep(nanoseconds: 200000)
            withAnimation {
                isSplashScreenActive = false
            }
        }
    }
    
    func uploadMushroomsFromBundle() {
        let db = Firestore.firestore()
        let fileManager = FileManager.default

        // 1. Get the URL to the bundle's main resource directory
        guard let bundleResourceURL = Bundle.main.resourceURL else {
            print("❌ Cannot access bundle resource directory.")
            return
        }

        // 2. Directly list contents of the main resource directory
        print("✅ Searching for JSON files in main resource directory: \(bundleResourceURL.path)")

        do {
            // 3. Get ALL contents of the main resource directory
            let allFileURLs = try fileManager.contentsOfDirectory(at: bundleResourceURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) // Added skipsHiddenFiles

            // 4. Filter ONLY for the JSON files you expect
            let jsonFiles = allFileURLs.filter { $0.pathExtension.lowercased() == "json" }
            // Optional: Add a more specific filter if other unrelated JSONs might exist
            // let jsonFiles = allFileURLs.filter { $0.pathExtension.lowercased() == "json" && isKnownSpeciesFile($0.lastPathComponent) } // Example

            if jsonFiles.isEmpty {
                print("⚠️ No expected JSON files found directly inside \(bundleResourceURL.path)")
                return
            }

            print("Found \(jsonFiles.count) JSON files. Starting upload...")

            for fileURL in jsonFiles {
                // --- Rest of your upload logic remains the same ---
                do {
                    let data = try Data(contentsOf: fileURL)
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let filename = fileURL.deletingPathExtension().lastPathComponent
                        let docID = filename.prefix(1).uppercased() + filename.dropFirst() // Using the filename directly as ID (adjust if needed)
                        // Or use your previous logic if you renamed files carefully:
                        // let docID = filename.prefix(1).uppercased() + filename.dropFirst()

                        print("Attempting to upload: \(docID) from \(fileURL.lastPathComponent)") // Added print
                        db.collection("mushrooms").document(docID).setData(json) { error in
                            if let error = error {
                                print("❌ Error uploading \(docID) from \(fileURL.lastPathComponent): \(error.localizedDescription)")
                            } else {
                                print("✅ Uploaded \(docID) from \(fileURL.lastPathComponent)")
                            }
                        }
                    } else {
                         print("❌ Failed to parse JSON object from \(fileURL.lastPathComponent)")
                    }
                } catch {
                    print("❌ Failed to read or decode \(fileURL.lastPathComponent): \(error)")
                }
                // --- End of upload logic ---
            }
        } catch {
            print("❌ Could not read contents of the main resource directory: \(error)")
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
