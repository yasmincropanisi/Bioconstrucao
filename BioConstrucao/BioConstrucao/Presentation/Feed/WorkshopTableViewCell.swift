//
//  WorkshopTableViewCell.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 13/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class WorkshopTableViewCell: UITableViewCell {

    @IBOutlet weak var workshopDescription: UILabel!
    @IBOutlet weak var workshopName: UILabel!
    @IBOutlet weak var workshopLocal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(workshop: Workshop) {
        
        self.workshopName.text = workshop.name
        self.workshopLocal.text = "\(workshop.city!) , \(workshop.state!) "
        self.workshopDescription.text = workshop.details

    }
    
}
