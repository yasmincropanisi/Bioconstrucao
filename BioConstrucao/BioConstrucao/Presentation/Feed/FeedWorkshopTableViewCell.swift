//
//  File.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import UIKit
class FeedWorkshopTableViewCell: UITableViewCell {
  
 
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
