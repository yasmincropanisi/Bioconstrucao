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
    var city: String?
    var pathImage: String?
    var categories: [String]?
    var workers: [Worker]?
    var details: String?



    
    init(id: String) {
        self.id = id
    }
    
    init(id: String, name: String, pathImage: String, state: String) {
        self.id = id
        self.name = name
        self.pathImage = pathImage
        self.state = state
    }
    
    override init() {
        super.init()
    }
}
