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
                    .padding(.bottom, 30)
                    
                VStack(spacing: 0) {
                    Text(recipe.title)
                        .font(.title)
                        .padding([.top, .bottom], 5)
                    Text("Приготовим за \(viewModel.textForSteps(recipe))")
                        .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity)
                .blueRoundedBorder()
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 20, trailing: 50))
                
                VStack(spacing: 0) {
                    Text("Ингредиенты")
                        .font(.title2)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    ForEach(recipe.ingredients, id: \.self) { ingridient in
                        Text("-\(ingridient)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 0))
                }
                .padding([.top, .bottom], 5)
                .frame(maxWidth: .infinity)
                .blueRoundedBorder()
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 20, trailing: 50))
                    
                VStack(alignment: .leading, spacing: 0) {
                    Text("Рецепт")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) {index, steps in
                        Text("\(index + 1). \(steps)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 0))
                }
                .padding([.top, .bottom], 5)
                .frame(maxWidth: .infinity)
                .blueRoundedBorder()
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 20, trailing: 50))
                
            }
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
