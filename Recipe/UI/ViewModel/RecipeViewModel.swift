import SwiftUI
import SwiftData

enum ScreenCondition {
    case recipeScreen
    case favoriteScreen
}

@Observable
class RecipeViewModel {
    var allRecipe: [Recipe] = []
    var user: UserModel? = nil
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadRecipes()
        loadUserProfile()
    }
    //Загрузка профиля
    func loadUserProfile() {
        if let savedProfile = UserDefaults.standard.data(forKey: "user") {
            let decoder = JSONDecoder()
            if let decoderProfile = try? decoder.decode(UserModel.self, from: savedProfile) {
                self.user = decoderProfile
                return
            }
        }
        self.user = nil
    }
    //Условие для любимых и всех рецептов
    func recipeScreenCondition(condition: ScreenCondition) -> [Recipe] {
        switch condition {
        case .recipeScreen: return allRecipe
        case .favoriteScreen: return allRecipe.filter { $0.isFavorite == true }
        }
    }
    
    //Загрузка рецептов всех
    func loadRecipes() {
        Thread.detachNewThread { [self] in
            let fetchDescriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.title)])
            do {
                allRecipe = try modelContext.fetch(fetchDescriptor)
            } catch {
                print("Ошибка загрузки рецептов: \(error)")
            }
        }
    }
    //Загрузить фото
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
