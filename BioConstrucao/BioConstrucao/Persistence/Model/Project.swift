//
//  Project.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 07/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import UIKit


class Project: NSObject {
    var name: String?
    var id: String?
    var image: UIImage?
    var state: String?
    var pathImage: String?
    init(id: String) {
        self.id = id
    }
    
    override init() {
        super.init()
    }
}
