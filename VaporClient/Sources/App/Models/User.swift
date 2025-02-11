//
//  File.swift
//  VaporClient
//
//  Created by Даниил Иваньков on 24.01.2025.
//

import Foundation
import Fluent
import Vapor


final class User: Content, Model, @unchecked Sendable {
    init() {
    }
    
    static let schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String?
    
    @Field(key: "surname")
    var surname: String?
    
    @Field(key: "email")
    var email: String?
    
    @Field(key: "password")
    var password: String?
    
    @Siblings(through: FavRecipe.self, from: \.$user, to: \.$recipe)
    var favRecipe: [Recipe]
    
    init(id: UUID? = nil, name: String?, surname: String?, email: String?, password: String?) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
    }
}
