//
//  SocialAction.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

class SocialAction: NSObject {
    var name: String?
    var id: String?
    var state: String?
    
    init(id: String) {
        self.id = id
    }
    
    override init() {
        super.init()
    }
}
