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
    
    func viewCondition(for recipe: Recipe, limit: Int = 3) -> [String] {
        return Array(recipe.ingredients.prefix(limit))
    }
}

