//
//  ImageDescribed.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class ImageDescribed {
    var pathImage: String
    var description: String
    var image: UIImage?
    init(pathImage: String, description: String) {
        self.description = description
        self.pathImage = pathImage
    }
}
