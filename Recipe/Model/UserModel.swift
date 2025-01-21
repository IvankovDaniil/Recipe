import Foundation

struct UserModel: Identifiable, Decodable {
    var id: UUID = UUID()
    var name: String
    var password: String
    var surname: String
    var email: String
    var avatarURL: String?
    var favoriteRecipeIDs: [UUID] = []
}
