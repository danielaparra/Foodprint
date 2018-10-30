//
//  Recipe.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/29/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct RecipeEncode: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let titles: [Language]
    let author, date, location: String
    let servings: Int
    let instructions: [Language]
    let ingredients: [Language]
}

struct Ingredient: Codable {
    let id, type: String
    let names: [Language]
    let amount: Int
    let unit, origin, transport, production: String
    let processing, conservation, packaging: String
}

struct Language: Codable {
    let language, value: String
}
