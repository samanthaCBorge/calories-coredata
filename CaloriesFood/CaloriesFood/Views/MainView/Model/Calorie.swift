//
//  Food.swift
//  CaloriesFood
//
//  Created by Samantha Cruz on 7/2/24.
//

import Foundation

struct Calorie: Codable, Hashable {
    var id: String
    var name: String
    var calories: Double
    var date: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case calories
        case date
    }
}

extension Calorie: Comparable {
    static func <(lhs: Calorie, rhs: Calorie) -> Bool {
        lhs.name < rhs.name
    }
}

