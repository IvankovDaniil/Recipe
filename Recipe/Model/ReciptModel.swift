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
    var ingredients: [String]
    var image: Data?
    var steps: [String]
    
    init(title: String, ingredients: [String], image: Data?, steps: [String]) {
        self.title = title
        self.ingredients = ingredients
        self.image = image
        self.steps = steps
    }
    
}
