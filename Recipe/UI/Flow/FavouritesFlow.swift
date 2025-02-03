import SwiftUI

struct FavouritesFlow: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = [Recipe]()
    
    var body: some View {
        NavigationStack(path: $path) {
            ReciptScreen(path: $path, screenCondition: .favoriteScreen)
        }
    }
}

#Preview {
    ReciptFlow()
}
