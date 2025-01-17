//
//  RecipeDetailScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 16.01.2025.
//

import SwiftUI
import SwiftData

struct RecipeDetailScreen: View {
    @Bindable var viewModel: RecipeViewModel
    var recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                viewModel.showImage(for: recipe)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .blueRoundedBorder()
                    .frame(width: 300, height: 200)
                    
                    
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    // Создаем тестовые данные
    let image = UIImage(named: "borsch")
    let borsch = image?.jpegData(compressionQuality: 1.0)
    let modelContainer = try! ModelContainer(for: Recipe.self)
    let modelContext = modelContainer.mainContext

    // Создаем рецепт
    let recipe = Recipe(title: "Борщ", ingredients: ["Свекла", "Капуста", "Мясо", "Картофель"], image: borsch, steps: ["Смешать в кастрюле все ингредиенты", "Варить до готовности"])
    
    // Вставляем рецепт в контекст модели
    modelContext.insert(recipe)

    // Возвращаем экран с рецептом
    return RecipeDetailScreen(viewModel: RecipeViewModel(modelContext: modelContext), recipe: recipe)
        .modelContainer(modelContainer)
}
