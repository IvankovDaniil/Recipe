//
//  RecipeApp.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import SwiftUI
import SwiftData

@main
struct RecipeApp: App {
    var sharedModelContainer: ModelContainer = {
        do {
            
            let schema = Schema([Recipe.self, UserModel.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try ModelContainer(for: schema)
        } catch let error {
            fatalError("Could not create ModelContainer: \(error.localizedDescription)") 
        }
    }()


    var body: some Scene {
        
        WindowGroup {
            let viewModel = RecipeViewModel(modelContext: sharedModelContainer.mainContext)
            MainFlow()
                .environment(\.viewModel, viewModel)
                .modelContainer(sharedModelContainer)
        }
    }
}
