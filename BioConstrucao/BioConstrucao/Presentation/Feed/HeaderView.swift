//
//  HeaderView.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 09/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: NSObjectProtocol {
    func seeAllTapped(_ view: HeaderView)
}

class HeaderView: UIView {
    @IBOutlet var title: UILabel!
    @IBOutlet var seeAllButton: UIButton!
    weak var delegate: HeaderViewDelegate?
    
    func setNumberOfElements(number: Int) {
        if number < 1000 {
            self.seeAllButton.setTitle("\(NSLocalizedString("seeAll", comment: "")) (\(number))", for: .normal)
        } else {
            self.seeAllButton.setTitle("\(NSLocalizedString("seeAll", comment: "")) (\(number/1000) mil)", for: .normal)
        }
    }
    
    @IBAction func seeAll(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.seeAllTapped(self)
        }
    }
}
