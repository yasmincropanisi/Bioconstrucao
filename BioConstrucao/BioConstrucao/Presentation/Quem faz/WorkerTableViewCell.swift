//
//  WorkerTableViewCell.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 14/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class WorkerTableViewCell: UITableViewCell {

    @IBOutlet weak var worketLocationLabel: UILabel!
    
    @IBOutlet weak var workerNameLabel: UILabel!
    @IBOutlet weak var workerImageView: UIImageView!
    @IBOutlet weak var workerDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
