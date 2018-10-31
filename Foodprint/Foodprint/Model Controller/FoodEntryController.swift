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
    
    init() {
        createAFoodEntry(with: .lunch)
    }
    
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
    
    func createFood(from foodRep: FoodRep, serving: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Food {
        
        let food = Food(foodRep: foodRep, serving: serving, context: context)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving new food to core data.")
        }
        
        return food
    }
    
}
