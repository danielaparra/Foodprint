//
//  SearchFoodsViewController.swift
//  Foodprint
//
//  Created by Daniela Parra on 5/23/19.
//  Copyright © 2019 Daniela Parra. All rights reserved.
//

import UIKit

class SearchFoodsViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = foodSearchBar.text else { return }
        
//        foodResultsTableView.isHidden = false
//
//        foodEntryController.performSearch(for: searchTerm) { (_) in
//            DispatchQueue.main.async {
//                self.foodResultsTableView.reloadData()
//            }
//        }
    }
    
//    // MARK: - Table view data source
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return foodEntryController.foodSearchResults.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodResultCell", for: indexPath) as? FoodResultTableViewCell else { return UITableViewCell()}
//        
//        cell.foodResult = foodEntryController.foodSearchResults[indexPath.row]
//        cell.delegate = self
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var foodSearchBar: UISearchBar!
    
}
