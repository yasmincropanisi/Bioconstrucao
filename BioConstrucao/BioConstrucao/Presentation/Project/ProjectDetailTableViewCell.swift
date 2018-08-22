//
//  ProjectDetailTableViewCell.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 20/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class ProjectDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var projectLocationLabel: UILabel!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
