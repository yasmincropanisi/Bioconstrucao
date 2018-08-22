//
//  File.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 13/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import UIKit

class Store: NSObject {
    var id: String?
    var name: String?
    var location: Location?
    var image: UIImage?
    var state: String?
    var city: String?
    var details: String?

    var pathImage: String?
    
    init(id: String) {
        self.id = id
    }
    override init() {
        super.init()
    }
}
