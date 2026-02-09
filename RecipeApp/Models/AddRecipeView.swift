import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RecipeViewModel

    @State private var title = ""
    @State private var cuisine = ""
    @State private var prepMinutes = ""
    @State private var selectedDifficulty = "Easy"
    @State private var ingredients: [String] = ["", ""]
    @State private var steps: [String] = ["", ""]
    @State private var showingError = false

    let difficulties = ["Easy", "Medium", "Hard"]

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !cuisine.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(prepMinutes) ?? 0 > 0 &&
        ingredients.filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty }).count >= 2 &&
        steps.filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty }).count >= 2
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Recipe Title", text: $title)
                    TextField("Cuisine", text: $cuisine)
                    TextField("Prep Minutes", text: $prepMinutes)
                        .keyboardType(.numberPad)
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { difficulty in
                            Text(difficulty)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Ingredients (at least 2)")) {
                    ForEach(0..<ingredients.count, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $ingredients[index])
                    }
                    Button("Add Ingredient") {
                        ingredients.append("")
                    }
                }

                Section(header: Text("Steps (at least 2)")) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        TextField("Step \(index + 1)", text: $steps[index])
                    }
                    Button("Add Step") {
                        steps.append("")
                    }
                }

                Section {
                    Button("Save Recipe") {
                        saveRecipe()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isFormValid)
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill all required fields correctly.")
            }
        }
    }

    private func saveRecipe() {
        guard let prepMinutesInt = Int(prepMinutes), prepMinutesInt > 0 else { return }

        let filteredIngredients = ingredients.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let filteredSteps = steps.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        guard filteredIngredients.count >= 2, filteredSteps.count >= 2 else {
            showingError = true
            return
        }

        let newRecipe = Recipe(
            title: title,
            cuisine: cuisine,
            prepMinutes: prepMinutesInt,
            difficulty: selectedDifficulty,
            ingredients: filteredIngredients,
            steps: filteredSteps
        )

        viewModel.addRecipe(newRecipe)
        dismiss()
    }

}
