//
//  User.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var image: UIImage?
    var city: String?
    var state: String?
    var pathImage: String?
    
    init(id: String) {
       
        self.id = id
    }
    
    override init() {
        super.init()
    }
    
    init(id: String, name: String, pathImage: String) {
        self.id = id
        self.name = name
        self.pathImage = pathImage
    }
  
}
