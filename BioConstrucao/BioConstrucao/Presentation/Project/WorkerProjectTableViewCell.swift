//
//  WorkerProjectTableViewCell.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 20/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class WorkerProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionWorker: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension WorkerProjectTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionWorker.delegate = dataSourceDelegate
        collectionWorker.dataSource = dataSourceDelegate
        collectionWorker.tag = row
        collectionWorker.setContentOffset(collectionWorker.contentOffset, animated: false) // Stops collection view if it was scrolling
        collectionWorker.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            collectionWorker.contentOffset.x = newValue
        }
        
        get {
            return collectionWorker.contentOffset.x
        }
    }
}
