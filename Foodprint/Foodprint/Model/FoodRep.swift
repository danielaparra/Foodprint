//
//  Food.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/29/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

enum Category: String, Codable {
    case dairy = "Dairy"
    case fruit = "Fruit"
    case grain = "Grain"
    case meat = "Meat"
    case nutSeedLegume = "Nut/Seed/Legume"
    case oil = "Oil"
    case other = "Other"
    case vegetable = "Vegetable"
}

struct FoodRep: Codable {
    let gramsCo2EPerServing: String
    let caloriesPerServing: String
    let category: Category
    let food: String
    
    enum CodingKeys: String, CodingKey {
        case gramsCo2EPerServing
        case caloriesPerServing
        case category
        case food
    }
}
