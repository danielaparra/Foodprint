//
//  Food+Convenience.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension Food {
    @discardableResult convenience init(foodRep: FoodRep, serving: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.serving = serving
        self.caloriesPerServing = Double(foodRep.caloriesPerServing)!
        self.category = foodRep.category.rawValue
        self.gramsCo2EPerServing = Double(foodRep.gramsCo2EPerServing)!
        self.gramsCo2ForServing = serving * Double(foodRep.gramsCo2EPerServing)!
        self.name = foodRep.food
        
    }
}
