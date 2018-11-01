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
        
        guard let foodsAddedTVC = children.first as? FoodsAddedTableViewController else { return }
        self.foodsAddedTVC = foodsAddedTVC
        foodSearchBar.delegate = self
        foodResultsTableView.isHidden = true
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        foodEntryController.clearAddedFoods()
        foodEntryController.clearfoodSearchResults()
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let foodEntry = foodEntry else {
            title = "Add new meal"
            dateLabel.text = Date().formatted()
            return
        }
        
        title = "View your meal"
        dateLabel.text = foodEntry.date?.formatted()
        let array = foodEntry.foods?.allObjects as! [Food]
        foodEntryController.foodsAddedFromResults = array
        
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
            let array = foodEntry.foods?.allObjects as! [Food]
            
            let difference = compare(oldArray: array, to: foodEntryController.foodsAddedFromResults)
            foodEntryController.updateFoodEntry(foodEntry: foodEntry, mealType: mealType, with: difference)
        } else {
            foodEntryController.createAFoodEntry(with: mealType, foods: foodEntryController.foodsAddedFromResults)
        }
        
        foodEntryController.clearAddedFoods()
        foodEntryController.clearfoodSearchResults()
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - FoodResultCellDelegate
    
    func addFoodResult(from cell: FoodResultTableViewCell) {
        guard let foodResult = cell.foodResult,
            let serving = cell.selectedServing else { return }
        
        let food = foodEntryController.createFoodFromResults(from: foodResult, serving: serving)
        foodEntryController.foodsAddedFromResults.append(food)
        foodsAddedTVC?.tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = foodSearchBar.text else { return }
        
        foodResultsTableView.isHidden = false
        
        foodEntryController.performSearch(for: searchTerm) { (_) in
            DispatchQueue.main.async {
                self.foodResultsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodEntryController.foodSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodResultCell", for: indexPath) as? FoodResultTableViewCell else { return UITableViewCell()}
        
        cell.foodResult = foodEntryController.foodSearchResults[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Private Methods
    
    private func compare(oldArray: [Food], to newArray: [Food]) -> [Food] {
        let difference: [Food] = newArray.compactMap { (newArrayElement) in
            if !oldArray.contains(newArrayElement) {
                return newArrayElement
            }
            return nil
        }
        return difference
    }

    // MARK: - Properties
    
    var foodEntry: FoodEntry? {
        didSet {
            if isViewLoaded { updateViews() }
        }
    }

    let foodEntryController = FoodEntryController.shared
    var foodsAddedTVC: FoodsAddedTableViewController?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mealTypesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var foodSearchBar: UISearchBar!
    @IBOutlet weak var foodResultsTableView: UITableView!
}
