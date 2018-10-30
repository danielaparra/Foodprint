//
//  Food.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/29/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

typealias Foods = [Food]

struct Food: Codable {
    let priceUnit, price1997, gramsCo2EPerServing, servingSize: String
    let gramsCo2EPerKcal, ssUnit, pricePerServing, caloriesPerServing: String
    let category: Category
    let food: String
    
    enum CodingKeys: String, CodingKey {
        case priceUnit = "price_unit"
        case price1997 = "price_1997"
        case gramsCo2EPerServing = "grams_co2e_per_serving"
        case servingSize = "serving_size"
        case gramsCo2EPerKcal = "grams_co2e_per_kcal"
        case ssUnit = "ss_unit"
        case pricePerServing = "price_per_serving"
        case caloriesPerServing = "calories_per_serving"
        case category, food
    }
}

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
