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
    @Environment(UserViewModel.self) private var userViewModel
    var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    Image(recipe.image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .blueRoundedBorder()
                        .frame(width: 300, height: 200)
                        .padding(.bottom, 25)
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
                    
                    RecipeIngridientsDetail(recipe: recipe)
                    
                    RecipeTableDetail(viewModel: viewModel, recipe: recipe)
                    
                }
            }
            if let _ = userViewModel.user {
                Button {
                    recipe.isFavorite.toggle()
                } label: {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.red)
                        .shadow(radius: 10)
                }
                .padding([.bottom, .trailing], 20)
            }
            
            
        }
//        .onAppear {
//            print("\(String(describing: userViewModel?.user))")
//        }
    }
}

private struct RecipeIngridientsDetail: View {
    var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Ингредиенты")
                .font(.title2)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            ForEach(recipe.decodeJSON(recipeElement: recipe.ingredients), id: \.self) { ingridient in
                Text("-\(ingridient)")
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


private struct RecipeTableDetail: View {
    @Bindable var viewModel: RecipeViewModel
    
    var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Рецепт")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            ForEach(Array(recipe.decodeJSON(recipeElement: recipe.steps).enumerated()), id: \.offset) {index, step in
                TextRecipeDetail(index: index, step: step,
                                 isLast: index == viewModel.countSteps(for: recipe) - 1)
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


private struct TextRecipeDetail: View {
    let index: Int
    let step: String
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top,spacing: 10) {
            ZStack(alignment: .top) {
                Circle()
                    .fill(.blue)
                    .frame(width: 15, height: 15)
                
                if !isLast {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 5)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: 15)
                }
            }
            .frame(minHeight: 20)
            
            
            Text("\(index + 1). \(step)")
                .padding(.trailing, 15)
        }
        .padding(.vertical, 3)
    }
}

