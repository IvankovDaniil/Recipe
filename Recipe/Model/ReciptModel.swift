//
//  ReciptModel.swift
//  Recipe
//
//  Created by Даниил Иваньков on 15.01.2025.
//

import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    var id = UUID()
    var title: String
    var ingredients: String // Сохраняем как строку (например, JSON)
    var image: Data?
    var steps: String // Сохраняем как строку (например, JSON)
    var rating: Double = 0
    var isFavorite: Bool = false
    
    init(id: UUID = UUID(), title: String, ingredients: [String], image: Data?, steps: [String], rating: Double = 0, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.ingredients = try! JSONEncoder().encode(ingredients).base64EncodedString()
        self.image = image
        self.steps = try! JSONEncoder().encode(steps).base64EncodedString()
        self.rating = rating
        self.isFavorite = isFavorite
    }

    
    func decodeJSON(recipeElement: String) -> [String] {
        let data = Data(base64Encoded: recipeElement) ?? Data()
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
    
}
