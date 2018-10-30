//
//  FoodEntry+Convenience.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/29/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

enum MealType: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

extension FoodEntry {
    @discardableResult convenience init(mealType: MealType, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        var total = 0.0
        if let count = self.foods?.count {
            let foods = self.foods?.allObjects as! [Food]
            total = foods.compactMap { $0.gramsCo2ForServing }.reduce(0.0, +)
        }
        self.mealType = mealType.rawValue
        self.date = date
        self.totalCo2E = total
        
    }
    
}
