//
//  HomeViewController.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData
import Charts

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate, ChartViewDelegate {
    
    // MARK: - Lifecyle Functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let startOfDay = calendar.startOfDay(for: Date())
        let today = calendar.component(.weekday, from: Date())
        print(today)
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
        let totalInTons = totalCo2E / 907184.74
        let displayedNumber = Double(round(100*totalInTons)/100)
        todaysTotalCo2E.text = "\(displayedNumber) tons of"
        
        if displayedNumber > 1.71 {
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
            print(foodEntries)
            
            
            for foodEntry in foodEntries {
                if dayTotals.keys.contains(foodEntry.sectionDate!) {
                    guard let oldValue = dayTotals[foodEntry.sectionDate!] else { return }
                    dayTotals[foodEntry.sectionDate!] = oldValue + foodEntry.totalCo2E
                } else {
                    dayTotals[foodEntry.sectionDate!] = foodEntry.totalCo2E
                }
            }
    
        } catch {
            NSLog("Error fetching the past week's food entries.")
        }
        
        let days = Array(dayTotals.keys).sorted()
        var data: [Double] = []
        for day in days {
            data.append(dayTotals[day]!)
        }
        
        buildChart(with: data, today: todaysWeekday)
    }
    
    // MARK: - Charts
    
    private func buildChart(with data: [Double], today: Int) {
        
        lineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        
        lineChartView.delegate = self
        lineChartView.chartDescription?.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 2.5)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelCount = 7
        
        var xAxis = Array(daysOfTheWeek[today..<daysOfTheWeek.endIndex])
        let secondHalf = daysOfTheWeek[0...(today-1)]
        xAxis.append(contentsOf: secondHalf)
        print(xAxis)
        print(data)
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<data.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: data[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "grams of CO2 equivalent")
        chartDataSet.setColor(.black)
        chartDataSet.drawFilledEnabled = true
        
        let gradientColors = [ChartColorTemplates.colorFromString("#7bd195").cgColor,
                              ChartColorTemplates.colorFromString("#ffffff").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        chartDataSet.fillAlpha = 1
        chartDataSet.fill = Fill(linearGradient: gradient, angle: 90)
        chartDataSet.mode = (chartDataSet.mode == .cubicBezier) ? .linear : .cubicBezier
        
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
        
        let ll = ChartLimitLine(limit: 907184.74, label: "1 ton")
        lineChartView.leftAxis.addLimitLine(ll)
        
        if !self.subViewIsAdded {
            self.chartView.addSubview(lineChartView)
            self.subViewIsAdded = true
        }
        
        
//        let centerX = NSLayoutConstraint(item: lineChartView, attribute: .centerX, relatedBy: .equal, toItem: chartView, attribute: .centerX, multiplier: 1, constant: 0)
//
//        NSLayoutConstraint.activate([centerX])
        
        
    }

    // MARK: - Properties
    
    let controller = FoodEntryController()
    @IBOutlet weak var todaysTotalCo2E: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    var subViewIsAdded: Bool = false
    let vegetarianCO2eDaily = 1.7 //From tons to grams: * 907184.74
    var lineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
}
