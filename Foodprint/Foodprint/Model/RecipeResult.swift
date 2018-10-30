//
//  RecipeResult.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/29/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct RecipeResult: Codable {
    let recipe: RecipeInfo
}

struct RecipeInfo: Codable {
    let id: String
    let co2Value: Int
    let infoText: String
    let eaternityAward: Bool
    let rating: String
    let indicators: Indicators
    
    enum CodingKeys: String, CodingKey {
        case id
        case co2Value
        case infoText
        case eaternityAward
        case rating, indicators
    }
}

struct Indicators: Codable {
    let vitaScore: VitaScore
    let environment: Environment
    let eaternityMenuAward: Bool
    let eaternityMenuRating: String
    let eaternityMenuPoints: Int
    
    enum CodingKeys: String, CodingKey {
        case vitaScore
        case environment
        case eaternityMenuAward
        case eaternityMenuRating
        case eaternityMenuPoints
    }
}

struct Environment: Codable {
    let animalTreatmentLabel, rainforestLabel, localLabel, seasonLabel: Bool
    let scarceWaterLiters, blueWaterLiters: Int
    let waterFootprintRating: String
    let waterFootprintAward: Bool
    
    enum CodingKeys: String, CodingKey {
        case animalTreatmentLabel
        case rainforestLabel
        case localLabel
        case seasonLabel
        case scarceWaterLiters
        case blueWaterLiters
        case waterFootprintRating
        case waterFootprintAward
    }
}

struct VitaScore: Codable {
    let vitaScorePoints: Int
    let vitaScoreRating: String
    let vitaScoreAward: Bool
    let energyKcals: Int
    let nutritionLabel: Bool
    
    enum CodingKeys: String, CodingKey {
        case vitaScorePoints
        case vitaScoreRating
        case vitaScoreAward
        case energyKcals
        case nutritionLabel
    }
}
