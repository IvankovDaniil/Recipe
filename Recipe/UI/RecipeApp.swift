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
            // Убедитесь, что схема и конфигурация правильные
            let schema = Schema([Recipe.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            // Попробуйте использовать инициализацию без конфигурации
            return try ModelContainer(for: schema)
        } catch let error {
            fatalError("Could not create ModelContainer: \(error.localizedDescription)") // Уточняем ошибку
        }
    }()

    var body: some Scene {
        
        WindowGroup {
            MainFlow()
                .onAppear {
                    loadInitialData(modelContext: sharedModelContainer.mainContext)
                }
                .modelContainer(sharedModelContainer)
        }
    }
    
    func loadInitialData(modelContext: ModelContext) {
        
        let fetchDescriptor = FetchDescriptor<Recipe>()
        
        if let recipeModel = try? modelContext.fetch(fetchDescriptor), !recipeModel.isEmpty {
            return
        }
        
        if let image = UIImage(named: "friedEggs") {
            let imageData =  image.jpegData(compressionQuality: 1.0)
            
            let recipe = [
                Recipe(
                    title: "Омлет",
                    ingredients: ["Яйца", "Соль", "Масло"],
                    image: imageData,
                    steps: ["Взбить яйца", "Добавить соль", "Обжарить на сковородке"],
                    rating: 4,
                    isFavorite: false
                ),
                Recipe(
                    title: "Борщ",
                    ingredients: ["Свекла", "Капуста", "мясо", "Картофель"],
                    image: imageData,
                    steps: ["Смешать в кастрюле все ингредиенты", "Варить до готовности"],
                    rating: 4,
                    isFavorite: false
                )
            ]
            
            for  recipeItem in recipe {
                modelContext.insert(recipeItem)
            }
            
            do {
                try modelContext.save()
            } catch {
                print("Ошибка при сохранении данных")
            }
        }
    }
}
