//
//  StoreTableViewCell.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 14/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var storeDescriptionLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
