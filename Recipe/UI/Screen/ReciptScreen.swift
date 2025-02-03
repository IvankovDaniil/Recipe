//
//  ReciptScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import SwiftUI
import SwiftData

struct ReciptScreen: View {
    @Environment(\.viewModel) private var viewModel: RecipeViewModel?
    @Binding var path: [Recipe]
    let screenCondition: ScreenCondition
    init(
        path: Binding<[Recipe]>,
        screenCondition: ScreenCondition
    ) {
        self.screenCondition = screenCondition
        _path = path
    }
    
    var body: some View {
       
        if let viewModel = viewModel {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 150, maximum: .infinity)),
                       
                    ]
                ) {
                    ForEach(viewModel.recipeScreenCondition(condition: screenCondition)) { recipe in
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
            .navigationTitle(viewModel.titleForRecipeScree(screenCondition: screenCondition))
        } else {
            Text("Ошибка подключения")
        }
        
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
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )

    }
}

struct ShortIntroductionRecipe: View {
    @Bindable var viewModel: RecipeViewModel
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: recipe.image)) { result in
                result.image?
                    .resizable()
            }
                .frame(width: 200, height: 160)
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
    let modelContext = modelContainer.mainContext
    let viewModel = RecipeViewModel(modelContext: modelContext)
    
    return ReciptFlow()
        .environment(\.viewModel, viewModel)
        .modelContainer(modelContainer)
}





