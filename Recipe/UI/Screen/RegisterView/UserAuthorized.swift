//
//  UserAuthorized.swift
//  Recipe
//
//  Created by Даниил Иваньков on 29.01.2025.
//

import SwiftUI

struct UserAuthorized: View {
    let user: UserModel
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            HStack {
                Text(user.name)
                Text(user.surname)
                Text("\(user.favoriteRecipeIDs?.count ?? 0) лайков")
            }
            .padding([.leading, .trailing], 20)
            .font(.title)
            Text(user.email)
                .font(.subheadline)
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 20)
            Button {
                action()
            } label: {
                Text("Выйти")
                    .padding(15)
                    .blueRoundedBorder()
            }
            .padding(.top, 15)
            .frame(maxWidth: .infinity, alignment: .center)
            

            Spacer()
        }
    }
}


#Preview {
    UserAuthorized(user: UserModel(id: UUID(), name: "Даниил", password: "123123", surname: "Ivankov", email: "Ivankovdaniil04@gmail.com"), action: {})
}
