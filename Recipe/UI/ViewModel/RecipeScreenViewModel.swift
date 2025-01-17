import SwiftUI
import SwiftData

@Observable
class RecipeViewModel {
    var allRecipe: [Recipe] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadRecipes()
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
        switch recipe.steps.count {
            
            case 1: return "1 шаг"
            case 2..<5: return "\(recipe.steps.count) шага"
            default: return "\(recipe.steps.count) шагов"
        }
    }
    
    func countSteps(for recipe: Recipe) -> Int { 
        return recipe.steps.count
    }
    
    func viewCondition(for recipe: Recipe, limit: Int = 3) -> [String] {
        let ingridients = recipe.decodeJSON(recipeElement: recipe.ingredients)
        return Array(ingridients.prefix(limit))
    }
}

