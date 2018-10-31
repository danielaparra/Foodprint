//
//  HomeViewController.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Lifecyle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let startOfDay = calendar.startOfDay(for: Date())
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }
        
        updateDailyCo2E(from: startOfDay, to: endOfDay)

    }
    
    // MARK: - Private Methods
    
    private func updateDailyCo2E(from startOfDay: Date, to endOfDay: Date) {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        let startDayPredicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        let endDayPredicate = NSPredicate(format: "date >= %@", endOfDay as NSDate)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [startDayPredicate, endDayPredicate])
        fetchRequest.predicate = compoundPredicate
        
        var foodEntries: [FoodEntry] = []
        do {
            foodEntries = try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching today's food entries.")
        }
        
        let totalCo2E = foodEntries.compactMap { $0.totalCo2E }.reduce(0.0, +)
        todaysTotalCo2E.text = "\(totalCo2E) g"
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMealSnack" {
            guard let destinationVC = segue.destination as? MealSnackDetailViewController else { return }
            
            destinationVC.foodEntryController = foodEntryController
            
        } else if segue.identifier == "ViewFoodDiary" {
            guard let destinationVC = segue.destination as? MyFoodDiaryTableViewController else { return }
            
            destinationVC.foodEntryController = foodEntryController
        }
    }

    // MARK: - Properties
    
    let foodEntryController = FoodEntryController()
    @IBOutlet weak var todaysTotalCo2E: UILabel!
    @IBOutlet weak var chartView: UIView!
    
}
