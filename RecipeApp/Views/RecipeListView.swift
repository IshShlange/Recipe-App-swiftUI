import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showingAddRecipe = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                        .scaleEffect(1.5)
                } else if let error = viewModel.errorText {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.loadRecipes()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(viewModel.recipes) { recipe in
                            RecipeRow(recipe: recipe, onToggleFavorite: {
                                viewModel.toggleFavorite(for: recipe)
                            })
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    if let index = viewModel.recipes.firstIndex(where: { $0.id == recipe.id }) {
                                        viewModel.deleteRecipe(at: IndexSet([index]))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    viewModel.toggleFavorite(for: recipe)
                                } label: {
                                    Label(recipe.isFavorite ? "Unfavorite" : "Favorite", 
                                          systemImage: recipe.isFavorite ? "heart.slash" : "heart")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Recipes")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingAddRecipe.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddRecipe) {
                        AddRecipeView(viewModel: viewModel)
                    }
                }
            }
            .onAppear {
                viewModel.loadRecipes()
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.title)
                    .font(.headline)
                HStack {
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(recipe.prepMinutes) min")
                        .font(.caption)
                        .padding(5)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(5)
                }
            }
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(recipe.isFavorite ? .red : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 5)
    }
}