//
//  Repository.swift
//  AppleRepositories
//
//  Created by Udo Von Eynern on 16.06.22.
//

import Foundation
import SwiftUI

struct Repository: Hashable, Decodable {
    var id: Int64
    var name: String
    var description: String?
    var stargazersCount: Int = 0
    var createdAt: Date?
    
    var createdAtString: String? {
        if let createdAt = createdAt {
            return DateFormatter.mediumDateFormatter.string(from: createdAt)
        } else {
            return nil
        }
    }
}
