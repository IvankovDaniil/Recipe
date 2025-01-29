import Foundation
import SwiftData

@Model
class UserModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var password: String
    var surname: String
    var email: String
    var favoriteRecipeIDs: [UUID] = []
    
    init(id: UUID, name: String, password: String, surname: String, email: String, favoriteRecipeIDs: [UUID]) {
        self.id = id
        self.name = name
        self.password = password
        self.surname = surname
        self.email = email
        self.favoriteRecipeIDs = favoriteRecipeIDs
    }
}
