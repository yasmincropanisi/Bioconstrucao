//
//  File1.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//


import UIKit

class FeedProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionProject: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FeedProjectTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionProject.delegate = dataSourceDelegate
        collectionProject.dataSource = dataSourceDelegate
        collectionProject.tag = row
        collectionProject.setContentOffset(collectionProject.contentOffset, animated: false) // Stops collection view if it was scrolling
        collectionProject.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            collectionProject.contentOffset.x = newValue
        }
        
        get {
            return collectionProject.contentOffset.x
        }
    }
}

