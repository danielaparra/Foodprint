//
//  MealSnackDetailViewController.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class MealSnackDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FoodResultCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        foodSearchBar.delegate = self
        foodResultsTableView.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let foodEntry = foodEntry else {
            title = "Add new meal"
            dateLabel.text = Date().formatted()
            return
        }
        
        dateLabel.text = foodEntry.date?.formatted()
        //foods = foodEntry.foods
        
        var index = 0
        switch foodEntry.mealType {
        case MealType.breakfast.rawValue:
            index = 0
        case MealType.lunch.rawValue:
            index = 1
        case MealType.dinner.rawValue:
            index = 2
        case MealType.snack.rawValue:
            index = 3
        default:
            break
        }
        
        mealTypesSegmentedControl.selectedSegmentIndex = index
        
    }
    
    @IBAction func saveFoodEntry(_ sender: Any) {
        
        var mealType: MealType!
        switch mealTypesSegmentedControl.selectedSegmentIndex {
        case 0:
            mealType = MealType.breakfast
        case 1:
            mealType = MealType.lunch
        case 2:
            mealType = MealType.dinner
        case 3:
            mealType = MealType.snack
        default:
            break
        }
        
        if let foodEntry = foodEntry {
            //update entry
        } else {
            foodEntryController?.createAFoodEntry(with: mealType, foods: self.foods)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - FoodResultCellDelegate
    
    func addFoodResult(from cell: FoodResultTableViewCell) {
        guard let foodResult = cell.foodResult else { return }
        
        let food = foodEntryController?.createFood(from: foodResult, serving: 1.0)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = foodSearchBar.text else { return }
        
        foodResultsTableView.isHidden = false
        
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodResultCell", for: indexPath) as? FoodResultTableViewCell else { return UITableViewCell()}
        
        cell.foodResult = foodResults[indexPath.row]
        cell.delegate = self
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // MARK: - Properties
    
    var foodEntry: FoodEntry?
    var foodEntryController: FoodEntryController?
    var foodResults: [FoodRep] = [FoodRep()] //for testing only
    var foods: [Food] = []
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mealTypesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var foodSearchBar: UISearchBar!
    @IBOutlet weak var foodResultsTableView: UITableView!
}
