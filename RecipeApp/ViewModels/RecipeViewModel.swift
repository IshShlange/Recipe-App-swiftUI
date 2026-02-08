import Foundation
import Combine

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorText: String? = nil

    private let recipeService = RecipeService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadRecipes()
    }

    func loadRecipes() {
        isLoading = true
        recipeService.observeRecipes { [weak self] recipes in
            self?.recipes = recipes
            self?.isLoading = false
        }
    }

    func addRecipe(_ recipe: Recipe) {
        recipeService.addRecipe(recipe)
    }

    func toggleFavorite(for recipe: Recipe) {
        let newFavoriteState = !recipe.isFavorite
        recipeService.toggleFavorite(recipeId: recipe.id, isFavorite: newFavoriteState)
    }

    func deleteRecipe(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let recipe = recipes[index]
            recipeService.deleteRecipe(recipeId: recipe.id)
        }
    }
}