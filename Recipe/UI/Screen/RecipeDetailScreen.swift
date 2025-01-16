//
//  RecipeDetailScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 16.01.2025.
//

import SwiftUI

struct RecipeDetailScreen: View {
    @Environment(\.modelContext) var modelContext
    var recipe: Recipe
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let image = UIImage(named: "borsch")
    let borsch = image?.jpegData(compressionQuality: 1.0)
    
    let recipe = Recipe(title: "Борщ", ingredients: ["Свекла", "Капуста", "Мясо", "Картофель"], image: borsch, steps: ["Смешать в кастрюле все ингредиенты", "Варить до готовности"])
    RecipeDetailScreen(recipe: recipe)
}
