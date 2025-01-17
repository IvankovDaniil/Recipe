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
    @State private var viewModel: RecipeViewModel
    @Binding var path: [Recipe]
    
    init(path: Binding<[Recipe]>, modelContext: ModelContext) {
        
        _viewModel = State(wrappedValue: RecipeViewModel(modelContext: modelContext))
        _path = path
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 150, maximum: 200)),
                    GridItem(.flexible(minimum: 150, maximum: 200))
                ]
            ) {
                ForEach(viewModel.allRecipe) { recipe in
                    Button {
                        path.append(recipe)
                    } label: {
                        RecipeView(viewModel: viewModel, recipe: recipe)
                    }
                }
            }

        }
        .navigationDestination(for: Recipe.self, destination: { recipe in
            RecipeDetailScreen(viewModel: viewModel, recipe: recipe)
        })
        .navigationTitle("Рецепты")
    }
    
}

private struct RecipeView: View {
    
    @State private var isPressed = false  // Состояние для отслеживания нажатия
    @Bindable var viewModel: RecipeViewModel
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ShortIntroductionRecipe(viewModel: viewModel, recipe: recipe)
            
            Image(systemName: isPressed ? "arrowshape.forward.fill" : "arrowshape.forward")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(10)
                .foregroundColor(.blue)
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
}

struct ShortIntroductionRecipe: View {
    @Bindable var viewModel: RecipeViewModel
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            viewModel.showImage(for: recipe)
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.bottom, 5)
            Text(recipe.title)
                .font(Font.custom("Montserrat", size: 25))
            Text("Для блюда вам понадобится:")
                .font(Font.custom("Montserrat", size: 14))
                .padding(.bottom, 5)
            ForEach(viewModel.viewCondition(for: recipe), id: \.self) { ingredient in
                Text("\(ingredient)")
                    .lineLimit(1)
                    .font(Font.custom("Montserrat", size: 14))
            }
        }
        .foregroundStyle(.black)
        .padding(20)
        .blueRoundedBorder()
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
    try! modelContext.save()
    //

    return ReciptFlow()
        .modelContainer(modelContainer)
        .onAppear{
            
        }
    
}


//#Preview {
//    let image = UIImage(named: "friedEggs")
//    let friedEggs =  image?.jpegData(compressionQuality: 1.0)!
//    
//    RecipeView(recipe: Recipe(title: "Омлет", ingredients: ["Яйца", "Соль", "Масло"], image: friedEggs, steps: ["Взбить яйца", "Добавить соль", "Обжарить на сковородке"]))
//}

