//
//  FoodEntryController.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

class FoodEntryController {
    static let shared = FoodEntryController()
    
//    init() {
//        createAFoodEntry(with: .lunch)
//    }
    
    // MARK: - CRUD Methods with Core Data
    
    func createAFoodEntry(with mealType: MealType, foods: [Food] = [], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let foodEntry = FoodEntry(mealType: mealType, foods: foods, context: context)
        
        for food in foods {
            foodEntry.addToFoods(food)
        }
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving new food entry to core data.")
        }
    }
    
    func createFoodFromResults(from foodRep: FoodRep, serving: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Food {
        
        let food = Food(foodRep: foodRep, serving: serving, context: context)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving new food to core data.")
        }
        
        return food
    }
    
    // MARK: - API Search
    
    func performSearch(for searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        let url = URL(string: "https://opendata.socrata.com/resource/8nz9-yn2p.json?food=\(searchTerm.uppercased())")!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching foods with \(searchTerm): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            
            do {
                self.foodSearchResults = try jsonDecoder.decode([FoodRep].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding task representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    
    func clearfoodSearchResults() {
        foodSearchResults = []
    }
    
    func clearAddedFoods() {
        foodsAddedFromResults = []
    }
    
    var foodSearchResults: [FoodRep] = []
    var foodsAddedFromResults: [Food] = []
    
}
