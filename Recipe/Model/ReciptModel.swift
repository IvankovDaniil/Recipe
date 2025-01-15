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
    @Attribute var id = UUID()
    @Attribute var title: String
    @Attribute var ingredients: [String]
    @Attribute var image: Data?
    @Attribute var steps: [String]
    
    init(id: UUID = UUID(), title: String, ingredients: [String], image: Data?, steps: [String]) {
        self.id = id
        self.title = title
        self.ingredients = ingredients
        self.image = image
        self.steps = steps
    }
    
}
