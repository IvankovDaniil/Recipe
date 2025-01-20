import SwiftUI
import SwiftData

enum ScreenCondition {
    case recipeScreen
    case favoriteScreen
}

@Observable
class RecipeViewModel {
    var allRecipe: [Recipe] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadRecipes()
    }
    
    func recipeScreenCondition(condition: ScreenCondition) -> [Recipe] {
        switch condition {
        case .recipeScreen: return allRecipe
        case .favoriteScreen: return allRecipe.filter { $0.isFavorite == true }
        }
    }
    
    
    func loadRecipes() {
        let fetchDescriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.title)])
        do {
            allRecipe = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Ошибка загрузки рецептов: \(error)")
        }
    }
    
    func showImage(for recipe: Recipe) -> Image {
        if let imageResource = recipe.image, let uiImage = UIImage(data: imageResource) {
            return Image(uiImage: uiImage)
        }
        return Image("")
    }
    
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
    
    func titleForRecipeScree(screenCondition: ScreenCondition) -> String {
        switch screenCondition {
        case .recipeScreen: return "Рецепты"
        case .favoriteScreen: return "Любимые рецепты"
        }
    }
    
    func viewCondition(for recipe: Recipe, limit: Int = 3) -> [String] {
        let ingridients = recipe.decodeJSON(recipeElement: recipe.ingredients)
        return Array(ingridients.prefix(limit))
    }
}

