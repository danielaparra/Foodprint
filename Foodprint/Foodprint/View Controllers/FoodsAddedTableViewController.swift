//
//  FoodsAddedTableViewController.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class FoodsAddedTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodEntryController.shared.foodsAddedFromResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)

        let food = FoodEntryController.shared.foodsAddedFromResults[indexPath.row]
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = "\(food.serving) serving(s)"

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = FoodEntryController.shared.foodsAddedFromResults[indexPath.row]
            FoodEntryController.shared.deleteFoodFromCoreData(food: food)
            tableView.deleteRows(at: [indexPath], with: .fade)
            FoodEntryController.shared.deleteFood(at: indexPath)
        }
    }

}
