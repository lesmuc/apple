//
//  ItemView.swift
//  AppleRepositories
//
//  Created by Udo Von Eynern on 16.06.22.
//

import SwiftUI

struct ItemView: View {
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repository.name)
                .font(.system(size: 20))
                .foregroundColor(Color.blue)
            if repository.description != nil {
                Text(repository.description ?? "")
                    .font(.system(size: 14))
            }
            HStack(alignment: .center, spacing: 2) {
                if let createdAtString = repository.createdAtString {
                    Text(createdAtString)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(String(repository.stargazersCount))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Image(systemName: "star").foregroundColor(.yellow)
            }

        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(repository: Repository(id: 23, name: "Name", description: "Description", stargazersCount: 30, createdAt: Date()))
    }
}
