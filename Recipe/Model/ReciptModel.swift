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
    var ingredients: String
    var image: String
    var steps: String
    var rating: Double = 0
    var isFavorite: Bool = false
    
    init(id: UUID = UUID(), title: String, ingredients: [String], image: String, steps: [String], rating: Double = 0, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.ingredients = ingredients.map { $0 + "   " }.joined()
        self.image = image
        self.steps = steps.map { $0 + "   " }.joined()
        self.rating = rating
        self.isFavorite = isFavorite
    }

    
    func decodeJSON(recipeElement: String) -> [String] {
        return recipeElement.components(separatedBy: "   ").dropLast()
    }
    
}
