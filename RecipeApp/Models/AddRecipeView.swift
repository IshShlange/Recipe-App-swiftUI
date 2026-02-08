import Foundation

struct Recipe: Identifiable, Codable {
    var id: String
    var title: String
    var cuisine: String
    var prepMinutes: Int
    var difficulty: String
    var ingredients: [String]
    var steps: [String]
    var isFavorite: Bool
    var createdAt: TimeInterval

    init(id: String = UUID().uuidString, 
         title: String, 
         cuisine: String, 
         prepMinutes: Int, 
         difficulty: String, 
         ingredients: [String], 
         steps: [String], 
         isFavorite: Bool = false, 
         createdAt: TimeInterval = Date().timeIntervalSince1970) {
        self.id = id
        self.title = title
        self.cuisine = cuisine
        self.prepMinutes = prepMinutes
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.steps = steps
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    // Для записи в Firebase
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "cuisine": cuisine,
            "prepMinutes": prepMinutes,
            "difficulty": difficulty,
            "ingredients": ingredients,
            "steps": steps,
            "isFavorite": isFavorite,
            "createdAt": createdAt
        ]
    }

    // Для чтения из Firebase
    init?(id: String, dict: [String: Any]) {
        guard let title = dict["title"] as? String,
              let cuisine = dict["cuisine"] as? String,
              let prepMinutes = dict["prepMinutes"] as? Int,
              let difficulty = dict["difficulty"] as? String,
              let ingredients = dict["ingredients"] as? [String],
              let steps = dict["steps"] as? [String],
              let isFavorite = dict["isFavorite"] as? Bool,
              let createdAt = dict["createdAt"] as? TimeInterval else {
            return nil
        }
        self.id = id
        self.title = title
        self.cuisine = cuisine
        self.prepMinutes = prepMinutes
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.steps = steps
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
}