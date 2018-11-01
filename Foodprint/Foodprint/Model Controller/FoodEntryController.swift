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
    
    // MARK: - Core Data
    
    func createAFoodEntry(with mealType: MealType, foods: [Food] = [], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let foodEntry = FoodEntry(mealType: mealType, foods: foods, context: context)
        
        for food in foods {
            foodEntry.addToFoods(food)
        }
        
        saveToPersistentStore()
    }
    
    func updateFoodEntry(foodEntry: FoodEntry, mealType: MealType, with newFoods: [Food]) {
        
        foodEntry.mealType = mealType.rawValue
        newFoods.forEach { (food) in
            foodEntry.addToFoods(food)
        }
        saveToPersistentStore()
    }
    
    func deleteFoodEntryFromCoreData(foodEntry: FoodEntry) {
        CoreDataStack.shared.mainContext.delete(foodEntry)
        saveToPersistentStore()
    }
    
    func createFoodFromResults(from foodRep: FoodRep, serving: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Food {
        
        let food = Food(foodRep: foodRep, serving: serving, context: context)
        
        saveToPersistentStore()
        
        return food
    }
    
    func deleteFoodFromCoreData(food: Food) {
        CoreDataStack.shared.mainContext.delete(food)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - API Search
    
    func performSearch(for searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        let url = baseURL.appendingPathExtension("json")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let parameters = ["food": searchTerm]
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
//        let url = URL(string: "https://opendata.socrata.com/resource/8nz9-yn2p.json?food=\(searchTerm.uppercased())")!
//    print(requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
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
    
    func deleteFood(at indexPath: IndexPath) {
        foodsAddedFromResults.remove(at: indexPath.row)
    }
    
    func clearfoodSearchResults() {
        foodSearchResults = []
    }
    
    func clearAddedFoods() {
        foodsAddedFromResults = []
    }
    
    var foodSearchResults: [FoodRep] = []
    var foodsAddedFromResults: [Food] = []
    let baseURL = URL(string: "https://opendata.socrata.com/resource/8nz9-yn2p")!
}
