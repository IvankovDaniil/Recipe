//
//  File.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 24.01.2025.
//

import Foundation
import Fluent
import Vapor

final class Recipe: Content, Model, @unchecked Sendable {
    static let schema: String = "recipes"
    init() {}
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "steps")
    var steps: String
    
    @Field(key: "ingredients")
    var ingredients: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "rating")
    var rating: Double?
    
    @Siblings(through: FavRecipe.self, from: \.$recipe, to: \.$user)
    var user: [User]
    
    init(id: UUID? = nil, title: String, steps: String, ingredients: String, image: String, rating: Double? = nil) {
        self.id = id
        self.title = title
        self.steps = steps
        self.ingredients = ingredients
        self.image = image
        self.rating = rating
    }
}

