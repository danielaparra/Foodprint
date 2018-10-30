//
//  FoodResultTableViewCell.swift
//  Foodprint
//
//  Created by Daniela Parra on 10/30/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class FoodResultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addFood(_ sender: Any) {
    }
    
    @IBOutlet weak var foodResultLabel: UILabel!
    @IBOutlet weak var servingsTextField: UITextField!
    
    // Add delegate variable
    
}
