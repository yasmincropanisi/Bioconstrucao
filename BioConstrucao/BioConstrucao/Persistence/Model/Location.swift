//
//  Location.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class Location {
    var state: String?
    var city: String?
    var latitude: Float?
    var longitude: Float?
    var isCapital: Bool?
    var image: UIImage?
    init(state: String?, city: String?, latitude: Float?, longitude: Float?, isCapital: Bool?) {
        self.city = city
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.isCapital = isCapital
    }
    
    init (state: String, city: String) {
       self.state = state
       self.city = city
    }
}
