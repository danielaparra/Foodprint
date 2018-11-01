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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        let endDayPredicate = NSPredicate(format: "date <= %@", endOfDay as NSDate)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [startDayPredicate, endDayPredicate])
        fetchRequest.predicate = compoundPredicate
        
        var foodEntries: [FoodEntry] = []
        do {
            foodEntries = try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching today's food entries.")
        }
        
        let totalCo2E = foodEntries.compactMap { $0.totalCo2E }.reduce(0.0, +)
        let roundedNumber = totalCo2E.rounded()
        todaysTotalCo2E.text = "\(roundedNumber) g"
    }

    // MARK: - Properties
    
    @IBOutlet weak var todaysTotalCo2E: UILabel!
    @IBOutlet weak var chartView: UIView!
    
}
