//
//  HomeViewController.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate, ChartDelegate {
    
    // MARK: - ChartDelegate
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    // MARK: - Lifecyle Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let startOfDay = calendar.startOfDay(for: Date())
        let today = calendar.component(.weekday, from: Date())
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay),
            let startOfWeek = calendar.date(byAdding: .day, value: -6, to: startOfDay) else { return }
        
        updateDailyCo2E(from: startOfDay, to: endOfDay)
        setUpWeeklyChartData(from: startOfWeek, to: endOfDay, todaysWeekday: today)
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
        let totalInGrams = totalCo2E
        let displayedNumber = totalInGrams.rounded()//Double(round(100*totalInTons)/100)
        todaysTotalCo2E.text = "\(displayedNumber) g of"
        
        let limit = (1.7 / 365 * 907184.74)
        
        if displayedNumber > limit {
            todaysTotalCo2E.textColor = .red
        }
    }
    
    private func setUpWeeklyChartData(from startOfWeek: Date, to endOfDay: Date, todaysWeekday: Int) {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        let startDayPredicate = NSPredicate(format: "date >= %@", startOfWeek as NSDate)
        let endDayPredicate = NSPredicate(format: "date <= %@", endOfDay as NSDate)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [startDayPredicate, endDayPredicate])
        fetchRequest.predicate = compoundPredicate
        
        var dayTotals: [String: Double] = [:]
        do {
            let foodEntries = try context.fetch(fetchRequest)
            
            for foodEntry in foodEntries {
                if dayTotals.keys.contains(foodEntry.sectionDate!) {
                    guard let oldValue = dayTotals[foodEntry.sectionDate!] else { return }
                    dayTotals[foodEntry.sectionDate!] = oldValue + (foodEntry.totalCo2E)
                } else {
                    dayTotals[foodEntry.sectionDate!] = foodEntry.totalCo2E
                }
            }
            print(dayTotals)
    
        } catch {
            NSLog("Error fetching the past week's food entries.")
        }
        
        var days = Array(dayTotals.keys).sorted()
//        let first = days[0]
//        days.remove(at: 0)
//        days.append(first)
//        days = days.reversed()
        
        
        print(days)

        var data: [Double] = []
        for day in days {
            data.append(dayTotals[day]!)
        }
//        let dataFirst = data[0]
//        data.remove(at: 0)
//        data.append(dataFirst)
//        data = data.reversed()
        
        print(data)
        
        buildChart(with: data, today: todaysWeekday)
    }
    
    // MARK: - Charts
    
    private func buildChart(with data: [Double], today: Int) {
        
        chart = Chart(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        chart.delegate = self
        if !subViewIsAdded {
            chartView.addSubview(chart)
            subViewIsAdded = true
        }
        var xAxis = Array(daysOfTheWeek[today..<daysOfTheWeek.endIndex])
        let secondHalf = daysOfTheWeek[0...(today-1)]
        xAxis.append(contentsOf: secondHalf)
        
        let limit = (1.7 / 365 * 907184.74)
        let series = ChartSeries(data)
        series.colors = (above: ChartColors.redColor(), below: ChartColors.greenColor(), zeroLevel: limit)
        series.area = true
        
        chart.minY = 0.0
        
        chart.xLabels = [0,1,2,3,4,5,6,7]
        chart.xLabelsFormatter = { String(Int($1)) + "days ago"}
        
        chart.add(series)
        
//        let centerX = NSLayoutConstraint(item: chart, attribute: .centerX, relatedBy: .equal, toItem: chartView, attribute: .centerX, multiplier: 1, constant: 0)
//
//        NSLayoutConstraint.activate([centerX])

    }

    // MARK: - Properties
    
    let controller = FoodEntryController()
    @IBOutlet weak var todaysTotalCo2E: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    var subViewIsAdded: Bool = false
    let vegetarianCO2eDaily = 1.7 //From tons to grams: * 907184.74
    var chart = Chart()
    var daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
}
