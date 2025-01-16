//
//  ReciptScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import SwiftUI
import SwiftData

struct ReciptScreen: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel: RecipeViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: RecipeViewModel(modelContext: modelContext))
    }
        
    var body: some View {
        ScrollView {
            HStack {
                ForEach(viewModel.allRecipe) { recipe in
                    RecipeView(recipe: recipe)
                }
            }
        }

        .navigationTitle("Рецепты")
    }
    
}

private struct RecipeView: View {
    let recipe: Recipe
    @State private var isPressed = false // Состояние для отслеживания нажатия
    
    var body: some View {
        Button {
            
        } label: {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    showImage(for: recipe)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 5)
                    Text(recipe.title)
                        .font(Font.custom("Montserrat", size: 25))
                    Text("Для блюда вам понадобится:")
                        .font(Font.custom("Montserrat", size: 14))
                        .padding(.bottom, 5)
                    ForEach(Array(recipe.ingredients.prefix(3).enumerated()), id: \.offset) {index, ingredient in
                        Text("\(index + 1). \(ingredient)")
                            .lineLimit(1)
                            .font(Font.custom("Montserrat", size: 14))
                    }
                    
                    
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).stroke(.blue, lineWidth: 4).shadow(color: .blue, radius: 5, x: 3, y: 3))
                
                Image(systemName: isPressed ? "arrowshape.forward.fill" : "arrowshape.forward")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(10)
                    .foregroundColor(.blue)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0) // Используем DragGesture для обработки нажатия
                .onChanged { _ in
                    isPressed = true // Меняем состояние нажатия
                }
                .onEnded { _ in
                    isPressed = false // Возвращаем состояние обратно
                }
        )
    }

    func showImage(for recipe: Recipe) -> Image {
        if let imageResource = recipe.image, let uiImage = UIImage(data: imageResource) {
            return Image(uiImage: uiImage)
        }
        return Image("")
    }
}

#Preview {
    let modelContainer = try! ModelContainer(for: Recipe.self)
    
    var image = UIImage(named: "friedEggs")
    let friedEggs =  image?.jpegData(compressionQuality: 1.0)!
    image = UIImage(named: "borsch")
    let borsch =  image?.jpegData(compressionQuality: 1.0)!

    let recipe1 = Recipe(title: "Омлет", ingredients: ["Яйца", "Соль", "Масло"], image: friedEggs, steps: ["Взбить яйца", "Добавить соль", "Обжарить на сковородке"])
    let recipe2 = Recipe(title: "Борщ", ingredients: ["Свекла", "Капуста", "Мясо", "Картофель"], image: borsch, steps: ["Смешать в кастрюле все ингредиенты", "Варить до готовности"])
    
    let modelContext = modelContainer.mainContext
    modelContext.insert(recipe1)
    modelContext.insert(recipe2)

    return ReciptScreen(modelContext: modelContext)
                .modelContainer(modelContainer)
}


#Preview {
    let image = UIImage(named: "friedEggs")
    let friedEggs =  image?.jpegData(compressionQuality: 1.0)!
    
    RecipeView(recipe: Recipe(title: "Омлет", ingredients: ["Яйца", "Соль", "Масло"], image: friedEggs, steps: ["Взбить яйца", "Добавить соль", "Обжарить на сковородке"]))
}
