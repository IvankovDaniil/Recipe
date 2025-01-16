import SwiftUI
import SwiftData

@Observable
class RecipeViewModel: ObservableObject {
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
}

