import SwiftUI
import SwiftData

enum ScreenCondition {
    case recipeScreen
    case favoriteScreen
}

@Observable
class RecipeViewModel {
    var allRecipe: [Recipe] = []
    
    var isLoading = false
    
    private var modelContext: ModelContext
    private let vaporClient = VaporClient()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    //Условие для любимых и всех рецептов
    func recipeScreenCondition(condition: ScreenCondition) -> [Recipe] {
        switch condition {
        case .recipeScreen: return allRecipe
        case .favoriteScreen: return allRecipe.filter { $0.isFavorite == true }
        }
    }
    
    //Загрузка всех рецептов с сервера, происходит на main Threads
    @MainActor
    func loadRecipes() async throws {
        isLoading = true
        do {
            let response = try await vaporClient.getAllRecipe()
            
            for recipe in response {
                let ingridients = recipe.decodeJSON(recipeElement: recipe.ingredients)
                let steps = recipe.decodeJSON(recipeElement: recipe.steps)
                allRecipe.append(Recipe(id: recipe.id, title: recipe.title, ingredients: ingridients, image: recipe.image, steps: steps, rating: recipe.rating))
            }
        } catch {
            allRecipe = []
        }
        isLoading = false
    }
    
    
    //Функция для подсчета кол-во шагов
    func textForSteps(_ recipe: Recipe) -> String {
        switch countSteps(for: recipe) {
           
            
            case 1: return "1 шаг"
            case 2..<5: return "\(countSteps(for: recipe)) шага"
            default: return "\(countSteps(for: recipe)) шагов"
        }
    }
    
    func countSteps(for recipe: Recipe) -> Int { 
        return recipe.decodeJSON(recipeElement: recipe.steps).count
    }
    
    
    //Для Navigaion title
    func titleForRecipeScree(screenCondition: ScreenCondition) -> String {
        switch screenCondition {
        case .recipeScreen: return "Рецепты"
        case .favoriteScreen: return "Любимые рецепты"
        }
    }
    
    
    //Проверка условия для показа ингридиентов в мини рецепте
    func viewCondition(for recipe: Recipe, limit: Int = 3) -> [String] {
        let ingridients = recipe.decodeJSON(recipeElement: recipe.ingredients)
        return Array(ingridients.prefix(limit))
    }
    
    //Для добавления в СвифтДату рецептов, которые лайкнули, что бы иметь доступ к ним без сети
    func addRecipeToSwiftData(for recipe: Recipe) {
        do {
            if recipe.isFavorite {
                modelContext.insert(recipe)
            } else {
                modelContext.delete(recipe)
            }
            try modelContext.save()
        } catch {
            print("SomeError")
        }
    }
}

struct RecipeViewModelKey: EnvironmentKey {
    static var defaultValue: RecipeViewModel? = nil
    
    typealias Value = RecipeViewModel?

}

extension EnvironmentValues {
    var viewModel: RecipeViewModel? {
        
        get { self[RecipeViewModel.self] }
        set { self[RecipeViewModel.self] = newValue }
    }
}
