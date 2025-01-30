//
//  ReciptScreen.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import SwiftUI
import SwiftData

struct ReciptScreen: View {
    @State private var viewModel: RecipeViewModel
    @Binding var path: [Recipe]
    let screenCondition: ScreenCondition
    init(
        path: Binding<[Recipe]>,
        modelContext: ModelContext,
        screenCondition: ScreenCondition
    ) {
        self.screenCondition = screenCondition
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
    do {
        // Попробуем создать контейнер данных
        let modelContainer = try ModelContainer(for: Recipe.self)

        // Создаем контекст модели
        let modelContext = modelContainer.mainContext

        // Загружаем данные для теста
        var image = UIImage(named: "friedEggs")
        let friedEggs = image?.jpegData(compressionQuality: 1.0)
        image = UIImage(named: "borsch")
        let borsch = image?.jpegData(compressionQuality: 1.0)

        let recipe1 = Recipe(
            title: "Омлет",
            ingredients: ["Яйца", "Соль", "Масло"],
            image: friedEggs,
            steps: ["Взбить яйца", "Добавить соль", "Обжарить на сковородке"],
            rating: 4,
            isFavorite: false
        )

        let recipe2 = Recipe(
            title: "Борщ",
            ingredients: ["Свекла", "Капуста", "мясо", "Картофель"],
            image: borsch,
            steps: ["Смешать в кастрюле все ингредиенты", "Варить до готовности"],
            rating: 4,
            isFavorite: false
        )

        // Вставляем данные в контекст модели
        modelContext.insert(recipe1)
        modelContext.insert(recipe2)

        // Сохраняем контекст
        try modelContext.save()

        // Возвращаем ваш основной экран с моделью
        return ReciptFlow()
            .modelContainer(modelContainer)
    } catch {
        print("Ошибка при инициализации ModelContainer: \(error)")
        return Text("Ошибка инициализации данных")
    }
}






