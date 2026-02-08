import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class RecipeService {
    private let ref = Database.database().reference()
    private let recipesRef: DatabaseReference

    init() {
        recipesRef = ref.child("recipes")
    }

    // Create
    func addRecipe(_ recipe: Recipe) {
        let newRef = recipesRef.childByAutoId()
        newRef.setValue(recipe.toDictionary()) { error, _ in
            if let error = error {
                print("Error adding recipe: \(error.localizedDescription)")
            } else {
                print("Recipe added with ID: \(newRef.key ?? "unknown")")
            }
        }
    }

    // Read (Real-time listener)
    func observeRecipes(onChange: @escaping ([Recipe]) -> Void) {
        recipesRef.observe(.value) { snapshot in
            var recipes: [Recipe] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let dict = snapshot.value as? [String: Any],
                   let recipe = Recipe(id: snapshot.key, dict: dict) {
                    recipes.append(recipe)
                }
            }
            onChange(recipes)
        }
    }

    // Update (Toggle Favorite)
    func toggleFavorite(recipeId: String, isFavorite: Bool) {
        recipesRef.child(recipeId).updateChildValues(["isFavorite": isFavorite])
    }

    // Delete
    func deleteRecipe(recipeId: String) {
        recipesRef.child(recipeId).removeValue()
    }

    // Update Full Recipe
    func updateRecipe(_ recipe: Recipe) {
        recipesRef.child(recipe.id).updateChildValues(recipe.toDictionary())
    }
}