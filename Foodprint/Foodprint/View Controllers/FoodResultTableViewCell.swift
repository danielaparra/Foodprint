//
//  FoodResultTableViewCell.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol FoodResultCellDelegate: class {
    func addFoodResult(from cell: FoodResultTableViewCell)
}

class FoodResultTableViewCell: UITableViewCell {

    private func updateViews() {
        guard let foodResult = foodResult else { return }
        
        foodResultLabel.text = foodResult.food
        servingsTextField.text = "1"
    }
    
    @IBAction func addFood(_ sender: Any) {
        
    }
    
    @IBOutlet weak var foodResultLabel: UILabel!
    @IBOutlet weak var servingsTextField: UITextField!
    
    var foodResult: FoodRep? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: FoodResultCellDelegate?
    
}
